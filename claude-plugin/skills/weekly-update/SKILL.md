---
name: weekly-update
description: Draft a stakeholder update email using past updates for tone
user-invocable: true
---

# Weekly Update Drafter

Draft a stakeholder update email using the weekly-update template.

## Instructions

1. **Gather Information**
   - Read `Tasks/active.md` for current sprint status
   - Read `Knowledge/Context/goals.md` for OKR targets and progress
   - Search Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files`) for recent meeting notes, decisions, and commitments this week; fall back to `Raw/` if Drive MCP is unavailable or returns nothing
   - If a project tracker MCP (Linear, Jira, etc.) is connected: fetch recently completed, in progress, and blocked issues

2. **Check Stakeholder Preferences**
   - Check `Knowledge/People/` for stakeholder preferences or `Drafts/` for past weekly updates for tone and continuity

3. **Assess Status**
   - Compare progress against milestones
   - Identify any slippage or blockers
   - Determine overall status: On Track | At Risk | Blocked

4. **Apply voice profile**
   - Read `Knowledge/Context/my-voice.md` — apply its tone, structure, and formatting preferences throughout the draft
   - If the file only contains the placeholder (not yet generated), proceed with default PM tone

5. **Draft Using Template**
   - Use `Templates/weekly-update.md` as the structure
   - Keep total length under 500 words
   - Lead with metrics, not activity
   - Flag blockers early with proposed solutions
   - Reference OKRs when showing progress
   - **Save the draft to `Drafts/weekly-update-YYYY-MM-DD.md`** (never `Raw/`)

5. **Review Checklist**
   - [ ] Status accurately reflects reality
   - [ ] Metrics are current (not stale)
   - [ ] Blockers have clear asks attached
   - [ ] Next week priorities are realistic
   - [ ] Under 500 words

## Notes

- Lead with the headline - what's the ONE thing they need to know?
- Be honest about status - At Risk is better than surprising people later
- Make asks specific - "Need decision on X by Friday" not "need support"
- Never guess at numbers - flag "TBD" if a metric isn't available
