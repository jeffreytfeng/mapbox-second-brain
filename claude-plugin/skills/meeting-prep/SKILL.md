---
name: meeting-prep
description: Context-loaded prep for any meeting
argument-hint: "[person-name]"
user-invocable: true
---

# Meeting Prep

Prepare context and talking points for an upcoming meeting.

## Instructions

1. **Find the Person's Profile**
   - Look in `Knowledge/People/` for their file — load communication preferences
   - Note their preferred format, what they care about, how to work with them

2. **Check the Calendar Invite**
   - Fetch the upcoming event via Google Calendar MCP for the meeting with this person
   - Check the invite description for any linked agenda docs, meeting notes, or attachments
   - Note any pre-reads or docs the organizer has shared

3. **Gather Past Meeting History**
   - Find past meeting notes in `Raw/` (e.g. `*-1on1-notes.md`) — extract open action items
   - Search Google Drive for past meeting notes involving this person: use `mcp__claude_ai_Google_Drive__search_files` with terms like `"[person name] 1:1"` or `"[person name] notes"`
   - From both sources, surface: open action items, recent decisions, escalations, or commitments made by either party

4. **Pull Current Context**
   - Check `Tasks/active.md` for anything relevant to discuss
   - Check `Knowledge/Context/goals.md` for metrics they care about
   - Search Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files`) for recent decisions or commitments relevant to this person or their team; fall back to `Raw/`, `strategic-context`, or `historical-context` if Drive MCP is unavailable or returns nothing

5. **Apply voice profile**
   - Read `Knowledge/Context/my-voice.md` — apply its tone and formatting preferences to the prep doc output
   - If the file only contains the placeholder (not yet generated), proceed without it

6. **Generate Prep Doc**
   - Output talking points in their preferred format (e.g., BLUF for senior execs)
   - Include open items, relevant metrics, prep questions

## Output Format

```
## Meeting Prep: {{person/meeting}}
**Date/Time:** {{datetime}}
**Type:** {{meeting_type}}

### Invite / Pre-reads
- {{agenda or doc linked in calendar invite, if any}}

### Context
{{Brief background on this person and relationship}}

### Recent Decisions, Escalations & Commitments
- {{date}} — {{decision or commitment made, by whom, source}}

### Key Points to Cover
- {{topic}}: {{what to say}}

### Open Action Items
- [ ] {{from last meeting, with source}}

### Questions to Ask
1. {{question}}

### Decisions Needed
- {{decision}}: My recommendation is {{X}} because {{Y}}
```

## Notes

- Format output according to the person's communication preferences
- Flag if no previous notes exist - suggest what to learn in this meeting
- Keep prep concise - it's a reference, not a script
