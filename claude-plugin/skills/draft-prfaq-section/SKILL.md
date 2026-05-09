---
name: draft-prfaq-section
description: Write a specific PRFAQ section using Mapbox's PRFAQ standard (Working Backwards adapted for Mapbox)
argument-hint: "[section] [product-or-topic]  — section: intro | pr | efaq | ifaq | headline | problem | solution | quote | journey"
user-invocable: true
---

# PRFAQ Section Drafter

Write or sharpen a specific section of a PRFAQ following the Mapbox PRFAQ standard. The PRFAQ disciplines you to define the customer experience before any engineering starts, and to land approval from Cherie Wong (CTO) and Anu Sharma (GM) before resourcing follows.

## What is a Mapbox PRFAQ?

The PRFAQ is rooted in Amazon's [Working Backwards](https://www.amazon.com/Working-Backwards-Insights-Stories-Secrets/dp/1250267595) methodology: write the customer experience first, then build. The PR is a design tool that forces precision about what matters to the customer, and the FAQ surfaces every hard question before engineering starts.

A Mapbox PRFAQ is **6 pages max** with four parts, in this order:

1. **Introduction** — pre-meeting framing with the explicit Cherie ask, launch size, and the business metric being moved.
2. **Press Release (PR)** — 6 paragraphs written as if the product has already launched.
3. **External FAQ (E-FAQ)** — customer-facing questions; **comes before Internal FAQ.**
4. **Internal FAQ (I-FAQ)** — strategic, financial, and technical questions for Mapbox leadership.

Anything beyond 6 pages goes to an appendix.

The PRFAQ is reviewed at least **3 months before launch**. Approval comes from Cherie (CTO/SVP) and Anu (GM). The PRFAQ is a living document — keep updating it through preview.

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

If no section is specified, ask which section the user wants help with.

### Step 2: Gather context

- Read `Tasks/active.md` for in-progress PRFAQ work.
- Read `Knowledge/Context/goals.md` for OKR alignment — the introduction explicitly asks how the feature aligns with company goals.
- Search Google Drive (`mcp__claude_ai_Google_Drive__search_files`) for relevant meeting notes, research, or existing PRFAQ drafts; fall back to `Raw/` if Drive MCP is unavailable.
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

---

#### PRESS RELEASE (6 paragraphs — strict structure)

The press release has four named structural elements wrapping the body paragraphs. Each one does a specific job:

- **Head** — the title. Appears in the wire summary feed (e.g. BusinessWire). Plain English, no jargon, journalist-usable.
- **Deck** — the subhead. Does not appear in the wire summary; sets up the lede for readers who clicked through. One sentence: who it's for, what specific outcome it delivers.
- **Dateline** — `CITY, STATE — Date —` opens the body. Standard wire convention.
- **Boilerplate** — `ABOUT MAPBOX®` block at the end. Use the latest official copy; do not paraphrase.

Write the body in **present tense as if the product already exists** — not "we will be implementing X," but "the API includes X." This is a Mapbox PRFAQ rule and it carries through to the External FAQ.

Compress if you can convey the substance in less, but cover all six beats in this order:

**¶1 — Announcement.** What we're announcing. Headline first, then 3–4 sentences as a journalist would lede: who, what, headline benefit. Format the headline `[City, Date] — Mapbox — [What it does in plain English]`. No jargon a smart non-expert wouldn't understand.

**¶2 — Customer problem.** Describe the customer's reality without the product. Name the friction, the workaround, the cost of the status quo. Use evidence (research, data, named customers). Do NOT mention the solution.

**¶3 — Today's workaround.** What customers are doing today to overcome the problem. This is the second half of the problem framing — what they hack together, what they buy from competitors, what they leave on the table. Sets up the contrast with ¶4.

**¶4 — What we're launching.** Explain how the product solves the problem from the customer's perspective. Focus on experience and outcome, not technical mechanism. Surface the WOW moment — the dimension where this is materially better.

**¶5 — Customer voice + traction.** What customers are doing or saying right now. **Include a customer quote** — use a real Mapbox customer wherever possible, ideally one already working with us on this problem. The synthetic quote drafted in the Internal FAQ (Step 3, I-FAQ Q13) is what populates this paragraph if no real customer is on record yet.

**¶6 — Wrap.** Close with a call to action realistic for the launch stage (e.g. "Sign up for private preview at...") and the official Mapbox boilerplate at the end.

**Leader quote** is embedded in the press release (typically attributed to a real VP/Director/GM who would logically own this). Must sound like a human, not marketing copy. Should convey: why Mapbox is uniquely positioned, why now. Bad: "We're excited to launch..." Good: "For years, developers had to choose between..."

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

The Mapbox template requires these questions in this order:

1. **What are we launching today?** — Define the feature in plain English.
2. **What can I do now that I couldn't do before?** — Two paragraphs:
   - ¶1: business value prop + the customer problem with current state.
   - ¶2: what was built/changed; how it addresses the challenge; why customers will be delighted. Differentiation vs. competition is acceptable here — keep it factual, not negative.
3. **How does the feature work?** — Several sub-questions if needed. Include code examples, screenshots, or videos to illustrate customer value whenever possible.
4. **What are some customer use cases?** — Highlight customers (real or representative) who'd benefit. Use named verticals and personas.
5. **How much will the feature cost?** — If priced, summarize and link the Pricing doc. **If free, you must justify with supporting evidence:** Mapbox operations costs / internal COGS, competitive offering and pricing, proof of customer unwillingness to pay. Free is a defended decision, not a default.
6. **When is the product available?** — Add a timeline (private preview → public preview → GA).
7. **How do customers get started?** — Link to the product detail page, docs, code examples (added when available).
8. **Which platforms is this supported on?** — iOS, Android, Cloud/Web. List explicitly.

The PM may add additional questions as needed.

**Reuse note:** the E-FAQ can be lifted into a separate document (PDF with confidential footer for Medium/Large launches) and shared with preview customers for testing.

---

#### INTERNAL FAQ (I-FAQ) — Mapbox-only, comes second

The I-FAQ surfaces every hard question Cherie, Anu, and engineering will ask. The Mapbox template requires these questions in this order:

1. **What problem does the feature solve?**
2. **Whom does this solve the problem for?** — Focus on verticals and/or personas. Add target customer adopters where known.
3. **Why should Mapbox solve this problem?** — Why us, why now, why is this on our roadmap rather than a partner's.
4. **How does the feature align with company goals?** — Tie to the OKR or strategic priority. The introduction names the business metric; this answer connects it to the goal hierarchy.
5. **What capabilities are in scope?**
6. **What capabilities are out of scope? Are there any known deficiencies or limitations that should be called out to customers?** — Customer-facing limitations get surfaced in the E-FAQ.
7. **What alternatives are out there and how does our offering compare?** — Direct comparison is allowed internally; in external comms we avoid naming competitors (legal + tone risk).
8. **Are there any internal dependencies/blockers?** — Named teams and named owners.
9. **What is pricing for the feature?** — Include internal pricing information that won't be publicly messaged. If a separate Pricing doc exists (Cherie's template), summarize and link.
10. **When are we launching the feature?** — More detailed than the public timeline. Include private preview → public preview → GA stages with target dates.
11. **What is our adoption goal?** — At minimum, set a goal for the upcoming launch phase. Ideally for all phases.
12. **How will we measure adoption?** — Dashboard, target adopters sheet, or other concrete instrumentation.
13. **Sample customer quote.** — Required even if no real customer is on record. Write a synthetic but grounded quote from a customer already interested in the feature; describe their challenge, how the feature solves it, and the business impact. **This quote populates ¶5 of the press release.**

**Format:** Question in bold, direct answer below. Don't soften. If the answer is "we don't know yet," say that and state how you'll find out.

---

#### HEADLINE / SUBHEADLINE

- **Headline:** `[City, Date] — Mapbox — [What it does in plain English]`. Must answer: what is this and why does it matter? Sentence casing (only first word capitalized — see Step 5). No jargon. If a stranger would be confused, rewrite. Test: would a journalist use this as an article title?
- **Subheadline:** One sentence. Who is it for, what specific outcome does it give them? Concrete, not abstract.

#### PROBLEM / SOLUTION / QUOTE / JOURNEY

When asked for a single PR sub-section, use the corresponding paragraph rules from the press-release section above. Constraints worth repeating:

- **Problem paragraph:** customer's reality without the product. Specific friction, workaround, cost of status quo. Cite evidence. Do not mention the solution.
- **Solution paragraph:** how it solves the problem from the customer's perspective. Experience and outcome, not technical mechanism. Surface the WOW moment.
- **Leader quote:** real VP/Director/GM. Human, not marketing copy. Why Mapbox, why now.
- **Customer quote:** specific, emotional, concrete. Bad: "Great product." Good: "I used to spend 20 minutes manually cleaning data. Now I run one query and it's done."
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

**Press release**

- [ ] All 6 paragraphs land their job; no paragraph collapses problem and solution into one.
- [ ] **Customer quote present** — real customer if possible, synthetic from I-FAQ Q13 if not.
- [ ] **Leader quote** sounds human, not marketing copy.
- [ ] WOW moment lands — one sentence that makes a customer lean forward.
- [ ] Plain English — could be read aloud to a non-expert and understood.
- [ ] Mapbox boilerplate at the end.

**External FAQ**

- [ ] All 8 required questions answered, in order.
- [ ] Pricing answer is specific. If free, the justification is included (COGS, competitive landscape, willingness-to-pay evidence).
- [ ] Platforms (iOS, Android, Cloud/Web) explicitly broken out.
- [ ] Customer-facing limitations from I-FAQ Q6 are surfaced here.

**Internal FAQ**

- [ ] All 13 required questions answered, in order.
- [ ] Goal alignment is concrete (named OKR / company priority).
- [ ] Adoption goal and measurement plan are specific.
- [ ] **Sample customer quote** drafted — even if synthetic.
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

---

## Notes

- **Mapbox PRFAQ is a decision artifact, not a vision doc.** The Introduction's "what do we need from Cherie today" framing is load-bearing. Lead with the ask.
- **The synthetic customer quote in I-FAQ Q13 populates ¶5 of the press release.** Write it well — it is the customer voice for this PRFAQ until a real customer goes on record.
- If you can't write a compelling press release, the product strategy is weak — not the writing. Treat a weak PR as a signal to go back to the customer problem.
- The PR is a design tool, not marketing copy. It forces precision about what matters to the customer.
- The PRFAQ is a living document. Keep updating it through preview as customer learnings come in.
- **Legal review happens at the PRFAQ stage**, before coding starts — not after the PRFAQ is approved. Loop in Laurel Finch (Legal) before the formal review meeting with Cherie and Anu.
- **Pre-review path:** PM → manager → service organization leader → Legal (Laurel) → PRFAQ Review Meeting (Cherie + Anu, plus Service / Marketing / Finance / Customer Engagement stakeholders). After approval, engage Product Marketing immediately to start the product introduction plan.
- After PRFAQ approval, open Legal-followup, Security, and Billing tickets within one week.
- For Medium/Large launches, prepare a "Customer Facing PRFAQ Version" (PDF with confidential footer) for preview testing.
- Reference example PRFAQs: MTS Incremental Updates (`1rMSMGrtJ5MGXgYv_ExWZ7rzHyOeZPsco9P2jM5wmZb4`) and Mapbox Fleet (`17QCxYxQRnAerjgU-n5maPTVhEmkEVMagxgQci-sYjjY`).
- **Reference published press release:** [Mapbox + BMW Navigation SDK launch](https://www.businesswire.com/news/home/20201214005607/en/Mapbox-Launches-Navigation-SDK-for-Automotive-BMW-Group-Launch-Partner) — model your PR tone against this.
