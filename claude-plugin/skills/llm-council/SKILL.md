---
name: llm-council
description: Run any question, idea, or decision through a council of 5 AI advisors who independently analyze it, peer-review each other anonymously, and synthesize a final verdict. Based on Karpathy's LLM Council methodology. MANDATORY TRIGGERS - 'council this', 'run the council', 'war room this', 'pressure-test this', 'stress-test this', 'debate this'. STRONG TRIGGERS (use when combined with a real decision or tradeoff) - 'should I X or Y', 'which option', 'what would you do', 'is this the right move', 'validate this', 'get multiple perspectives', "I can't decide", "I'm torn between". Do NOT trigger on simple yes/no questions, factual lookups, or casual 'should I' without a meaningful tradeoff (e.g. 'should I use markdown' is not a council question). DO trigger when the user presents a genuine decision with stakes, multiple options, and context that suggests they want it pressure-tested from multiple angles.
argument-hint: "[your question or decision]"
user-invocable: true
---

# LLM Council

Run a question or decision through 5 independent AI advisors with different thinking lenses, have them peer-review each other anonymously, and produce a chairman's verdict.

Adapted from Andrej Karpathy's LLM Council methodology. Instead of dispatching across different models, this dispatches across sub-agents with different thinking styles.

## When to run vs. skip

**Run the council** when there is genuine uncertainty, multiple plausible options, and a non-trivial cost of being wrong. Examples: pricing decisions, positioning angles, pivot calls, hiring vs. building, copy critique, strategic tradeoffs.

**Skip the council** for: factual questions with one right answer, pure creation tasks ("write me a tweet"), processing tasks ("summarize this"), or questions where the user is clearly just venting / wants validation. If you skip, say so briefly and answer directly.

If the question is too vague (e.g. "council this: my business"), ask exactly **one** clarifying question, then proceed.

## Where to write outputs

Save both files to `Council/` at the project root. Create the folder if it doesn't exist. Use a UTC-ish timestamp like `YYYYMMDD-HHMM` for the filename suffix.

- `Council/council-report-{{timestamp}}.html` — visual report (this is what the user reads)
- `Council/council-transcript-{{timestamp}}.md` — full transcript (the artifact)

After writing, open the HTML file with `open` so the user sees it immediately.

## Step 1 — Frame the question (with context enrichment)

Before spawning advisors, do **both** of these. Spend no more than ~30 seconds on context scan.

**A. Scan the workspace for context.** The user's question is the tip of the iceberg. Quickly look for:
- `CLAUDE.md` at project root (already loaded — re-read if needed)
- `Knowledge/Context/*.md` — me.md, goals.md, strategic-context.md, role-context.md, team-context.md, historical-context.md (whichever are relevant to the question)
- `Knowledge/People/*.md` — if the question involves stakeholders
- Any file the user explicitly referenced or attached
- Recent transcripts in `Council/` — to avoid re-counciling the same ground
- Auto-memory files (`memory/MEMORY.md` and pointed-to entries) when the question touches a tracked project, decision, or person
- For domain-specific questions, related files (e.g. pricing → revenue data; launch → past launch results)

Use Glob + targeted Read. Pull the 2–3 files that would most help advisors give specific, grounded advice rather than generic takes.

**B. Frame the question.** Compose a single neutral prompt that all 5 advisors will receive. It must include:
- The core decision or question (in the user's own words where possible)
- Key context from the user's message
- Key context from workspace files (role, audience, constraints, past results, relevant numbers)
- What's at stake — why this decision matters

Do **not** add your opinion. Do **not** steer. But **do** load enough context that advisors can be specific.

Save the framed question; you'll reuse it across all sub-agent prompts and in the transcript.

**C. Log sources as you go.** Every file you Read, web page you fetch, or memory entry you consult during framing must be captured in a `sources` list. One entry per source, with:
- **Path or URL** — exact location (absolute path for local files, full URL for web)
- **Type** — `workspace`, `memory`, `web`, `user-attached`, or `prior-council`
- **Why pulled** — one short phrase (e.g. "stakes/timeline context", "stakeholder profile", "prior decision rule under review")
- **What it contributed** — one line on the specific facts that ended up in the framed question (e.g. "May 18 board deadline; n=8–10 UXR sample size; 3 pre-committed criteria")

If a file was opened but turned out irrelevant, drop it from the list — don't pad. If no sources beyond the user's message were used, the list is empty and the transcript says so explicitly. This list is the audit trail for the framed question; both the transcript and the HTML report render from it, so build it once and reuse.

## Step 2 — Convene the council (5 sub-agents IN PARALLEL)

Spawn all 5 advisors simultaneously using the Agent tool with `subagent_type: general-purpose`. Send them in **a single message with 5 tool-use blocks** so they run concurrently. Sequential spawning wastes time and risks bleed-through.

Each advisor receives this prompt template (substitute their identity):

```
You are [Advisor Name] on an LLM Council.

Your thinking style: [the description below for this advisor]

A user has brought this question to the council:

[framed question]

Respond from your perspective. Be direct and specific. Don't hedge or try to be balanced. Lean fully into your assigned angle. The other advisors will cover the angles you're not covering. If you see a fatal flaw, say it. If you see massive upside, say it.

Keep your response between 150–300 words. No preamble. Go straight into your analysis.
```

### The five advisors

**The Contrarian** — Actively looks for what's wrong, what's missing, what will fail. Assumes the idea has a fatal flaw and tries to find it. If everything looks solid, digs deeper. Not a pessimist — the friend who saves you from a bad deal by asking the questions you're avoiding.

**The First Principles Thinker** — Ignores the surface-level question and asks "what are we actually trying to solve here?" Strips away assumptions. Rebuilds the problem from the ground up. The most valuable First Principles output is often "you're asking the wrong question entirely."

**The Expansionist** — Looks for upside everyone else is missing. What could be bigger? What adjacent opportunity is hiding? What's being undervalued? Doesn't care about risk (Contrarian's job). Cares about what happens if this works even better than expected.

**The Outsider** — Has zero context about you, your field, or your history. Responds purely to what's in front of them. Catches the curse of knowledge: things that are obvious to you but confusing to everyone else. Most underrated advisor.

**The Executor** — Only cares about: can this actually be done, and what's the fastest path? Ignores theory, strategy, big-picture. Looks at every idea through "OK but what do you do Monday morning?" If an idea sounds brilliant but has no clear first step, the Executor will say so.

Why these five: they create three natural tensions. Contrarian vs Expansionist (downside vs upside). First Principles vs Executor (rethink everything vs just do it). The Outsider keeps everyone honest with fresh eyes.

## Step 3 — Peer review (5 sub-agents IN PARALLEL)

This is the step that makes the council more than just "ask 5 times." It's the core of Karpathy's insight.

Collect all 5 advisor responses. **Anonymize them as Response A through E** — randomize the mapping so there's no positional bias (e.g., shuffle advisor → letter assignment). Keep the mapping for the transcript reveal.

Spawn 5 new sub-agents in parallel (single message, 5 tool-use blocks). Each reviewer is a different one of the original advisors but they only see anonymized text — they don't know which response is theirs.

Reviewer prompt template:

```
You are reviewing the outputs of an LLM Council. Five advisors independently answered this question:

[framed question]

Here are their anonymized responses:

Response A:
[response]

Response B:
[response]

Response C:
[response]

Response D:
[response]

Response E:
[response]

Answer these three questions. Be specific. Reference responses by letter.

1. Which response is the strongest? Why?
2. Which response has the biggest blind spot? What is it missing?
3. What did ALL five responses miss that the council should consider?

Keep your review under 200 words. Be direct.
```

## Step 4 — Chairman synthesis

One final sub-agent (or this main agent) gets everything: the framed question, all 5 advisor responses (now de-anonymized), and all 5 peer reviews.

Chairman prompt template:

```
You are the Chairman of an LLM Council. Your job is to synthesize the work of 5 advisors and their peer reviews into a final verdict.

The question brought to the council:

[framed question]

ADVISOR RESPONSES:

The Contrarian:
[response]

The First Principles Thinker:
[response]

The Expansionist:
[response]

The Outsider:
[response]

The Executor:
[response]

PEER REVIEWS:

[all 5 peer reviews]

Produce the council verdict using this exact structure:

## Where the Council Agrees
[Points multiple advisors converged on independently. High-confidence signals.]

## Where the Council Clashes
[Genuine disagreements. Present both sides. Explain why reasonable advisors disagree. Don't smooth over.]

## Blind Spots the Council Caught
[Things that only emerged through peer review. Things individual advisors missed that others flagged.]

## The Recommendation
[A clear, direct recommendation. Not "it depends." Not "consider both sides." A real answer with reasoning. You can disagree with the majority if the dissenter's reasoning is strongest — explain why.]

## The One Thing to Do First
[A single concrete next step. Not a list. One thing.]

Be direct. Don't hedge. The whole point of the council is to give the user clarity they couldn't get from a single perspective.
```

## Step 5 — Generate the HTML report

Write `Council/council-report-{{timestamp}}.html` as a single self-contained HTML file with inline CSS. No external assets, no JS frameworks — just plain HTML/CSS and a tiny bit of vanilla JS for the collapsible sections.

Required sections, top to bottom:

1. **Header** — the question (the user's original wording, not the framed version)
2. **Chairman's verdict** — prominently displayed; this is what most people will read. Render the chairman's full output with proper headings.
3. **Agreement / disagreement visual** — a simple, clean visual showing which advisors aligned and which diverged. A grid or simple table is fine. Show each advisor's stance in one short phrase ("strong yes", "yes with caveats", "no — fatal flaw", etc.). Derive these from the chairman synthesis or by re-skimming each response.
4. **Advisor responses** — one collapsible `<details>` block per advisor, **collapsed by default**. Label with advisor name. Include their full response.
5. **Peer review highlights** — one collapsible `<details>` block, collapsed by default. Include the three-question answers from each reviewer (de-anonymized).
6. **Sources consulted** — collapsible `<details>` block, collapsed by default, titled "Sources consulted to frame the question." Render the sources list from Step 1C as a small table or definition list with three columns: source (path/URL with type tag), why pulled, what it contributed. If the list is empty, render: *"No sources beyond the user's message were used to frame this question."* Do not silently omit this section — its presence tells the user the council was grounded (or wasn't).
7. **Footer** — timestamp, link to the transcript file, one-line description of what was counciled.

**Styling rules:**
- White background, system font stack (`-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`)
- Max content width ~760px, centered
- Subtle borders (`#e5e7eb` or similar), generous whitespace
- Soft accent color per advisor section (different muted hues — slate, sage, terracotta, navy, plum work well; avoid neon)
- Chairman verdict gets the most visual weight
- Looks like a professional briefing document, not a dashboard

After writing, run `open Council/council-report-{{timestamp}}.html` so it opens in the user's default browser.

## Step 6 — Save the transcript

Write `Council/council-transcript-{{timestamp}}.md` with:

```markdown
# Council Transcript — {{timestamp}}

## Original Question
[user's exact wording]

## Framed Question
[the neutral framing sent to advisors]

## Sources Consulted
[Render the Step 1C sources list. One bullet per source, format:
- `path/or/URL` (type) — why pulled · contributed: what it added to the framed question

If empty, write: "No sources beyond the user's message were used to frame this question."]

## Advisor Responses

### The Contrarian
[response]

### The First Principles Thinker
[response]

### The Expansionist
[response]

### The Outsider
[response]

### The Executor
[response]

## Peer Reviews (Anonymization Mapping Revealed)

Mapping: Response A = {{advisor}}, B = {{advisor}}, C = {{advisor}}, D = {{advisor}}, E = {{advisor}}

### Reviewer 1 (The Contrarian)
[review]

### Reviewer 2 (The First Principles Thinker)
[review]

[... etc for all 5 ...]

## Chairman's Synthesis
[full verdict]
```

## Step 7 — Tell the user

After both files are written and the HTML is opened, send a short message: which file was opened, what the chairman recommended in 1 line, and where the transcript lives. Do not re-paste the full verdict in chat — the report is the deliverable.

## Hard rules

- **Always spawn the 5 advisors in parallel.** Single message, 5 Agent tool-use blocks. Same for peer review.
- **Always anonymize for peer review.** If reviewers know which advisor said what, they defer to thinking styles instead of evaluating on merit. Randomize the A–E mapping.
- **The chairman can disagree with the majority.** If 4 of 5 say "do it" but the 1 dissenter has the strongest reasoning, the chairman sides with the dissenter and explains why.
- **No hedging in the chairman verdict.** "It depends" is not an answer. Make a call.
- **Don't council trivial questions.** Skip and answer directly. The council is for genuine uncertainty.
- **The HTML report is the deliverable.** Most users will scan the report, not read the transcript. Make it clean.
- **Always document sources.** Every file, memory entry, or web page consulted during framing must appear in the sources list with what it contributed. The list ships in both the HTML "Sources consulted" section and the transcript's "Sources Consulted" section. If nothing was consulted, say so explicitly — don't omit the section.
