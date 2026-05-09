---
name: draft-prd-section
description: Write a specific PRD section grounded in research, evidence, and goals — applying the Mapbox writing style. Use when the user asks to "draft a PRD section", "write the problem statement", "fill in user stories / success metrics / launch plan", or types "/draft-prd-section".
argument-hint: "[section-name] [prd-path-or-project-dir]"
user-invocable: true
---

# PRD Section Drafter

Write or improve a specific section of a PRD. Ground every claim in evidence the project already has, format to a clear template, and flag the gaps the author still needs to close.

## Context — where the PRD sits in the Mapbox product lifecycle

PRDs at Mapbox follow PRFAQs, not the other way around. A PRFAQ frames the customer problem and value proposition, gets reviewed by leadership (typically Cherie + Anu), and gates engineering / GTM resourcing. The PRD then captures the implementation specifics — user stories, success metrics, technical approach, launch plan — for the team that's already been resourced. If a PRFAQ hasn't been approved yet, that's the right artifact to write first; this skill assumes the PRFAQ exists or doesn't apply.

Legal review (Laurel Finch + team) is engaged at the PRFAQ stage, before coding starts. Don't wait until the PRD to flag legal questions.

## When to invoke

The user asks to draft, fill in, or improve one section of a PRD — not the whole document. Examples: "draft the problem statement for the search PRD", "write user stories for this", "fill in success metrics".

## Inputs

The skill takes two optional arguments: `[section-name]` and `[prd-path-or-project-dir]`.

- **section-name** — one of: `Problem Statement`, `Solution Overview`, `User Stories`, `Success Metrics`, `Technical Approach`, `Launch Plan`, `Timeline`. If omitted, ask.
- **prd-path-or-project-dir** — path to an in-progress PRD draft, or the project directory containing research notes. If omitted, ask.

## Instructions

### Step 1: Identify context

- Which PRD? Read the existing draft if a path was provided. Otherwise ask the user to point you at one or describe the project.
- Which section? Map the user's phrasing to one of the seven canonical sections above. If ambiguous, ask.
- Is there a corresponding PRFAQ? If yes, read it — the PRD's Problem Statement and Success Metrics should ladder back to what the PRFAQ already committed to.

### Step 2: Gather inputs

Read in parallel, in this order of preference:

1. **The existing PRD draft** (if any) — to understand context, voice, and what's already written.
2. **The corresponding PRFAQ** if one exists — for the customer problem framing, the named business metric, the customer use cases, and the synthetic customer quote. The PRD inherits these.
3. **A project-local PRD template** at `Templates/prd.md` if it exists — prefer this over a generic structure (the project's house style wins).
4. **Research / evidence sources** — look for files matching `research/`, `interviews/`, `data/`, `notes/`, or similarly named directories. Pull quotes, numbers, and findings that bear on the section. Surface customer voices directly where possible — one concrete customer quote beats three abstract claims.
5. **Goals / OKRs** — look for `Knowledge/Context/goals.md`, `goals.md`, or `OKRs.md` at the project root. Align Success Metrics and Problem Statement to current goals. If absent, skip silently.
6. **Voice profile** at `Knowledge/Context/my-voice.md` if it exists — apply tone, structure, and formatting preferences. If absent or only contains a placeholder, use a neutral PM voice (numbers anchor everything, no "great question"/"absolutely"/"basically", no sign-offs, lead with the signal).

If any of these aren't present, silently skip — don't ask the user about each one.

When the section is **Problem Statement** or **Success Metrics**, also pull answers (or write the gap if missing) for these prep questions:

- What is the **business impact** of the problem (revenue, cost, time, retention)? This is the resourcing justification.
- What are customers / developers doing today to work around the problem?
- Who are the competitors, and how does Mapbox's approach differ? (Internal framing only — competitor names stay out of any external surface; see Step 4.)
- Which customer is using or has signed up to use this, and what would they say about it?
- What's the pricing / packaging position, if any?
- When does this become available — private preview / public preview / GA?

### Step 3: Draft the section

For every section: ground claims in evidence from the project's research. If a claim has no source, mark it explicitly `[ASSUMPTION — needs validation]` so it can't ship by accident. Write features in **present tense** as if they exist (the Mapbox standard) — not "we will build" but "the API includes."

#### Problem Statement

- Lead with **customer pain**, not solution. The reader should feel the problem before reading the proposed fix.
- Quantify impact: how many customers, how often, how much money/time/friction.
- Cite evidence: data points, support tickets, customer interview quotes (with attribution where possible). One concrete customer quote beats three abstract claims.
- Name the **status quo** — what customers do today and why it falls short. The reader should understand why this isn't already solved.
- Explicitly state who is **not** in scope. A problem statement that includes every customer usually solves no one's problem.
- Tie back to a Mapbox business metric (the same one named in the PRFAQ Introduction, if there is one).

#### Solution Overview

- One-paragraph summary first. The reader should be able to repeat the gist after reading just that paragraph.
- **Mechanism, not feature list.** Explain how the solution removes the customer pain identified in the Problem Statement. Frame around customer use cases, not internal mechanics — "Customers can do X" beats "the system implements Y."
- Call out the **key bet** the solution makes (what assumption must be true for this to work).
- Identify **what's explicitly out of scope** for v1 to keep the proposal tight.
- If alternatives were considered, name them in one line each and say why the chosen path wins.

#### User Stories

- Format: `As a [persona], I want to [action] so that [outcome]`.
- Use **descriptive persona words** — `developer`, `fleet manager`, `account manager`, `driver`, `designer` — not "the user" or "you" (see Mapbox style in Step 4).
- Group by persona, then by priority.
- Prioritize:
  - **P0** — must have for launch; without it the value prop breaks
  - **P1** — should have; significant value but launch-survivable
  - **P2** — nice to have; defer if scope tightens
- For every P0 story, include **acceptance criteria** as a checklist (`Given … When … Then …` or plain bullets — be specific enough that QA can verify).
- Tie stories back to the Problem Statement: each P0 story should map to a specific customer pain.

#### Success Metrics

Structure as three tiers:

- **Primary metric** (one) — the single number that defines success. Should match the business metric named in the PRFAQ Introduction.
- **Secondary metrics** (2–4) — leading indicators or supporting outcomes.
- **Guardrails** (1–3) — what should NOT get worse. Common ones: latency, error rate, retention of existing customers, support ticket volume.

For each metric show: **Current baseline · Target · Measurement window · Source/dashboard**. If the baseline isn't known, mark `[BASELINE NEEDED]` so the author knows to fill it in before launch review.

If the project has goals/OKRs and a primary metric doesn't ladder up, flag it.

#### Technical Approach

- High-level architecture sketch (text-based diagram is fine — show data flow, not boxes-and-lines for their own sake).
- **Build vs. buy vs. extend** — name the choice and why.
- Dependencies on other teams or systems, explicitly named with the team / owner.
- Top 3 technical risks and the mitigation for each.
- Migration / backward-compat story if relevant.
- Open technical questions the team still needs to resolve, with an owner and target date for each.

#### Launch Plan

- **Phasing** — private preview → public preview → GA, with rough sizing of each cohort. (Mapbox's preview-period exit criteria: ≥3 customers tested in private preview, ≥7 in public preview.)
- **Entry / exit criteria** for each phase (what we want to learn, what would block moving forward).
- **Rollout mechanism** — feature flag, percentage rollout, geo-staged, etc.
- **Comms plan** — internal stakeholders, beta customers, GA announcement; who owns each. External comms requires Anu's approval (and Cherie's for Large launches with pricing implications); blog and press release require approval, email and social do not.
- **Rollback plan** — how to revert and how fast.
- **Pricing / packaging** decisions if relevant. Pricing has its own review with Cherie + Anu at least 1 month before launch.
- **Security review** — required at each launch-phase transition (Pre-launch → Private Preview → Public Preview → GA).

#### Timeline

- Use a milestone table: **Milestone · Date · Owner · Definition of done**.
- Anchor to dates, not "weeks from now."
- Mark dependencies between milestones explicitly (M3 depends on M1 + M2).
- Identify the **critical path** — which milestones, if slipped, slip the whole launch.
- Call out review / approval gates (design review, security review, pricing review with Cherie + Anu, Go/No-Go meeting at least 1 week before GA, exec sign-off) as their own milestones with realistic lead times.

### Step 4: Apply Mapbox writing style and grammar

PRDs are mostly internal but get reused for blog posts, launch comms, and customer-facing FAQs. Apply these rules to every section before delivery.

**Voice and point of view:**

- **Internal-facing PRD: first person ("we") is acceptable** — the PRD is a one-on-one conversation with the team and leadership.
- **For sections that will be reused externally** (Problem Statement, Solution Overview, customer-facing FAQ excerpts): use **third person** — refer to "Mapbox" — never "we" externally, never "it." If third person is awkward, rephrase rather than dropping into first person.
- **Avoid the pejorative "you."** Use descriptive persona words: "customers," "developers," "partners," "drivers," "designers," "fleet managers." This reads less aggressive (especially to non-native English readers) and is more concrete.
  - ❌ "Now, you can see how the API responds."
  - ✅ "Now, developers can see how the API responds."

**Active voice:** prefer active voice. Watch for "was" and "by" as passive-voice signals.

- ✅ "The system filters points on the map."
- ❌ "Points on the map are filtered."

**Oxford comma:** always use it.

**Sentence casing for headlines and titles:** only the first word is capitalized (plus proper nouns). "New 3D environments enhance wayfinding" — not Title Case.

**Dates and times:**

- Dates: `Monday, January 1, 2026` or `January 1, 2026`. No ordinals (no "1st"). Don't abbreviate months.
- Times: `10:30am PT`, `10am PT` (no minutes for on-the-hour), `10am – 10:30pm` (hyphen for ranges). Lowercase `am`/`pm`, no space.

**Words and phrases to avoid (replace as shown):**

| Avoid | Prefer |
|---|---|
| utilize, leverage | use, builds with, benefits from |
| users (when referring to Mapbox customers) | customers, developers, partners, companies, businesses (end users is acceptable when referring to a customer's app users) |
| empower (overused) | equip, enable, enhance |
| tool (to describe a Mapbox product) | product, solution, technology |
| thrive, synergy, groundbreaking | (rephrase — corporate jargon) |
| market-leading, world's first, cutting edge, transformative, revolutionize | (rephrase — hyperbolic / salesy) |

**Mapbox brand specifics:**

- Always **Mapbox** — never MapBox, mapbox, MBX, or mbx in external content. Only "Mapbox Inc." in legal context.
- **No possessive "Mapbox's" in sections that may be reused externally.** Rephrase the sentence to avoid it.
- Never refer to Mapbox as "it." Rephrase if third person becomes awkward.

**Product naming:**

- Service pillars: precede with "Mapbox" — e.g. Mapbox Search, Mapbox Navigation, Mapbox Maps, Mapbox Data, Mapbox Automotive. Don't use "the" with the general service area ("Mapbox Maps are highly performant").
- Specific products: first mention always uses the full name with "Mapbox" (e.g. "the Mapbox Maps SDK"). After first mention, may drop "Mapbox" in short content; restore at the start of new sections in long content.
- "The" usage by product:
  - **No "the":** Mapbox GL JS, Mapbox Search JS, Mapbox Address Autofill, Mapbox Dash, Mapbox Studio, Mapbox for EV, Mapbox Boundaries, Mapbox Movement Data, Mapbox Traffic Data.
  - **Use "the":** any product name with "API" or "SDK" appended (e.g. the Mapbox Geocoding API, the Mapbox Mobile Maps SDKs); the Mapbox Tiling Service (drop "the" for "MTS" or Raster MTS).

**Capitalization specifics:**

- **Teams and organizations capitalized** when named: Sales, Automotive, Legal. The word "team" or "organization" is lowercase ("the Sales team").
- **Roles capitalized:** Account Manager, Program Manager.
- **Locations:** Mapbox Japan, Mapbox Helsinki, Mapbox Minsk, Mapbox DC.

**Other Mapbox-specific terms:**

- One word: Basemap, Dataset, Tileset, wayfinding.
- GeoJSON (not geojson or Geojson).
- 3D (not 3-D).
- ODL = On-Demand Logistics (hyphen, capital D).

**Customer and competitor framing:**

- "Equip" and "enable" customers to "solve" challenges and "create" value. Respect customers as leaders in their own right who use Mapbox as a component within a larger solution.
- **In the Technical Approach and Solution Overview sections, direct competitor comparison is acceptable** — this is internal context for engineering and leadership.
- **Anything that may be reused externally avoids naming competitors.** Direct comparisons can expose Mapbox to legal risk and read as arrogant. The Problem Statement should describe the customer's status-quo workaround in a competitor-neutral way.

### Step 5: Surface gaps

End the draft with a short **Open questions / gaps** section listing anything the author still needs to resolve before this section is ship-ready. Each gap should be one line and concrete enough to action.

## Output format

Return the drafted section in the format the PRD template uses, plus the gaps list at the bottom. Don't return a verdict, summary, or wrapper text — the section itself is the output, ready to paste into the PRD.

If the existing PRD already has the section and you're improving it: return a **diff-style annotated rewrite** — show what to cut, keep, or add, with one-line rationale per change. Keep changes minimal; don't rewrite for style if the substance is sound.

## Notes

- **Always ground in evidence.** If a claim has no source, mark it `[ASSUMPTION — needs validation]` so it can't ship accidentally.
- **Challenge soft claims.** "Customers want X" is not evidence; "23 of 30 interviewed customers mentioned X unprompted" is. If the project research has the data, use it; if it doesn't, flag the gap.
- **Don't pad.** A short, specific section beats a long, generic one. If a subsection has nothing useful to say, leave it out rather than filling with platitudes.
- **PRDs are living documents.** Frame gaps as "open questions" the team can resolve, not as failures.
- **The PRFAQ is the upstream artifact.** If the Problem Statement keeps wanting to change, the PRFAQ probably needs revisiting first — the PRD shouldn't be where customer-problem framing gets re-litigated.
