---
name: granola-sync
description: Sync Granola meeting notes into Google Drive as Google Docs — work notes go to the work Drive "Meet Recordings" folder (renamed to match the Google Calendar meeting title), non-work/personal notes go to a personal "Meet Recordings" folder. Use when the user types "/granola-sync", asks to "sync Granola notes", "copy Granola to Drive", or "transfer meeting notes".
---

# Granola → Google Drive Sync

Copies meeting notes from Granola into Google Drive, split by whether the note is work or personal:

- **Work notes** → work Drive **Meet Recordings** folder, renamed to match the corresponding Google Calendar event so it sits alongside the Gemini notes with a consistent naming convention. This is the same folder `/update` Step 1.5 scans, so synced notes get picked up into the KB on the next sync.
- **Personal/non-work notes** → a separate **Meet Recordings** folder in your personal Google account's My Drive, shared with your work account as Editor, so the existing work-authenticated Drive tools can write into it without a second OAuth connection. These are not matched against the work calendar — that calendar doesn't contain personal events.

> If you don't keep a separate personal Google account, simplify: drop the personal folder and treat the work folder as the only destination, or exclude personal notes entirely.

## Fixed configuration

Fill these in once during setup:

- **Source**: Official Granola MCP server (`granola` MCP, tools: `list_meetings`, `get_meetings`, `get_account_info`). Authenticated as `<your-granola-account>`.
- **Calendar for matching**: Google Calendar connector, primary calendar of `<your-work-email>`. Only used for work notes.
- **Work destination folder**: Google Drive folder `Meet Recordings`, ID `<your-meet-recordings-folder-id>` (My Drive of `<your-work-email>`). Same ID as `/update` Step 1.5.
- **Personal destination folder**: a `Meet Recordings` folder in `<your-personal-google-account>`'s My Drive, shared with `<your-work-email>` (Editor). Resolve its file ID once via the Drive connector's `search_files` with `sharedWithMe = true and title contains 'Meet Recordings' and mimeType = 'application/vnd.google-apps.folder'`, confirm the owner is your personal account, then cache the ID in the state file's `personal_folder_id` field so future runs don't need to re-search. If it can't be found (not yet shared, or shared under a different name), stop and ask the user to confirm the folder name/sharing rather than guessing or creating a new folder.
- Create docs in either folder with the Google Drive connector's `create_file`.
- **State file**: `~/Documents/second-brain/Raw/granola-sync-state.json`. Has a `last_sync` timestamp, `personal_folder_id` (cached, see above), a `synced` map (Granola doc ID → `{drive_doc_id, drive_title, meeting_start, synced_at, destination: "work"|"personal"}`), and an `excluded` map (Granola doc ID → `{title, reason, meeting_start, excluded_at}`) reserved for notes that are genuinely unsyncable (e.g. empty content) rather than just personal — personal notes go to the personal folder instead of being excluded.
- **Naming convention** for work notes (matches the existing Gemini notes in the folder):
  `<Calendar Meeting Title> - YYYY/MM/DD HH:MM TZ - Notes by Granola`
  Example: `Search Leadership - 2026/08/03 08:30 PDT - Notes by Granola`
  Use the **calendar event's** start time, formatted in your local timezone.
- **Naming convention** for personal notes: `<Granola Title> - YYYY/MM/DD HH:MM TZ - Notes by Granola` using Granola's own note title and start time (no calendar matching attempted).

## Workflow

1. **Preflight**
   - Read `Raw/granola-sync-state.json`. If missing, treat as first run and initialize `{"last_sync": null, "personal_folder_id": null, "synced": {}, "excluded": {}}`.
   - If `personal_folder_id` is not yet cached, resolve it per "Personal destination folder" above and cache it. If it can't be found, don't block the whole run — proceed with work notes, skip personal-note creation for this run, and flag it clearly in the summary so the user knows to check the folder/sharing.
   - If the Granola MCP tools are unavailable or return an auth error, stop and tell the user to authenticate: run `claude` in a terminal → `/mcp` → select `granola` → Authenticate (browser OAuth). Do not attempt to read Granola's local files; they are encrypted.

2. **Pull Granola meetings**
   - `list_meetings` for the window since `last_sync` minus 1 day (overlap catches late-finalized notes). First run: last 30 days.
   - Skip any meeting whose Granola doc ID is already in `synced` or `excluded`.
   - For remaining meetings, `get_meetings` to fetch full note content (summary + notes). Skip meetings with empty/no notes; record them in the run summary as skipped (don't add these to `excluded` — an empty note may get filled in later).

3. **Classify each note: work vs. personal**
   - Read the note's content and classify it as work-related or personal. Personal: job interviews/recruiting calls (the user as candidate or being recruited elsewhere), medical/family/personal appointments, and other clearly personal content that isn't about your company's business, customers, or team.
   - When unsure, lean toward "work" (the work folder already holds sensitive business content like pricing and headcount decisions — the bar is "personal", not "sensitive").
   - Example: a note about the user interviewing at another company is personal, even if it's titled like a product demo.
   - Work notes proceed to calendar matching (step 4) and go to the work folder. Personal notes skip calendar matching entirely and go straight to doc creation (step 5) targeting the personal folder.
   - Notes that are genuinely unsyncable (not personal, just broken/empty) go in `excluded` with a reason; personal notes are not `excluded` — they're synced, just to the other folder.

4. **Match each work note to a calendar event**
   - `list_events` on the primary calendar with `startTime`/`endTime` bracketing the Granola meeting start ±45 minutes, `orderBy: startTime`.
   - Candidate events: status `confirmed`, not all-day, not `[Lunch]`/`DNS`/`Focus` blocks unless nothing else matches.
   - Pick the event whose start time is closest to the Granola note start time. Tiebreakers, in order: (a) attendee overlap with people named in the note, (b) title similarity to the Granola title.
   - Confidence rules:
     - |Δstart| ≤ 20 min and unique candidate → match.
     - Multiple candidates within 20 min → use tiebreakers; if still ambiguous, mark **low-confidence** and use best guess, flag in run summary.
     - No candidate within 45 min → **no match**: keep the Granola title, name the doc `<Granola Title> - YYYY/MM/DD HH:MM TZ - Notes by Granola (no calendar match)`, flag in run summary. This still goes in the work folder (it's a work note, just unmatched) — don't confuse "no calendar match" with "personal".

5. **Create the Google Doc**
   - Destination folder depends on the step-3 classification: work folder or personal folder.
   - Before creating, search the destination folder for an existing file with the same title to avoid duplicates if state was lost.
   - `create_file` with: `parentId` = destination folder ID, `title` = computed name, `textContent` = markdown body, `contentMimeType` = `text/markdown` (converts to a Google Doc; verify the result's mimeType is `application/vnd.google-apps.document`; if conversion did not happen, retry with `contentMimeType: text/plain`).
   - Markdown body structure (work notes get the calendar-event fields; personal notes omit "Calendar event"/"Attendees"):
     ```
     # <Calendar Meeting Title or Granola Title>

     **Meeting:** <title> | <Weekday DD Month YYYY, HH:MM–HH:MM TZ>
     **Calendar event:** <htmlLink, work notes only>
     **Source:** Granola note "<original Granola title>" (synced <date>)
     **Attendees:** <from calendar event, work notes only; cap at ~10 with "+N more">

     ---

     <full Granola note content>
     ```

6. **Record and report**
   - After each successful create (or exclusion), update `Raw/granola-sync-state.json` (write incrementally, not only at the end, so a failed run doesn't re-create docs or re-evaluate exclusions). Record `destination` ("work" or "personal") on each `synced` entry.
   - Set `last_sync` to now (ISO 8601) at the end.
   - Final summary: two tables (work notes synced, personal notes synced) each showing Granola title → new Doc title (linked) and match confidence for work notes, plus any excluded/skipped/unmatched notes with reasons.

## Guardrails

- Never modify or delete existing files in either folder without explicit user instruction; this skill normally only creates new docs. If the user asks to remove a specific doc (e.g. wrong classification), move it to Drive trash (reversible), not permanent delete, and remove its entry from `synced` in the state file.
- Never sync a note twice (state file + title check are both required).
- Route personal content to the personal folder rather than the work folder (see step 3) — when a note is genuinely ambiguous between work/personal, ask the user rather than guessing.
- Creating docs in the user's own Drive folders (work or personal) is the explicitly requested purpose of this skill and does not need per-run confirmation; anything beyond that (deleting, renaming existing docs, other folders, resharing/permission changes) does.
- If more than 25 notes would be created in one run (combined across both folders), list them and confirm with the user before creating.
