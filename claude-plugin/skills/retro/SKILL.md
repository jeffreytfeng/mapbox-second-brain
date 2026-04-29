---
name: retro
description: This skill should be used when the user types "/retro", asks for a "monthly retrospective", "monthly retro", "end of month reflection", or wants to review what happened this month and plan changes for next month.
version: 1.0.0
---

# /retro — Monthly Retrospective

When invoked, walk the user through a structured monthly reflection. This is a conversation, not a form — ask each question, wait for the answer, then move to the next.

## The Conversation Flow

### Opening
Say: "Let's do your monthly retro. I'll ask 5 questions — answer as much or as little as you want. Takes about 15 minutes."

Then read the current summaries to get grounded:
- `~/Documents/second-brain/Knowledge/Context/strategic-context.md`
- `~/Documents/second-brain/Knowledge/Context/historical-context.md`
- `~/Documents/second-brain/Tasks/active.md` (if it exists)
- Recent entries in `~/Documents/second-brain/Meetings/` if that directory is in use

### Question 1: Accomplishments
"What were you trying to accomplish this month — and how did it actually go?"

Listen for: what shipped, what stalled, what got descoped, what surprised the user.

### Question 2: Patterns (Good)
"What's working? Any habits, approaches, or relationships that are clicking?"

Listen for: workflow wins, collaboration that worked, decisions that paid off.

### Question 3: Patterns (Bad)
"What kept getting in the way? Any patterns you're tired of seeing?"

Listen for: repeated blockers, recurring friction, things they keep tolerating.

### Question 4: Forward
"What should be different next month? One or two things max."

Keep this concrete. "Be more strategic" is not actionable. "Block 2 hours on Tuesdays for roadmap work" is.

### Question 5: Surprises
"Anything that happened this month that changed how you think about your work or your team?"

This is where the non-obvious stuff lives.

## After the conversation

### Update summaries
Based on what the user shared, update the relevant files in `~/Documents/second-brain/Knowledge/Context/`:
- If the strategic situation shifted → update `strategic-context.md`
- If team dynamics changed → update `team-context.md`
- If priorities or growth edges evolved → update `personal-growth.md`
- If key decisions or pivots happened → add to `historical-context.md`

Always note the date of the update and what changed. Don't overwrite — add a dated section.

### Save a retro snapshot
Append a brief summary to `~/Documents/second-brain/Knowledge/retro-log.md`:

```
## [Month Year] Retro

**What shipped:** ...
**What stalled:** ...
**Pattern to address:** ...
**Change for next month:** ...
**Surprise:** ...
```

### Update memory if needed
If something significant shifted about the user's role, priorities, or context, update the relevant memory file in `~/.claude/projects/.../memory/`.

## Tone
This is a thinking session, not a performance review. Give the user space to think. Don't rush to the next question. If an answer is rich, follow up once before moving on.

If they say "nothing changed" on a question, that's a valid answer — note it and move on.
