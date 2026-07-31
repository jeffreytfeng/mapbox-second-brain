---
name: update
description: Sync the second-brain KB with fresh content from Google Drive, Gmail, and Slack, then re-index with qmd.
version: 2.3.0
---

# /update — KB Sync

When invoked, pull fresh content from Google Drive, Gmail, and Slack since the last export, write it to `~/Documents/second-brain/Raw/`, update tasks, and re-index the KB.

---

## Step 0: Establish the cutoff date

Read `~/Documents/second-brain/Raw/last-updated.md` to get the timestamp of the last export.
- If the file exists, use the ISO 8601 timestamp on the first line as the cutoff.
- If the file does not exist, default to **14 days ago** and note that this is the first run.

Keep the cutoff date in memory — you'll use it to filter all three sources below.

---

## Step 1: Google Drive — scan for new or updated files

### 1a. Discover files via local filesystem

Run a Bash `find` command on `~/Google Drive/` to list files modified since the cutoff:

```bash
find ~/Google\ Drive/ -newer ~/Documents/second-brain/Raw/last-updated.md -type f \
  ! -name "*.DS_Store" ! -name "*.tmp" ! -name "*.gdoc" ! -name "*.gsheet" ! -name "*.gslides"
```

If `last-updated.md` doesn't exist, use `-mtime -14` instead of `-newer`.

### 1b. Relevance filter (for filesystem results)

Only proceed with files that match **at least one** of:
- Path contains terms relevant to the user's work (e.g., names of products, programs, customers, teammates, recurring meeting types like 1on1/MBR/WBR/PRFAQ/RFC, planning artifacts like OP1/OP2/roadmap)
- Extension is `.pdf`, `.md`, `.txt`, `.docx`, `.pptx`, `.xlsx`
- File is a Google Workspace stub (`.gdoc`, `.gsheet`, `.gslides`) — read via MCP in 1c

Skip: videos, images, binaries, personal non-work folders.

> Customize the relevance terms over time. Start with the names in `Knowledge/Context/role-context.md` and `Knowledge/Context/team-context.md`; add product/program names as they come up.

### 1b.5. Drive MCP scan — shared docs owned by others

The local filesystem only contains files explicitly cached to disk. Docs shared with the user by colleagues — strategy docs, customer decks, PRFAQs, 1:1 notes — live on Drive and won't appear in 1a unless already cached locally.

Run a Drive MCP search to catch these:

```
modifiedTime > '<cutoff-as-RFC3339>'
```

Use `excludeContentSnippets: true` and `pageSize: 50`. Paginate if `nextPageToken` is returned.

**Relevance filter — include files where title or owner signals work context:**
- Title contains any of the user's relevance terms (same term list as 1b — products, programs, customers, teammates, meeting/planning artifacts)
- mimeType is `application/vnd.google-apps.document`, `application/vnd.google-apps.spreadsheet`, or `application/vnd.google-apps.presentation`
- File was **shared with the user** (i.e., `owner` is not the user's own email)

**Skip:** files already found in Step 1a (dedup by title), video/image/binary files, files owned by the user (those are caught in 1a), files with no work-relevant title signal.

**Dedup against existing Raw/ files:** before reading, grep `~/Documents/second-brain/Raw/*.md` for the Drive ID. If already exported this run or in a recent prior run, skip.

**Read and export** each relevant result using `read_file_content`, following the same naming and write logic as Step 1c. Log each file with its Drive ID, owner, and last modified date.

### 1c. Read and export each relevant file

For each relevant file found:
1. If it's a Google Workspace file (or you need the latest server-side content), use the Google Drive MCP:
   - Search for the file by name using `search_files`, get its Drive ID
   - Read content using `read_file_content`
2. For regular files (`.pdf`, `.md`, `.txt`, etc.), read directly from the local path
3. Derive a clean filename: lowercase, hyphens for spaces, `.md` extension (e.g. `manager-1on1-apr-27.md`)
4. Write the exported content to `~/Documents/second-brain/Raw/<filename>.md`
5. If a file with the same name already exists, overwrite it (it's an update)

Log each file exported: title, source path, last modified date.

---

## Step 1.5: Google Meet Recordings folder — Gemini-generated meeting notes

If Gemini note-taking is enabled for your meetings, Google files the notes docs into a "Meet Recordings" folder in your Drive. **Meetings you organized** land there automatically as a **direct Doc**. **Meetings you only attended** do NOT auto-file — Google does not place a shortcut, so those arrive via the Gmail path in Step 1.6 (or via shortcuts you file yourself; see 1.6d for automating that). Both kinds are readable (see 1.5a). **Always sync this folder on every `/update` run** — it's the canonical source of meeting context.

**Folder ID:** `<your-meet-recordings-folder-id>`
<!-- Find it: open the "Meet Recordings" folder in Drive; the ID is the last segment of the URL (drive.google.com/drive/folders/<ID>). Paste it here once during setup. -->

> This step uses the `gws` CLI (Google Workspace CLI). If you don't have it installed, fall back to the Drive MCP for direct docs — but note the MCP cannot resolve shortcuts (see 1.5a), so attended-meeting shortcuts will be index-only until you install gws.

### 1.5a. Enumerate the folder (use gws — it returns shortcut targets)

**Use `gws`, not the Drive MCP.** The MCP does not surface `shortcutDetails`, which is exactly the field needed to resolve shortcuts. gws returns it directly:

```bash
gws drive files list --params '{"q":"'"'"'<your-meet-recordings-folder-id>'"'"' in parents and trashed=false and modifiedTime > \"<cutoff-as-RFC3339>\"","fields":"files(id,name,mimeType,modifiedTime,shortcutDetails(targetId,targetMimeType)),nextPageToken","pageSize":"1000","orderBy":"modifiedTime desc"}' --format json
```

Paginate on `nextPageToken` if present. Each result is one of:

- `application/vnd.google-apps.document` → **direct Google Doc** (a meeting the user organized). The readable doc ID is `id`.
- `application/vnd.google-apps.shortcut` → **shortcut** to a doc owned elsewhere (a meeting the user attended but didn't organize). The readable doc ID is `shortcutDetails.targetId` — **NOT** `id`. **These are fully resolvable via gws — do not treat shortcuts as index-only.**

Build a list of `(name, readableDocId, kind)`, where `readableDocId = id` for direct docs and `shortcutDetails.targetId` for shortcuts.

**Dedup by `readableDocId` before reading:** Google sometimes drops both a direct doc and a shortcut pointing to the same target into the folder (co-owned meetings). Collapse those to one read.

### 1.5b. Read each doc (direct doc or resolved shortcut target)

For each unique `readableDocId`, export the content via gws:

```bash
gws drive files export --params '{"fileId":"<readableDocId>","mimeType":"text/plain"}' -o <tmpfile>
```

The Gemini notes have a stable structure: `📝 Notes` (Summary / Details / Next steps) followed by the transcript. Capture both — summary + bullets are the load-bearing content; the transcript is verification source if anything is ambiguous.

**Skip rule:** if the doc's Summary section says *"A summary wasn't produced for this meeting because there wasn't enough conversation in a supported language"* — the recording is empty/short. Note in the index but don't write a content file.

**Access-failure fallback:** if `files export` returns 403/404 (your access to a shortcut target was revoked), fall back to the Gmail path in Step 1.6 for that meeting; if that also fails, log the entry index-only.

### 1.5c. Dedup against existing Raw/ files (CRITICAL)

Some Drive recordings overlap with existing 1:1 notes files (an existing 1:1 file may already carry the Drive ID for a recording). Before writing a new file:

1. Grep `~/Documents/second-brain/Raw/*.md` for the Drive ID. If a match exists → recording is already incorporated; skip or refresh in place.
2. If the meeting matches an existing 1:1 file by participant (e.g. a new recording with a person whose `<person>-1on1-notes.md` exists), **append** a new dated section rather than creating a parallel file. Order sections newest-first.
3. Only create a new top-level file when the meeting is net-new and doesn't fit an existing 1:1 file.

### 1.5d. Naming convention for net-new files

`meet-recording-<slug>-YYYY-MM-DD.md` — slug uses participant initials or topic, kebab-case.

Examples:
- `meet-recording-alex-sam-1on1-2026-04-30.md` (multi-person sync)
- `meet-recording-roadmap-strategy-huddle-2026-04-30.md` (topic-named)

### 1.5e. Recurring / low-signal meetings — index only by default

Some recordings are recurring and rarely carry net-new content beyond what's already in active.md. Default to **index-only** (no content file) for recurring low-signal meetings, e.g.:
- Daily standups
- Recurring team syncs (unless the agenda flags a specific decision)
- Recurring leadership or review meetings that mostly restate known status
- Onboarding series sessions

> List your own recurring meetings here as you notice them — a maintained skip-list keeps the KB high-signal.

Exception: capture content for any of these if the Summary surfaces a clear decision, owner change, deadline, or stakeholder ask directed at the user. Default skip is safer than default capture for recurrings.

### 1.5f. Update the recordings index

Append/update `~/Documents/second-brain/Raw/meet-recordings-index.md` with this run's results:
- Section: "Direct Google Docs (user organized)" — add new rows with `readableDocId` + status (Captured / Already in KB / Skipped-empty)
- Section: "Resolved shortcuts (user attended, not organized)" — add rows with date, meeting title, `readableDocId` (= targetId) + status. These carry content, not metadata only.
- Section: "Net-new context added to KB this sync" — short bullets describing what was captured this run

If the index file does not yet exist, create it using the structure above (Direct docs table → Resolved shortcuts table → Net-new this sync).

### 1.5g. Known limitation

Shortcuts in this folder **are** resolvable — read their `shortcutDetails.targetId` via gws (1.5a/1.5b). The only true gap is a meeting that produced **no** Gemini doc at all (short / late-scheduled / strategic meetings sometimes don't trigger Gemini). When the calendar shows a known-attended meeting for a day but neither the folder scan nor Step 1.6 surfaces it, cross-check Gmail outbound for a decision-capture email before declaring "no new context."

---

## Step 1.6: Gmail fallback — Gemini notes not caught by the folder scan

**With Step 1.5 resolving shortcut targets via gws, the folder scan captures nearly every meeting the user attended** (owned = direct doc; attended = shortcut → target). Step 1.6 is a **fallback**, not the primary path, for two remaining cases:
1. A meeting whose notes doc hasn't landed in the folder (no shortcut filed, or timing lag), but whose Gemini notes email is already in Gmail.
2. "No summary produced" notification emails from `meetings-noreply@google.com`.

**Dedup first:** before reading any doc here, check its ID against the `readableDocId`s already read in Step 1.5. Skip anything already captured.

### 1.6a. Find Gemini notes emails since cutoff

Search Gmail with:
```
from:gemini-notes@google.com newer_than:<cutoff-as-YYYY/MM/DD>
```

Also catch "problem" emails (meeting recorded but no summary generated):
```
from:meetings-noreply@google.com newer_than:<cutoff-as-YYYY/MM/DD>
```

For each email found, fetch the **full** message (`get_message`, `messageFormat: FULL_CONTENT`) and extract the doc ID — the segment after `/document/d/` in the `Open meeting notes` / `Notes by Gemini` link (present in both `htmlBody` and as the URL in the message). The snippet alone does NOT contain the link; fetch the full body.

### 1.6b. Read each doc — with a two-level fallback

For each doc ID extracted, export the doc via gws (`files export`, `mimeType: text/plain`). Apply the same rules as Step 1.5 (empty summary → index-only; recurring low-signal → index-only unless a decision/deadline/ask for the user surfaces; meaningful → write to `Raw/meet-recording-<slug>-YYYY-MM-DD.md`, dedup per Step 1.5c).

**Critical fallback — the email body is itself a complete capture source.** The gemini-notes email's **plaintext body contains the full Summary + Suggested next steps**. So:
- If the doc export succeeds → use it (has the transcript too).
- If the export returns **403/404** (organizer deleted the doc or revoked your access — common for older meetings) → **do NOT drop the meeting.** Capture the email's `plaintextBody` (Summary + Next steps) into the `meet-recording-*` file instead, and note `*Source: gemini-notes email body (target doc unavailable)*` in the header. This is the last line of defense that guarantees no summary is ever lost.

### 1.6c. Update the recordings index

Add a new section "Via Gemini notes emails (Step 1.6)" to `meet-recordings-index.md` for this run — separate from the folder-scan results so it's clear which path surfaced each doc.

### 1.6d. Optional automation — auto-file shortcuts into the folder

Google does **not** auto-file a shortcut for meetings you only attended. You can automate this with a small scheduled script (launchd/cron) that:
1. Finds Gemini-notes docs shared with you: Drive query `sharedWithMe = true and name contains 'Notes by Gemini'` (needs no Gmail access)
2. Dedupes against the folder's existing shortcut targetIds + direct doc ids
3. Creates only the missing shortcuts (idempotent)

If you set this up, have `/update` call the same script rather than re-implementing shortcut creation inline, so the scheduled job and the manual sync never drift. Report its result line in the Step 7 summary.

---

## Step 2: Gmail — summarize relevant threads since cutoff

Use the Gmail MCP to pull threads since the cutoff date.

**Search query:** `from:@<your-company-domain> OR to:@<your-company-domain> after:<cutoff-as-YYYY/MM/DD>`
<!-- Replace <your-company-domain> with the company email domain (e.g., acme.com). -->

**Relevance filter — include threads where:**
- Sender or recipient is a known colleague (`@<your-company-domain>`)
- Subject or snippet relates to: the products, programs, customers, or planning artifacts the user owns (pull these from `Knowledge/Context/role-context.md` and `goals.md`)

**Do not include:** automated notifications, calendar invites, marketing emails, HR/benefits, expense reports.

**Output:** Write a single file `gmail-digest-<YYYY-MM-DD>.md` to `~/Documents/second-brain/Raw/`:

```markdown
# Gmail Digest — <date range>
*Exported: <today's date>*

## Thread: <subject>
**From:** <sender> | **Date:** <date>
**Summary:** <2-3 sentence summary of what was discussed or decided>
**Action items:** <any explicit asks or follow-ups, or "None">

---
```

One section per relevant thread. If more than 15 threads, prioritize by recency then by sender (direct manager, skip-level, peer leads, direct reports first).

---

## Step 2.5: JIRA — surface ticket updates relevant to the user

If the Atlassian MCP is connected, pull JIRA issues that have activity since the cutoff and are directly relevant to the user. Skip this step (and note it in the report) if the MCP is unavailable.

### 2.5a. Run the JQL queries

Execute these four queries via the Atlassian MCP's `searchJiraIssuesUsingJql` tool. For each, set `maxResults: 25` and request these fields: `summary`, `status`, `assignee`, `reporter`, `priority`, `updated`, `comment`, `labels`, `project`.

<!-- Replace <your-email> with your work email, <your-jira-handle> with the handle used in @-mentions, and <YOUR-PROJECTS> with the JIRA project keys you follow. -->

**Query 1 — Assigned to the user:**
```
assignee = "<your-email>" AND updated >= "<cutoff-as-YYYY-MM-DD>" ORDER BY updated DESC
```

**Query 2 — Reported by the user and recently updated:**
```
reporter = "<your-email>" AND updated >= "<cutoff-as-YYYY-MM-DD>" ORDER BY updated DESC
```

**Query 3 — The user is watching:**
```
watcher = "<your-email>" AND updated >= "<cutoff-as-YYYY-MM-DD>" ORDER BY updated DESC
```

**Query 4 — @-mentioned in comments (your projects):**
```
project in (<YOUR-PROJECTS>) AND updated >= "<cutoff-as-YYYY-MM-DD>" AND text ~ "<your-jira-handle>" ORDER BY updated DESC
```

Dedup across queries by ticket key. Keep only tickets where at least one of:
- Status changed since the cutoff
- A new comment was added since the cutoff
- The user is directly mentioned in the latest comment or description

### 2.5b. Relevance filter

Skip tickets that are:
- Status = Closed/Done/Won't Do with no comments since cutoff
- Automated Jira bot comments only (e.g., "Automation for Jira added a new comment")
- Unrelated to the user's domains (the products, programs, and customers listed in `role-context.md` and `goals.md`)

### 2.5c. Extract signal per ticket

For each ticket that passes the filter, extract:
- **Key** (e.g., `PROJ-1234`)
- **Summary** (title)
- **Status** + any status change since cutoff
- **Latest comment** since cutoff — who wrote it, what they said, any ask directed at the user
- **Action item for the user** — explicit or implied ("@<user> can you...", "PM input needed", etc.)

### 2.5d. Write output

Write a single file `jira-digest-<YYYY-MM-DD>.md` to `~/Documents/second-brain/Raw/`:

```markdown
# JIRA Digest — <date range>
*Exported: <today's date> | Source: <your-site>.atlassian.net*

## <TICKET-KEY>: <summary>
**Project:** <project> | **Status:** <status> | **Priority:** <priority>
**Updated:** <last updated date>
**Latest activity:** <1–2 sentence summary of what changed — new comment, status change, etc.>
**Action item:** <explicit ask or "None">

---
```

One section per ticket, ordered: tickets with explicit asks first, then status changes, then FYI-only updates. Cap at 20 tickets; if more, prioritize by your most important projects, then by recency.

### 2.5e. Integrate into active.md (Step 4)

When Step 4 processes action items, treat explicit JIRA asks from the digest as new tasks — format them like:

```
- [ ] **Respond to [person] on [TICKET-KEY]** — [brief context] | due: this week | source: JIRA ([date])
```

Only create a task if there's a genuine ask or PM input needed — not for pure FYI updates.

---

## Step 3: Slack — summarize relevant messages since cutoff

Use the Slack MCP to pull messages from the user's Slack workspace.

**Discovery:** Use `slack_search_channels` to get the full list of channels the user is a member of — do not hardcode a subset. Check all subscribed channels and all DMs for activity since the cutoff.

**Relevance filter — include messages that:**
- Mention the user directly (`@<user>` or `@<user.handle>`)
- Discuss: the products, programs, customers, or decisions the user owns or partners on
- Are from a known colleague (not bots, not automated alerts)

**Do not include:** emoji reactions, bot notifications, scheduling messages, standup bots.

**Output:** Write a single file `slack-digest-<YYYY-MM-DD>.md` to `~/Documents/second-brain/Raw/`:

```markdown
# Slack Digest — <date range>
*Exported: <today's date>*

## #<channel-name> — <topic or thread subject>
**Date:** <date> | **From:** <person>
**Summary:** <2-3 sentence summary>
**Action items:** <if any, or "None">

---
```

Group by channel. Merge short related messages into one entry.

---

## Step 3.5: Update customer profiles in Knowledge/Customers/

Using the content exported in Steps 1–3 (Drive docs, Gmail digest, Slack digest), scan for mentions of known customers and update their profiles.

### 3.5a. Discover known customers

List all `.md` files in `~/Documents/second-brain/Knowledge/Customers/` (excluding `_template.md`). Extract the customer name from each filename (e.g., `acme.md` → "Acme").

### 3.5b. Scan exported content for customer mentions

For each known customer, grep the exported content from this run (Drive exports in `Raw/`, the Gmail digest, the Slack digest) for the customer name and any known aliases.

Also scan for net-new external companies appearing in customer-facing contexts (OEM, partner, integration, enterprise deal, account, POC, customer escalation) that don't yet have a profile. A company is a candidate for a new profile if it appears ≥2 times across sources in these contexts.

### 3.5c. Update existing customer profiles

For each known customer where new content was found:
1. Read their profile file at `~/Documents/second-brain/Knowledge/Customers/<customer>.md`
2. Extract relevant facts: new contacts mentioned, product/API usage, pain points, decisions, asks, escalations
3. Append a dated update section at the bottom of the file (newest first):

```markdown
## YYYY-MM-DD Update
*Source: Gmail digest / Slack digest / Drive: <filename>*
- [bullet: new fact or development]
- [bullet: new fact or development]
```

4. If the Quick Facts or Key Contacts sections are still blank and the new content fills them in, update those sections in place as well
5. Update the `*Last updated:*` line at the top

### 3.5d. Create new customer profiles

For each net-new company identified in 3.5b:
1. Copy `_template.md` to `~/Documents/second-brain/Knowledge/Customers/<company-slug>.md`
2. Fill in Quick Facts from what was found (even if partial)
3. Add a `## YYYY-MM-DD Update` section with the discovery context
4. Note in the Step 7 report that a new customer profile was created

**Do not create profiles for:** colleagues, one-time email senders, vendors (AWS, Stripe, etc.), or companies mentioned only in passing.

---

## Step 4: Update tasks in Tasks/active.md

Read `~/Documents/second-brain/Tasks/active.md`.

### 4a. Extract new action items

Scan all content exported in Steps 1–3 for explicit action items directed at the user:
- Gmail: "Action items" fields from the digest
- Slack: "Action items" fields from the digest
- Drive docs: any decisions, follow-ups, or asks directed at the user

For each new action item not already in `active.md`, add it under the appropriate section with status **Not Started**.

### 4b. Update status of existing tasks

Review existing tasks in `active.md` against the newly synced content:
- If a task was completed (mentioned as done in email/Slack/docs) → mark **Completed Today**
- If a task is actively being discussed → mark **In Progress**
- If a task is waiting on someone else or blocked → mark **Blocked** (note the blocker)
- If a task has no recent signal → leave status unchanged

### 4c. Write updated active.md

Preserve the existing structure and formatting. Do not remove tasks marked Blocked or In Progress — only update their status. Remove tasks marked Completed Today after confirming they're done (or move to a "Completed" section if one exists).

---

## Step 5: Re-index the KB

Run these two commands in sequence:

```bash
qmd collection add Documents/second-brain/raw
qmd update
```

If `qmd collection add` exits with "Collection 'raw' already exists" — this is expected. Treat it as success and proceed to `qmd update`. Any other failure should be reported clearly and not silently continued.

Skip this step and note it in the report if no files were written or modified in Steps 1–3.

---

## Step 6: Write timestamp (BOTH files — required every run)

Write today's date and time (ISO 8601) as the first line of **both** of these files, with identical content:

1. `~/Documents/second-brain/Raw/last-updated.md` — the cutoff source read in Step 0 and used by `find -newer` in Step 1a
2. `~/Documents/second-brain/Raw/.last-updated` — the freshness marker read by CLAUDE.md's session-start check

```
2026-04-26T14:30:00
```

Overwrite each file completely — a single-line timestamp, not a log. Never skip this step, even if no new content was found in Steps 1–3 (a run that found nothing new is still a completed sync). One command covers both:

```bash
date +%Y-%m-%dT%H:%M:%S%z | tee ~/Documents/second-brain/Raw/last-updated.md > ~/Documents/second-brain/Raw/.last-updated
```

---

## Step 7: Report what was updated

Tell the user:
- **Google Drive:** N files exported or updated (list titles)
- **Meet Recordings:** N direct docs captured + N shortcuts resolved (call out any with empty Gemini summaries that were skipped, and whether any existing 1:1 files were appended-to vs. net-new files created)
- **Gmail:** N threads summarized (date range covered)
- **JIRA:** N tickets surfaced — list any with explicit asks; note how many were FYI-only (or that the step was skipped)
- **Slack:** N threads summarized, from which channels
- **Customers:** N profiles updated, N net-new profiles created (list names)
- **Tasks:** N new items added, N status updates made
- **Skipped:** anything relevant that was excluded and why
- **KB status:** whether indexing succeeded or was skipped

Keep the report concise — a short table or bullet list, not a wall of text.

---

## What NOT to do
- Do not export files unrelated to work (personal docs, non-work shared files)
- Do not include full email or Slack message text — summaries only, 2-3 sentences max per thread
- Do not re-export Google Drive files that haven't changed since the cutoff
- Do not run `qmd update` if no files were changed
- Do not overwrite existing tasks with incorrect status — read `active.md` before writing
