---
name: synthesize-research
description: Turn raw interview notes into structured insights with patterns and quotes
argument-hint: "[path-to-research-folder]"
user-invocable: true
---

# Research Synthesizer

Synthesize findings across multiple research files into actionable insights.

## Instructions

1. **Locate Research Files**
   - Search Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files`) for interview notes and research summaries related to the topic first; read matches via `mcp__claude_ai_Google_Drive__read_file_content`
   - Fall back to local files (`interview-*.md`, `research-summary-*.md`, `_temp/`) if Drive MCP is unavailable or returns nothing

2. **Extract Key Data**
   From each file, pull:
   - Key findings and confidence levels
   - Pain points with severity ratings
   - Verbatim quotes (especially emotional or insightful ones)
   - Recommendations made

3. **Identify Patterns**
   - Group similar findings across sources
   - Count frequency of themes
   - Note contradictions or outliers
   - Assess overall confidence based on consistency

3b. **Apply voice profile**
   - Read `Knowledge/Context/my-voice.md` — apply its tone and formatting preferences to the synthesis output
   - If the file only contains the placeholder (not yet generated), proceed without it

4. **Generate Synthesis**

   Output format:

   ```
   ## Research Synthesis: {{topic}}

   **Sources:** {{N}} interviews, {{N}} surveys, etc.
   **Date Range:** {{earliest}} to {{latest}}

   ### Top Findings

   #### 1. {{Finding}}
   - **Frequency:** Mentioned by X/Y participants
   - **Confidence:** High/Medium/Low
   - **Evidence:** {{summary}}
   - **Key Quote:** "{{quote}}" — P{{X}}

   ### Patterns & Themes

   | Theme | Frequency | Segments Most Affected |
   |-------|-----------|------------------------|
   | | | |

   ### Contradictions / Nuances
   - {{where findings differed and why}}

   ### Recommendations
   1. **Do Now:** {{high confidence, high impact}}
   2. **Explore:** {{needs more research}}
   3. **Avoid:** {{anti-patterns identified}}

   ### Gaps / Open Questions
   - {{what we still don't know}}
   ```

5. **Link to Sources**
   - Include references to all source documents
   - Make findings traceable

## Notes

- Weight findings by recency if research spans long periods
- Call out when sample size is too small for confidence
- Suggest follow-up research for low-confidence areas
