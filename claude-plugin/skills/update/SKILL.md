---
name: update
description: Sync the second-brain KB with fresh content from Google Drive, Gmail, and Slack, then re-index with qmd.
version: 2.0.0
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

### 1b. Relevance filter

Only proceed with files that match **at least one** of:
- Path contains terms relevant to the user's work (e.g., names of products, programs, customers, teammates, recurring meeting types like 1on1/MBR/WBR/PRFAQ/RFC, planning artifacts like OP1/OP2/roadmap)
- Extension is `.pdf`, `.md`, `.txt`, `.docx`, `.pptx`, `.xlsx`
- File is a Google Workspace stub (`.gdoc`, `.gsheet`, `.gslides`) — read via MCP in 1c

Skip: videos, images, binaries, personal non-work folders.

> Customize the relevance terms over time. Start with the names in `Knowledge/Context/role-context.md` and `Knowledge/Context/team-context.md`; add product/program names as they come up.

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

### 3.5a. Identify existing customer profiles

List all `.md` files in `~/Documents/second-brain/Knowledge/Customers/`, excluding `_template.md`. These are the known customers to scan for in exported content.

### 3.5b. Scan exported content for customer mentions

For each file written in Steps 1–3, check for mentions of:
- Each known customer (from 3.5a)
- Any company name appearing ≥2 times in customer-facing contexts (OEM deal, integration partner, enterprise contract, customer escalation, ARR/revenue mention)

**Do not create profiles for:** Mapbox colleagues, one-time event attendees, vendors/suppliers, tool providers (e.g. AWS, Slack, Google), or companies that only appear in passing references.

### 3.5c. Update profiles for known customers

For each known customer that appears in the exported content:
1. Read their existing profile (`Knowledge/Customers/<customer>.md`)
2. Identify what's new — new contacts, product requests, contract changes, escalations, timeline updates
3. Append a dated update section at the bottom:
   ```markdown
   ## YYYY-MM-DD Update
   *Source: [gmail-digest / slack-digest / drive doc name]*
   - [bullet: new context]
   ```
4. If any Quick Facts or Key Contacts fields are still blank, populate them from the new content
5. Update the `*Last updated:*` line to the current date/time

### 3.5d. Create profiles for net-new companies

For each net-new company that meets the ≥2 appearance threshold:
1. Copy `_template.md` to `Knowledge/Customers/<slug>.md` (lowercase, hyphens for spaces)
2. Fill in whatever Quick Facts are available from the content
3. Add a discovery update section:
   ```markdown
   ## YYYY-MM-DD Update
   *Source: auto-discovered from [gmail-digest / slack-digest / drive doc]*
   - First appeared in: [brief context of where/how they showed up]
   ```
4. Do NOT fabricate fields — leave blanks as-is if data is absent

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

## Step 6: Write timestamp

Write today's date and time (ISO 8601) as the first line of `~/Documents/second-brain/Raw/last-updated.md`:

```
2026-04-26T14:30:00
```

Overwrite the file completely — this is a single-line timestamp, not a log.

---

## Step 7: Report what was updated

Tell the user:
- **Google Drive:** N files exported or updated (list titles)
- **Gmail:** N threads summarized (date range covered)
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
