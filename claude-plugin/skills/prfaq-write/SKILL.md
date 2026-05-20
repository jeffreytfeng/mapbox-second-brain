---
name: prfaq-write
description: Write a specific PRFAQ section using Mapbox's PRFAQ standard (Working Backwards adapted for Mapbox), or critique a draft for weak claims, logical gaps, and unsupported arguments
argument-hint: "[section] [product-or-topic]  — section: intro | pr | efaq | ifaq | headline | problem | solution | quote | journey | critique"
user-invocable: true
---

# PRFAQ Section Drafter

Write or sharpen a specific section of a PRFAQ following the Mapbox PRFAQ standard. The PRFAQ disciplines you to define the customer experience before any engineering starts, and to land approval from Cherie Wong (CTO) and Anu Sharma (VP of Product) before resourcing follows.

## What is a Mapbox PRFAQ?

The PRFAQ is rooted in Amazon's [Working Backwards](https://www.amazon.com/Working-Backwards-Insights-Stories-Secrets/dp/1250267595) methodology: write the customer experience first, then build. The PR is a design tool that forces precision about what matters to the customer, and the FAQ surfaces every hard question before engineering starts.

A Mapbox PRFAQ is **6 pages max** with four parts, in this order:

1. **Introduction** — pre-meeting framing with the explicit Cherie ask, launch size, and the business metric being moved.
2. **Press Release (PR)** — 6 paragraphs written as if the product has already launched.
3. **External FAQ (E-FAQ)** — customer-facing questions
4. **Internal FAQ (I-FAQ)** — strategic, financial, and technical questions for Mapbox leadership.

Anything beyond 6 pages goes to an appendix. Include page numbers and mark **Mapbox Confidential** in the footer.

The PRFAQ is reviewed at least **3 months before launch**. Approval comes from Cherie (CTO/SVP) and Anu (VP of Product). The PRFAQ is a living document — keep updating it through preview.

**The PRFAQ names candidate customers.** It provides as much detail and specificity as possible on which customers would benefit, how they would achieve their goals, and why they would find the product remarkable. If you cannot name a customer and clearly identify their needs to win their business, the PRFAQ will not meet expectations.

The test: if the PR isn't compelling enough that you'd genuinely want to use the product, stop and redesign the product — not the PR.

---

## Instructions

### Step 1: Identify what to write

Parse the arguments to determine:

- **Which product/feature?** Infer from context or ask.
- **Which section?** Map input to one of:
  - `intro` — Mapbox introduction (Cherie ask, launch size, business metric, pre-readers)
  - `pr` — Full press release (6 paragraphs)
  - `headline` — Headline + subheadline only
  - `problem` — Customer problem paragraph
  - `solution` — Solution paragraph
  - `quote` — Leader quote + customer testimonial quote
  - `journey` — User journey paragraph (the "how it works" scene)
  - `efaq` — External FAQ (customer-facing) — **comes before I-FAQ in the doc**
  - `ifaq` — Internal FAQ (strategic, financial, technical) — comes second

- `critique` — Run the executive critique (Step 6) on an existing full or partial PRFAQ draft. Use this when the user pastes a draft or says "critique this" / "tear this apart" / "is this ready for Anu/Cherie?". Does not draft new content — only surfaces weaknesses and recommended fixes.

If no section is specified, ask which section the user wants help with.

### Step 2: Gather context

- Read `Tasks/active.md` for in-progress PRFAQ work.
- Read `Knowledge/Context/goals.md` for OKR alignment — the introduction explicitly asks how the feature aligns with company goals.
- Search Google Drive for relevant meeting notes, research, or existing PRFAQ drafts. Prefer the `/gws-drive` skill (uses the `gws` CLI); fall back to `mcp__claude_ai_Google_Drive__search_files` if gws is unavailable; fall back to `Raw/` if neither is set up. **`/gws-drive` requires the `gws` CLI to be installed and authenticated against your Google account — see the [Google Workspace CLI setup guide](https://mapbox.atlassian.net/wiki/spaces/KB/pages/2624880645/Google+Workspace+CLI+gws+User+Setup+Guide).**
- Check `Knowledge/People/` for stakeholder perspectives that should be reflected — especially Cherie Wong and Anu Sharma (the approvers).
- Look for: customer pain points, named customer quotes, business-metric baselines, competitive signals, hard constraints, pricing precedent.
- Reference examples (use to calibrate tone, depth, and format):
  - `1rMSMGrtJ5MGXgYv_ExWZ7rzHyOeZPsco9P2jM5wmZb4` — MTS Incremental Updates PRFAQ.
  - `17QCxYxQRnAerjgU-n5maPTVhEmkEVMagxgQci-sYjjY` — Mapbox Fleet PRFAQ (broader-scope example).
  - [BMW Navigation SDK launch press release](https://www.businesswire.com/news/home/20201214005607/en/Mapbox-Launches-Navigation-SDK-for-Automotive-BMW-Group-Launch-Partner) — published example to model the press release tone against.

#### Pre-write prep checklist (especially for the press release)

Before drafting any PR section, work through these 12 questions. The answers won't all appear in the PR — but if any answer is missing, the PR will read soft. Capture answers in scratch space; the PR is a concise document that earns time with a customer or reporter, like a resume earns an interview.

1. Is this a new product or significant functionality added to an existing product?
2. Describe the challenge this product or new functionality addresses.
3. What are the use cases in which developers (or other named personas) encounter these challenges?
4. What business impact does the challenge create?
5. How does the new product or functionality address the challenge?
6. What business value does it create (e.g. faster service, increased revenue, lower COGS)?
7. Who are the competitors and what is their product? *(Internal-only context — competitor names stay out of the PR and E-FAQ.)*
8. How is the Mapbox product different? Is Mapbox better — and on which dimension specifically?
9. Which customers are using the new product? How are they using it?
10. Is there a customer to quote, and what is their statement about the product's value? If no real customer is on record yet, the synthetic quote drafted in I-FAQ Q13 fills this slot.
11. How much will the product cost?
12. When is the product available?

### Step 2b: Apply voice profile

Read `Knowledge/Context/my-voice.md` — apply its tone and formatting preferences. If absent, use a neutral PM voice and the Mapbox style rules in Step 5 below.

### Step 3: Draft using section-specific guidance

---

#### INTRODUCTION (Mapbox-specific — not in standard Amazon Working Backwards)

The introduction makes the PRFAQ review meeting efficient. Cover, in order:

- **What do we need from Cherie today?** State the explicit ask (e.g. "approve resourcing for engineering + GTM," "endorse the proposed pricing," "approve moving to private preview"). One sentence.
- **Who has already reviewed the PRFAQ?** Name the engineers and product marketers consulted before the meeting.
- **What is the size of the launch?** Large / Medium / Small — score on customer reach, testing required, new SKU?, revenue (Large 9–11, Medium 7–8, Small 4–6). Note whether this is a new product, a new feature on an existing product, or an update.
- **Is there a price?** State it directly (paid, free with justification, or TBD).
- **What is the impactful business metric we are moving?** The named metric is the resourcing justification — not a vague "improves customer experience." Use this to answer "why allocate engineering and GTM resources here."
- **Do we need a primer?** Optional. If the reader needs background context (e.g. explaining MTS before pitching MTS Incremental Updates), link to it or include a short summary.

Keep the introduction tight — it exists so reviewers don't have to ask these questions in the meeting.

Mark **Mapbox Confidential** in the document footer and include page numbers.

---

#### PRESS RELEASE (5 paragraphs — strict structure)

The press release has four named structural elements wrapping the body paragraphs. Each one does a specific job:

- **Head** — the title. Appears in the wire summary feed (e.g. BusinessWire). Plain English, no jargon, journalist-usable.
- **Deck** (sub-head) — does not appear in the wire summary; sets up the lede for readers who clicked through. One sentence: who it's for, what specific outcome it delivers.
- **Dateline** — `CITY, STATE — Date —` opens the body. Standard wire convention.
- **Boilerplate** — `ABOUT MAPBOX®` block at the end. Use the latest official copy; do not paraphrase.

Write the body in **present tense as if the product already exists** — not "we will be implementing X," but "the API includes X." This is a Mapbox PRFAQ rule and it carries through to the External FAQ.

Cover all five beats in this order:

**¶1 — Lead.** Communicate what the product or service is, who should care and why they should care (the remarkable outcome for them), and end with a direct CTA. 3–4 sentences: who, what, why remarkable. Format the headline `[City, Date] — Mapbox — [What it does in plain English]`. No jargon a smart non-expert wouldn't understand.

**¶2 — Customer problem.** Define the customer problem use case(s) and challenges the announcement addresses. Name the friction, the workaround, and the cost of the status quo. Use evidence (research, data, named customers, third-party data with a hyperlink to source). Do NOT mention the solution.

**¶3 — Solution + context.** Directly state how the Mapbox product addresses the challenges in ¶2. Go one level deeper: when these challenges typically arise, how this product works, and how customers realize value. Surface the WOW moment — the dimension where this is materially better. Include the leader quote here (typically attributed to a real VP/Director/GM): must sound human, not marketing copy. Should convey why Mapbox is uniquely positioned, why now. Bad: "We're excited to launch..." Good: "For years, developers had to choose between..."

**¶4 — Customer quote.** The customer quote adds to the points already made above, through the lens of the customer's specific business needs. **Write the quote you want them to give you** — not what a customer would say today, but what a customer will say once they've experienced the product. Use a real Mapbox customer wherever possible. If writing a PRFAQ (pre-launch), the quote drafted in the I-FAQ supplementary questions fills this slot until a real customer goes on record.

**¶5 — Pricing, availability, and CTA.** Mention pricing, availability timeline (private preview → public preview → GA), and the call to action (e.g., product web page). Close with the official Mapbox boilerplate.

---

#### EXTERNAL FAQ (E-FAQ) — customer-facing, comes first

The E-FAQ answers questions a real customer would have after reading the press release. **The E-FAQ gets published on the product page** — it carries SEO weight and establishes Mapbox as an authority on the topic. As a rule of thumb, the E-FAQ should have **more total content than the I-FAQ**: most details a Mapbox employee wants to know are also useful to customers; only the small handful of confidential or strategic details stay internal.

**Voice rule (genre exception to the no-pejorative-"you" rule in Step 4):** the FAQ format is customer dialogue, so:

- Write questions in **first person**, as the customer would actually ask them. ✅ "How do I get access to the Modular Maps SDK?" — ❌ "How do developers get access to the Modular Maps SDK?"
- Answers may use "you" (e.g. "You can access...") since the format is a Q&A dialogue. This is the only place in a PRFAQ where the no-pejorative-"you" rule yields.
- Use plain language — the words a customer would actually use, not internal terminology.

**Tense:** present tense, even for capabilities that aren't built yet. Write "the Styles API includes a GraphQL API you can use to query all styles in your account," not "we will be implementing GraphQL support."

**Question-shape pattern:** where it fits, write yes/no questions and then expand. This forces clarity and gives the customer a clean signal:

> Q: Does the product address use case A?
> A: Yes. You can accomplish this with X, Y, Z features. Here is a code snippet that addresses use case A.

**Concrete over abstract:** answers should be specific. If an answer is ambiguous, that's usually a signal of an unresolved product decision, not a writing problem. Frame answers around customer use cases, not internal mechanics — code snippets and example calls are good when they illustrate a use case.

The Mapbox template requires these six questions in this order:

1. **What are we shipping today?** — Define the feature in plain English. What is it and what does it do?
2. **Why should I use this product?** — Cover both the challenge (the customer problem) and the benefit (what the product enables). Two parts: the pain of the status quo, then what this unlocks.
3. **What are the most common use cases?** — Be as specific as possible. Name customer verticals and personas. Highlight customers (real or representative) who'd benefit most.
4. **How does it compare with alternatives? (Or: what can I do now that I couldn't do before?)** — Factual differentiation vs. alternatives or the status quo. Keep it factual, not negative. Competitor names stay out of external comms; focus on customer outcomes.
5. **How do I get started? (Or: how does it work?)** — Include code examples, screenshots, or videos to illustrate customer value. Link to the product detail page and docs.
6. **How will I be charged?** — If priced, summarize and link the Pricing doc. **If free, you must justify with supporting evidence:** Mapbox operations costs / internal COGS, competitive offering and pricing, proof of customer unwillingness to pay. Free is a defended decision, not a default.

The PM should also add: availability timeline (private preview → public preview → GA), platform support (iOS, Android, Cloud/Web), and any other question a real customer would ask after reading the press release.

**Reuse note:** the E-FAQ can be lifted into a separate document (PDF with confidential footer for Medium/Large launches) and shared with preview customers for testing.

---

#### INTERNAL FAQ (I-FAQ) — Mapbox-only, comes second

The I-FAQ surfaces every hard question Cherie, Anu, Peter, and engineering will ask. The Mapbox template requires these six questions in this order:

1. **What problem / pain does it solve? (And for whom?)** — Name the specific pain and the customer type (verticals, personas, named target adopters). If you cannot name the customer and clearly identify their needs, the PRFAQ will not meet expectations.
2. **What is in scope for this launch?** — Be explicit. List the capabilities included in this release.
3. **What will customers be most disappointed by?** — What is *not* in scope for this launch, and why? Customer-facing limitations should be surfaced in the E-FAQ as well.
4. **What is the competitive landscape? How competitive will this product be at launch?** — Direct comparison is allowed internally; avoid naming competitors in external comms.
5. **What will make this launch a success?** — State target metrics. Good metrics are **(i) controllable, (ii) actionable, (iii) reflective of lived user experience.** If using output metrics (ARR, adoption), acknowledge they are not directly controllable and explain the causal chain. If using input metrics (e.g. re-route rate), explain how they connect to the desired impact. No weasel words ("significant," "excellent") in place of numbers.
6. **How will this contribute to our business success?** — The vision, broader strategic opportunity, or TAM, and the path to that opportunity with future iterations.

**Supplementary questions** the PM should also address (reviewers will ask these):

- **Why should Mapbox solve this, and why now?** — Why us, not a partner. What forcing function makes now the right time.
- **How does this align with company goals?** — Named OKR or strategic priority. Connect to the business metric named in the Introduction.
- **What are internal dependencies / blockers?** — Named teams and named owners.
- **What is the internal pricing / packaging?** — Information not publicly messaged. If a separate Pricing doc exists, summarize and link.
- **When are we launching?** — Detailed timeline: private preview → public preview → GA with target dates.
- **Sample customer quote.** — Required even if no real customer is on record. Write the quote you want them to give you once they've experienced the product — their challenge, how the feature solves it, the business impact. **This quote populates ¶4 of the press release.**

**Format:** Question in bold, direct answer below. Don't soften. If the answer is "we don't know yet," say that and state how you'll find out.

---

#### HEADLINE / SUBHEADLINE

- **Headline:** `[City, Date] — Mapbox — [What it does in plain English]`. Must answer: what is this and why does it matter? Sentence casing (only first word capitalized — see Step 5). No jargon. If a stranger would be confused, rewrite. Test: would a journalist use this as an article title?
- **Subheadline:** One sentence. Who is it for, what specific outcome does it give them? Concrete, not abstract.

#### PROBLEM / SOLUTION / QUOTE / JOURNEY

When asked for a single PR sub-section, use the corresponding paragraph rules from the press-release section above. Constraints worth repeating:

- **Problem paragraph (¶2):** customer's reality without the product. Specific friction, workaround, cost of status quo. Cite evidence. Do not mention the solution.
- **Solution paragraph (¶3):** how Mapbox directly addresses the challenges. Include when the challenges arise + how the product works + how customers realize value. Surface the WOW moment. Leader quote lives here.
- **Leader quote:** real VP/Director/GM. Human, not marketing copy. Why Mapbox, why now.
- **Customer quote (¶4):** write the quote you want them to give you — through the lens of the customer's specific business needs. Specific, emotional, concrete. Bad: "Great product." Good: "I used to spend 20 minutes manually cleaning data. Now I run one query and it's done."
- **User journey:** one specific use case as a short narrative scene. Name the persona (e.g. "A fleet manager at a logistics company..."), the context, the action, the result. 4–6 sentences. Should feel like a real moment, not a feature list.

---

### Step 4: Apply Mapbox writing style and grammar

The PRFAQ is a Mapbox external-comms artifact. The press release will be quoted in blogs, decks, and approval meetings. Apply these rules to every section before delivery:

**Voice and point of view:**

- **Press release and longer sections: third person.** Refer to "Mapbox" — never "we" externally, never "it." If third person is awkward, rephrase rather than dropping into first person.
- **Internal FAQ: first person ("we") is acceptable** — it's an internal artifact written as a one-on-one conversation with leadership. Same applies to the Introduction.
- **Avoid the pejorative "you."** Use descriptive persona words: "customers," "developers," "partners," "drivers," "designers," "fleet managers." This reads less aggressive (especially to non-native English readers) and is more concrete.
  - ❌ "Now, you can see how the API responds."
  - ✅ "Now, developers can see how the API responds."
  - ✅✅ "Developers at \[Company\] can see how the API responds, allowing them to ship features twice as fast."

**Active voice:** prefer active voice. Watch for "was" and "by" as passive-voice signals.

- ✅ "Mapbox visually filtered the points on the map."
- ❌ "The points on the map were visually filtered."

**Oxford comma:** always use it. "I'd like to thank my parents, Ayn Rand, and God."

**Sentence casing for headlines and titles:** only the first word is capitalized (plus proper nouns). "New 3D environments enhance wayfinding" — not Title Case.

**Dates and times:**

- Dates: `Monday, January 1, 2026` or `January 1, 2026`. No ordinals (no "1st"). Don't abbreviate months.
- Times: `10:30am PT`, `10am PT` (no minutes for on-the-hour), `10am – 10:30pm` (hyphen for ranges). Lowercase `am`/`pm`, no space.
- For online events, write both PT and ET: `8am PT | 11am ET`.

**Words and phrases to avoid (replace as shown):**

| Avoid | Prefer |
|---|---|
| utilize, leverage | use, builds with, benefits from |
| users (when referring to Mapbox customers) | customers, developers, partners, companies, businesses (end users is acceptable when referring to a customer's app users) |
| empower (overused) | equip, enable, enhance |
| tool (to describe a Mapbox product) | product, solution, technology |
| thrive, synergy, groundbreaking | (rephrase — corporate jargon) |
| market-leading, world's first, cutting edge, transformative, revolutionize | (rephrase — hyperbolic / salesy) |
| significant, excellent (as substitutes for metrics) | use a specific number or quantitative metric; editorialization can follow a metric, but never replace it |
| Happy Mapping (sign-off) | Specific call to action; "Team Mapbox" for emails |

**Mapbox brand specifics:**

- Always **Mapbox** — never MapBox, mapbox, MBX, or mbx in external content. Only "Mapbox Inc." in legal context.
- **No possessive "Mapbox's" in external comms.** Rephrase the sentence to avoid it.
- Never refer to Mapbox as "it." Rephrase if third person becomes awkward.

**Product naming:**

- Service pillars: precede with "Mapbox" — e.g. Mapbox Search, Mapbox Navigation, Mapbox Maps, Mapbox Data, Mapbox Automotive. Don't use "the" with the general service area ("Mapbox Maps are highly performant").
- Specific products: first mention always uses the full name with "Mapbox" (e.g. "the Mapbox Maps SDK"). After first mention, may drop "Mapbox" in short content; restore at the start of new sections in long content.
- "The" usage by product:
  - **No "the":** Mapbox GL JS, Mapbox Search JS, Mapbox Address Autofill, Mapbox Dash, Mapbox Studio, Mapbox for EV, Mapbox Boundaries, Mapbox Movement Data, Mapbox Traffic Data.
  - **Use "the":** any product name with "API" or "SDK" appended (e.g. the Mapbox Geocoding API, the Mapbox Mobile Maps SDKs); the Mapbox Tiling Service (but drop "the" when using "MTS" or referring to Raster MTS).
- Always include "Mapbox" when dropping it would conflict with another product (e.g. "iOS SDK") or yield a confusing name (e.g. "GL JS").

**Capitalization specifics:**

- **Teams and organizations capitalized** when named: Sales, Automotive, Legal. The word "team" or "organization" is lowercase ("the Sales team").
- **Roles capitalized:** Account Manager, Program Manager.
- **Locations:** Mapbox Japan, Mapbox Helsinki, Mapbox Minsk, Mapbox DC.

**Other Mapbox-specific terms:**

- One word: Basemap, Dataset, Tileset, wayfinding.
- GeoJSON (not geojson or Geojson).
- 3D (not 3-D).
- ODL = On-Demand Logistics (hyphen, capital D).
- Event names: BUILD with Mapbox, Mapbox Locate, Mapbox Unboxed.

**Customer and competitor framing:**

- "Equip" and "enable" customers to "solve" challenges and "create" value. Respect customers as leaders in their own right who use Mapbox as a component within a larger solution.
- **In external comms, avoid naming competitors.** Direct comparisons can expose Mapbox to legal risk and read as arrogant. The Internal FAQ is the place for direct competitive comparison; the press release and External FAQ stay focused on customer outcomes.
- Avoid negativity or criticism of competitors or others' implementations in any public-facing surface.

**Boilerplate:** end the press release with `Mapbox Boilerplate – Official [last updated <year>]`.

---

### Step 5: Review against the Mapbox standard

Before delivering a draft, check:

**PRFAQ structure**

- [ ] **All four parts present** in order: Introduction → Press Release → External FAQ → Internal FAQ.
- [ ] **Cherie ask is one sentence at the top** of the Introduction, naming what decision is being requested.
- [ ] **Business metric is named explicitly** in the Introduction — not vague benefit language.
- [ ] **Launch size scored** (Large / Medium / Small) using the four-question rubric.
- [ ] **6-page cap on the main body.** Anything else moves to an appendix.
- [ ] **External FAQ comes before Internal FAQ.**
- [ ] Document marked **Mapbox Confidential** in the footer with page numbers.
- [ ] **Candidate customers are named** — the PRFAQ identifies specific customers and explains how they benefit. If you cannot name a customer, the doc will not meet expectations.

**Press release**

- [ ] All 5 paragraphs land their job: ¶1 lead (what + who + why remarkable + CTA), ¶2 problem, ¶3 solution + context + leader quote, ¶4 customer quote, ¶5 pricing/availability/CTA.
- [ ] ¶1 states **why this is remarkable** — not just what it is.
- [ ] **Customer quote (¶4) present** — real customer if possible; if pre-launch, write the quote you want them to give you.
- [ ] **Leader quote (in ¶3)** sounds human, not marketing copy.
- [ ] WOW moment lands — one sentence that makes a customer lean forward.
- [ ] Plain English — could be read aloud to a non-expert and understood.
- [ ] Mapbox boilerplate at the end.

**External FAQ**

- [ ] All 6 required questions answered, in order (shipping today / why use it / use cases / comparison / get started / pricing).
- [ ] Pricing (Q6) answer is specific. If free, the justification is included (COGS, competitive landscape, willingness-to-pay evidence).
- [ ] Availability timeline and platform support (iOS, Android, Cloud/Web) added by PM as applicable.
- [ ] Customer-facing limitations from I-FAQ Q3 are surfaced here.
- [ ] **No mention of v2** — do not telegraph that the product is not yet ready. This signals incompleteness and delays customer action.

**Internal FAQ**

- [ ] All 6 required questions answered, in order (problem+for whom / in scope / disappointments / competitive / success metrics / business contribution).
- [ ] Supplementary questions addressed: why Mapbox, goal alignment (OKR), dependencies, internal pricing, launch timeline, sample customer quote.
- [ ] Success metrics (Q5) are controllable, actionable, and reflective of lived user experience. No weasel words ("significant," "excellent") in place of quantitative metrics.
- [ ] **Sample customer quote** drafted — write the quote you want them to give you. This populates ¶4 of the press release.
- [ ] Internal pricing / packaging detail that's not publicly messaged is captured.
- [ ] Dependencies and blockers name teams and owners.

**Mapbox writing style (Step 4)**

- [ ] No "utilize," "leverage," "users" (referring to customers), "empower" (overused), "tool" (referring to products).
- [ ] No hyperbolic language ("market-leading," "world's first," "revolutionize," etc.).
- [ ] No pejorative "you" — descriptive persona words instead.
- [ ] Active voice throughout.
- [ ] Oxford comma applied.
- [ ] Sentence casing for headlines.
- [ ] Dates and times follow Mapbox format.
- [ ] **No "Mapbox's"** (possessive) in external sections.
- [ ] Product names and "the"-usage match the table.
- [ ] No competitor names in external sections; competitive comparison lives in the I-FAQ only.

**Approval-readiness**

- [ ] PRFAQ is being scheduled at least **3 months before launch.**
- [ ] **Manager + service-organization leader have reviewed** before the formal review meeting — they catch the questions internal and external stakeholders will ask.
- [ ] **Legal team review (Laurel Finch) has happened** before the PRFAQ Review Meeting — Legal is engaged at the PRFAQ stage, not after, and their review covers the new feature/product before coding starts.
- [ ] Cherie + Anu are on the review invite.
- [ ] Engineers and product marketers have reviewed before the meeting.
- [ ] If pricing is non-free, the separate Pricing doc is drafted (or scheduled for the 1-month-pre-launch pricing review).
- [ ] After approval, the plan is to engage Product Marketing for the product introduction plan within the same week.
- [ ] **Feature definition was not delegated to engineers** — if development will take 2+ weeks, the PM must own the definition before handing off.
- [ ] Review is not being triggered by a high-stakes forcing function (private preview launch, deadline). The PRFAQ should come before, not in reaction to, the forcing function.

---

### Step 6: Document critique

Run this step in two modes:
- **After drafting** any full section: append a "Critique" block below the draft surfacing weaknesses only (no re-drafting unless asked).
- **Standalone `critique` mode**: user pastes a full or partial PRFAQ draft; return only the critique output with no new draft content.

---

#### What to look for

Work through each of the six categories below. For each issue found, record: where it appears, what the problem is, and what would fix it.

**1. Unsupported claims**

Flag every assertion that a reviewer could reasonably ask "how do you know that?" and find no answer in the doc.

- Statements about customer pain ("developers lose hours every day...") without a data source, a named customer, or research citation
- Adoption or growth claims ("this will capture X% of the market") without a pipeline, a baseline, or a comparable
- Superiority claims ("the fastest," "the only solution") without a benchmark or a named comparison point
- Pricing rationale stated as fact without evidence (competitive pricing data, willingness-to-pay research, COGS analysis)
- "Customers love X" / "customers struggle with Y" without a quote, a survey result, or a named reference

**2. Logical gaps**

Flag arguments where the conclusion doesn't follow cleanly from the premises.

- The problem paragraph describes one pain point but the solution solves a different one
- The "why Mapbox" argument relies on capabilities that are generic or widely available (not differentiated)
- The "why now" timing is stated without a forcing function — a customer deadline, a competitive move, a market shift, or a contract event that makes now meaningfully different from six months from now
- An adoption goal is named but the measurement plan doesn't instrument the metric needed to track it
- A dependency is listed in the I-FAQ without confirming the dependent team has agreed to it

**3. Vague language masking unresolved decisions**

Flag language that reads like a placeholder for a decision the author hasn't made yet.

- "TBD," "to be determined," or "in progress" on anything a reviewer would need to evaluate the proposal (pricing, timeline, scope, resourcing)
- Outcome language that is directional but not measurable ("improve," "increase," "enhance," "accelerate") where a number is possible
- Scope described in terms of effort ("we will invest in X") rather than outcome ("customers will be able to do Y by Z date")
- "We are exploring" or "we will evaluate" as a substitute for a stated position

**4. Weak problem framing**

The press release lives or dies on whether the problem is real and viscerally felt. Flag:

- The problem paragraph describes inconvenience rather than a material cost (lost revenue, lost time, lost contracts, failed use cases)
- The workaround / current behavior described in ¶2 or ¶3 is framed so charitably that the reader doesn't feel the pain of it
- The problem is described at the category level ("maps are hard") rather than at the specific use-case level that this product actually solves
- No named customer type, vertical, or persona is attached to the problem — it reads as a hypothetical rather than an observed reality

**5. Solution not earning the WOW moment**

Flag cases where the solution paragraph describes what was built rather than what the customer can now do.

- The WOW moment is a feature ("includes a new API endpoint") rather than an outcome ("a developer can now do X in one call that previously required three round trips and a data-cleaning step")
- The before/after contrast is implicit — the reader has to infer the improvement rather than feel it directly
- The customer quote (real or synthetic) is generic praise rather than a specific description of the problem solved and the magnitude of change
- The solution claims differentiation but the specific dimension of superiority (faster, cheaper, more accurate, easier to integrate) is not named

**6. Internal consistency**

Flag cases where the document contradicts itself or where a claim in one section isn't supported by content elsewhere.

- The business metric named in the Introduction doesn't connect to the success metrics in I-FAQ Q5
- The launch timeline in the Introduction conflicts with the phased timeline in the I-FAQ supplementary questions
- A capability described as in-scope in I-FAQ Q2 is listed as a customer disappointment in I-FAQ Q3 (or vice versa) without explanation
- The customer quote (¶4) describes a benefit the press release doesn't mention

---

#### Critique output format

Do not re-draft sections — flag, explain, and prescribe the fix. Use this structure:

```
## PRFAQ Critique — [Product / Section Name]

### Issues found

| # | Section | Severity | Issue | Fix |
|---|---------|----------|-------|-----|
| 1 | [e.g. PR ¶2, I-FAQ Q3] | 🔴 / 🟡 | [one-line description] | [one-line fix] |
| 2 | ... | | | |

### Top gaps before this goes to review
1. [The issue most likely to cause a reviewer to ask for a rewrite]
2. [Second most critical]
3. [Third most critical]

### Overall assessment
[One sentence: "Strong draft — minor gaps to close." / "Solid structure, but the problem framing and [X] need evidence before review." / "Core argument needs rework — the problem/solution match is unclear."]
```

Use 🔴 for issues that undermine the core argument or would block approval (unsupported key claims, logical disconnects, major missing evidence). Use 🟡 for issues that would generate skeptical questions a sharp reviewer would ask (vague language, thin competitive framing, directional goals without numbers).

---

## Notes

- **Mapbox PRFAQ is a decision artifact, not a vision doc.** The Introduction's "what do we need from Cherie today" framing is load-bearing. Lead with the ask.
- **The sample customer quote in the I-FAQ supplementary questions populates ¶4 of the press release.** Write the quote you want them to give you — it is the customer voice for this PRFAQ until a real customer goes on record.
- If you can't write a compelling press release, the product strategy is weak — not the writing. Treat a weak PR as a signal to go back to the customer problem.
- The PR is a design tool, not marketing copy. It forces precision about what matters to the customer.
- The PRFAQ is a living document. Keep updating it through preview as customer learnings come in.
- **Legal review happens at the PRFAQ stage**, before coding starts — not after the PRFAQ is approved. Loop in Laurel Finch (Legal) before the formal review meeting with Cherie and Anu.
- **Pre-review path:** PM → manager → service organization leader → Legal (Laurel) → PRFAQ Review Meeting (Cherie + Anu + Peter, plus Service / Marketing / Finance / Customer Engagement stakeholders). After approval, engage Product Marketing immediately to start the product introduction plan.
- **Peter review is required.** Confirm that what you're shipping has been reviewed with Peter (CEO) before it goes to public use. His context refines the proposal, helps disseminate information with customers and internal teams, and validates direction. If it's not being reviewed with Peter, it's a disservice to the team and the business.
- After PRFAQ approval, open Legal-followup, Security, and Billing tickets within one week.
- **Don't mention v2 in the E-FAQ.** It signals the product is not ready and delays customer action.
- **Don't use weasel words ("significant," "excellent") as substitutes for metrics.** Editorialization can follow a metric ("grew 30%, significantly ahead of goal"), but never replace it. A metric that cannot be stated precisely is a strategy that hasn't been resolved.
- **Don't delegate feature definition to engineers** for work that will take 2+ weeks. The PM owns definition.
- **Don't demo technology for its own sake** as a stand-in for a product demo. The demo must identify the specific customer pain, show how the customer uses the product, and explain why this is remarkable.
- **Don't make a case based on "we've never done this before."** Future growth requires doing things differently; novelty is not a strategy argument.
- **On using AI to draft PRFAQs:** AI can help you draft, but the PM must own the output. If >90% of the words were written by AI, consider marking the doc "AI-powered"; if AI informed the narrative but >90% of the words are yours, "AI-enabled" is appropriate. Don't fall asleep at the wheel — if you're not validating and owning your work, you're delegating it to your manager, and eventually to Peter. What's measured is delivered impact, not doc velocity.
- For Medium/Large launches, prepare a "Customer Facing PRFAQ Version" (PDF with confidential footer) for preview testing.
- Reference example PRFAQs: MTS Incremental Updates (`1rMSMGrtJ5MGXgYv_ExWZ7rzHyOeZPsco9P2jM5wmZb4`) and Mapbox Fleet (`17QCxYxQRnAerjgU-n5maPTVhEmkEVMagxgQci-sYjjY`).
- **Reference published press release:** [Mapbox + BMW Navigation SDK launch](https://www.businesswire.com/news/home/20201214005607/en/Mapbox-Launches-Navigation-SDK-for-Automotive-BMW-Group-Launch-Partner) — model your PR tone against this.
