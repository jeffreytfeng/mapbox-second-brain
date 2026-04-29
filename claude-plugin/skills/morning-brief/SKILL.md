---
name: morning-brief
description: Morning briefing from tasks, calendar, email, and goals
user-invocable: true
---

# Morning Brief Generator

Generate a morning brief and write it to `morning-brief.md`.

## Instructions

0. **Load context from Google Drive**
   - Search Google Drive for files with title containing "Second Brain Context"
   - Read the most recently modified result — it contains the user's role, current quarter goals, active tasks, key stakeholders, and key dates
   - Use it to make priorities in the brief more specific and grounded
   - If not found, proceed without it

1. **Check Tasks**
   - Read `Tasks/active.md` for in-progress work, blockers, and deadlines
   - Flag anything overdue or stalled

2. **Check Goals**
   - Read `Knowledge/Context/goals.md` for quarterly OKRs, key metrics, and ownership areas
   - Note what's on track vs. at risk

3. **Check Calendar**
   - Fetch today's events via Google Calendar MCP (both personal and work calendars)
   - Identify meetings that need prep (1:1s with the user's direct manager or skip-level, product reviews, stakeholder syncs) — check `Knowledge/Context/role-context.md` for who the manager and skip-level are
   - Note back-to-back stretches that limit deep work time

4. **Check Email**
   - Search Gmail: `is:unread newer_than:2d` to surface unread threads
   - Also search: `newer_than:1d` for recent high-signal threads
   - Look for: direct asks from the user's manager or key stakeholders, decisions needed, time-sensitive requests

5. **Check Slack**
   - Search for threads where the user was mentioned or DM'd in the last 2 days: use `slack_search_public_and_private` with query `to:me newer_than:2d`
   - Also search for high-signal threads from the last day: `newer_than:1d` in key channels
   - Look for: direct asks, decisions pending the user's input, time-sensitive cross-team asks

6. **Synthesize & Rank**
   - Cap the priority list at **5 items max**
   - Each priority must have a "why today" reason and a single concrete next action
   - Priority order:
     - 🔴 Hard deadlines today (meeting prep, commitments made)
     - 🟠 Stakeholder asks unresponded (Manager, cross-team)
     - 🟡 OKR-linked work (tasks that directly move key metrics)
     - 🟢 Important but flexible (research, async writing, backlog)
   - Overflow goes to Watch List

6b. **Apply voice profile**
   - Read `Knowledge/Context/my-voice.md` — apply its tone and formatting preferences when writing the brief
   - If the file only contains the placeholder (not yet generated), proceed without it

7. **Write to morning-brief.md**
   - **Always overwrite** `morning-brief.md` in the project root with the full brief

## Output Format

```
# Morning Brief — [day, date]

## Today's Schedule
- [time] — [meeting] ([prep needed or context])
- Deep work window: [best open block]

## Top Priorities

1. 🔴 **[Priority]**
   Why today: [reason it can't wait]
   Next action: [one specific thing to do]

2. 🟠 **[Priority]**
   Why today: [reason]
   Next action: [action]

... (up to 5)

## Watch List
- [Item slipping but not urgent today] — check by [date]
- [Dependency waiting on someone else] — follow up if no response by [date]

## Blockers
- [blocker]: [impact and proposed resolution]

## Recently Completed
- [x] [item]

## Suggested Focus
[1-2 sentences on what matters most today and why]

---
*Generated: [date] | Sources: Google Calendar, Gmail, Slack, Tasks/active.md*
```

## Notes

- Skip personal calendar items unless they affect work time
- If `goals.md` or `Tasks/active.md` are empty, flag it
- When in doubt, bias toward what the user's direct manager would ask about in their next 1:1 (check `Knowledge/Context/role-context.md` for who that is)
- Prioritize by impact, not recency
