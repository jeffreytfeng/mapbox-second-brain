---
name: learn
description: This skill should be used when the user types "/learn", asks to "capture learnings", "save what we learned", "update memory from this session", or wants to extract insights from the current conversation for future sessions.
version: 1.0.0
---

# /learn — Session Learning Capture

When invoked, review this conversation and extract what's worth keeping for future sessions. Bias hard toward brevity — only save what's genuinely new and non-obvious.

## What to do

### Step 0: Pre-flight — staleness sweep + profile consolidation auto-trigger

Before adding new memories, sweep for stale ones and trigger profile consolidation if any profile is overdue. This step prevents the memory system from monotonically growing.

#### 0a. Memory staleness sweep

MEMORY.md is already loaded into context (auto-loaded per CLAUDE.md). Scan its index entries against what surfaced in this session:

- **Did this session contradict any existing memory?** E.g. a file/repo/path the memory references was deleted; a person's role or cadence changed; a decision was reversed; a workflow was retired.
- **Did this session reveal a memory is now incomplete or generalizable?** E.g. a feedback memory about Tool A now also applies to Tool B; a project memory needs a new sub-bullet.

Compile a **candidate list** of memories to update, remove, or merge. **Do not auto-delete or auto-edit** — the user has sometimes wanted to keep a memory whose fact is stale because the *pattern* is still useful. Surface the candidates in the Step 6 report with the contradiction quoted, and ask the user to confirm each one before changing anything.

#### 0b. Profile consolidation auto-trigger

Read `Knowledge/People/.consolidation-log.md` (one line per person: `<name>: <last-consolidated-YYYY-MM-DD>`; create the file if it doesn't exist with a one-line header).

For each profile in `Knowledge/People/*.md` (skip `_archive/` and any hidden files):

1. Look up the last-consolidated date in the log. No entry = never consolidated.
2. Count `## YYYY-MM-DD Update` sections in the profile whose date is **newer than the last-consolidated date** (or all of them, if never consolidated).
3. **Trigger condition:** days-since-last-consolidation ≥ 30 AND new-dated-updates-since-last ≥ 1.

For each profile that meets the trigger condition, invoke the `consolidate-profile` skill with the person's slug as the argument. The skill handles the consolidation itself, archives raw bullets, and stamps the log.

If a profile is ≥30 days stale but has **no new dated-update sections**, just touch the log entry to today (no-op consolidation) so we don't re-check it until 30 more days pass.

Surface each consolidation that ran in the Step 6 report (which people, how many updates rolled in, what archive entries were written).

If `Knowledge/People/` doesn't exist in this project, skip 0b silently — this auto-trigger only applies to second-brain-shaped projects.

---

### Step 1: Review the conversation
Scan the full session for:
- **Mistakes I made** — wrong assumptions, commands that failed, directions that had to be corrected
- **Surprises** — things that worked differently than expected, unexpected constraints, new facts about the environment
- **Validated approaches** — things the user confirmed worked well or explicitly approved
- **New facts about the user** — preferences, corrections to my assumptions, how they like to work
- **New facts about people** — anything mentioned about stakeholders, teammates, or contacts that updates or adds to what's in their profile

### Step 2: Decide what's worth saving — and where it goes

Ask yourself: *Would knowing this in a fresh session change my behavior?*

Skip it if:
- It's derivable from reading the current code or files
- It's already in CLAUDE.md, me.md, or a summary file
- It's one-time context that won't recur
- It's a fix that's now just in the code

Save it if:
- It's a gotcha that will bite me again (tool quirks, environment constraints)
- It's a workflow preference the user expressed
- It's a correction to a wrong assumption I keep making
- It's new context about the user's role, priorities, or relationships

**Routing rules — where new context belongs:**

| Type of context | Where it goes |
|-----------------|---------------|
| Individual person (goals, working style, relationship update, new ask) | `Knowledge/People/<person>.md` |
| Individual customer (contract details, contacts, product usage, escalations, recent history) | `Knowledge/Customers/<customer>.md` |
| Org-level dynamics, customer table, cross-functional relationships | `Knowledge/Context/team-context.md` |
| Strategic direction, product bets, competitive position | `Knowledge/Context/strategic-context.md` |
| The user's role, deliverables, reporting relationships | `Knowledge/Context/role-context.md` |
| The user's growth edges, feedback patterns | `Knowledge/Context/personal-growth.md` |
| Tool gotchas, workflow rules across projects | `~/.claude/CLAUDE.md` |
| Persistent facts about the user (preferences, background) | `memory/user_profile.md` |
| Feedback on Claude's behavior | `memory/feedback_*.md` |

**Key rule:** `Knowledge/Context/team-context.md` is an index — do NOT add or expand individual person sections there. All person-level context goes to their `Knowledge/People/` file. If no file exists, create one.

### Step 3: Update memory files
Save to `~/.claude/projects/-Users-{your-username}-Documents-second-brain/memory/`:
<!-- Replace {your-username} with your macOS username (e.g., -Users-jdoe-Documents-second-brain). -->

For **feedback/preferences**: create or update `feedback_*.md`
For **project context**: create or update `project_*.md`
For **user info**: update `user_profile.md`

Always update `MEMORY.md` index if you add a new file.

Memory file format:
```
---
name: Short descriptive name
description: One-line description for index
type: feedback | user | project | reference
---

[Rule or fact]

**Why:** [reason or context]
**How to apply:** [when this matters]
```

### Step 3b: Update People profiles
`Knowledge/People/` is the canonical source for all individual person context. This is where person-level updates always go — not `team-context.md`.

Check `~/Documents/second-brain/Knowledge/People/` for any person mentioned in this session.

For each person where new context emerged:
1. Read their existing profile file (e.g., `<person-slug>.md`)
2. Append a dated update section with what's new — don't overwrite existing content
3. If no profile exists yet and the person is likely to recur, create one using the format documented in `Knowledge/People/README.md`

**When creating a new profile, always attempt a LinkedIn lookup:**
- Search the web for `site:linkedin.com "[full name]" <company>` or `"[full name]" <company> LinkedIn`
- Only include the LinkedIn URL if you are confident it's the right person (look for the company in the profile, or corroboration from known prior companies / location)
- If found: add the LinkedIn URL to Quick Facts and enrich the Career Background table with past roles, tenures, and education
- If not found or confidence is low: note "LinkedIn: not confirmed" in Quick Facts and skip rather than guessing
- Use WebSearch or spawn a general-purpose Agent if looking up multiple people at once

What's worth adding:
- A new opinion, stance, or priority they revealed
- A change in their relationship with the user or their team
- Something they asked for, pushed back on, or committed to
- A concern or tension that surfaced
- A decision they made or blocked

What to skip:
- Passing mentions with no new information
- Things already in the profile
- One-off logistics (meeting time, attendance)

Profile update format — append a dated section at the bottom of the file:
```markdown
## [YYYY-MM-DD] Update
- [bullet: new context]
- [bullet: new context]
```

**Do not** update `Knowledge/Context/team-context.md` with individual person detail — that file is an index only.

### Step 3c: Update Customer profiles

Check `~/Documents/second-brain/Knowledge/Customers/` for any customer mentioned in this session.

For each customer where new context emerged:
1. Read their existing profile (`Knowledge/Customers/<customer>.md`)
2. Append a dated update section with what's new — don't overwrite existing content:
   ```markdown
   ## YYYY-MM-DD Update
   - [bullet: new context]
   ```
3. If no profile exists yet and it's a recurring or strategic account: create one from `_template.md`

What's worth adding:
- New product requests or pain points
- Contract changes, expansion signals, or churn risk
- Escalations or relationship changes
- Decisions the customer made or commitments they gave
- Key contacts that changed or were newly identified

What to skip:
- Passing mentions with no new information
- Things already in the profile
- One-off logistics

### Step 4: Update ~/.claude/CLAUDE.md if needed
Only add entries for persistent tool gotchas or workflow rules that apply across all projects, not just this one. Keep it short.

### Step 5: Sync context to Google Drive

After updating local files, push a fresh snapshot to Google Drive so any remote agents (which cannot access local files) stays current.

Use the `mcp__claude_ai_Google_Drive__create_file` tool to create a new file:
- **Title:** `<your-name> — Second Brain Context (Morning Brief)`
- **mimeType:** `text/plain` (Drive will convert to Google Doc)
- **Content:** base64-encoded text combining:
  1. Role summary (title, reports-to, what the user owns)
  2. Current quarter goals with status (from `Knowledge/Context/goals.md`)
  3. Active tasks — Not Started, In Progress, Blocked sections (from `Tasks/active.md`)
  4. Key stakeholders table with dynamic notes (from `Knowledge/Context/goals.md`)
  5. Key dates (from goals.md)

To base64 encode: pipe the text through `base64` via Bash, then pass the output as the `content` field.

Note: The Drive MCP does not support updating existing files — each sync creates a new version. The morning-brief routine searches for the most recent file with this title. Old versions accumulate in Drive; they can be cleaned up manually at drive.google.com if needed.

**Skip this step if:** the Drive MCP is unavailable or returns an auth error. Log the skip in the report.

### Step 6: Report what you saved
Tell the user:
- What you saved and where
- What you chose NOT to save and why
- Whether the Google Drive context doc was updated (include the file ID)
- Any gaps you noticed that they should fill in

#### Memories that shaped this session

List the memory entries from `MEMORY.md` that actively informed behavior during this conversation — the ones that, had they been absent, would have changed how the session went. Format:

- `<memory-file-name>` — one sentence on how it applied this session.

Skip memories that were loaded but didn't fire. The goal is to surface which memories are load-bearing vs decorative, so over time the user can see which to keep, promote, or archive.

If no memories meaningfully shaped the session, say so explicitly (one line: "No memory entries shaped this session — pure forward work").

#### Stale memories flagged (from Step 0a)

List the candidate updates/removals from the staleness sweep. For each:

- `<memory-file-name>` — what's contradicted/stale and one-sentence proposed action (update / remove / merge into <other-file>).

Wait for the user's confirmation before editing — do not auto-apply the proposed actions.

#### Profile consolidations triggered (from Step 0b)

If `/consolidate-profile` was invoked for any profile, list:

- `<person-slug>` — N dated updates rolled in (date range); archive written to `_archive/<person-slug>-updates.md`; canonical sections updated: <list>.

## What NOT to do
- Don't save every fact from the conversation — only what changes future behavior
- Don't create duplicate memories — check existing files first
- Don't save things that will be stale by next session (current task status, in-flight decisions)
- Don't write long entries — one clear sentence beats three vague ones
