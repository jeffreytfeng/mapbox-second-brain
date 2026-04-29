---
name: draft-prfaq-section
description: Write a specific PRFAQ section using Amazon's Working Backwards methodology
argument-hint: "[section] [product-or-topic]  — section: pr | ifaq | cfaq | headline | problem | solution | quote | journey"
user-invocable: true
---

# PRFAQ Section Drafter

Write or sharpen a specific section of a PRFAQ using Amazon's Working Backwards methodology. The PRFAQ disciplines you to define the customer experience before any engineering starts.

## What is a PRFAQ?

A PRFAQ is a 1–5 page document with two parts:
- **Press Release (PR):** ~1 page written as if the product has already launched. Forces you to define the customer experience and value before you build anything.
- **FAQ:** Internal questions (I-FAQ) your leadership and engineering team will ask + Customer questions (C-FAQ) your users will ask.

The test: if the PR isn't compelling enough that you'd genuinely want to use the product, stop and redesign the product — not the PR.

---

## Instructions

### Step 1: Identify What to Write

Parse the arguments to determine:
- **Which product/feature?** Infer from context or ask.
- **Which section?** Map input to one of:
  - `pr` — Full press release
  - `headline` — Headline + subheadline only
  - `problem` — Customer problem paragraph
  - `solution` — Solution paragraph
  - `quote` — Leader quote + customer testimonial quote
  - `journey` — User journey paragraph (the "how it works" scene)
  - `ifaq` — Internal FAQ (hard business/leadership questions)
  - `cfaq` — Customer FAQ (what users will ask)

If no section is specified, ask which section the user wants help with.

### Step 2: Gather Context

- Read `Tasks/active.md` for in-progress PRFAQ work
- Read `Knowledge/Context/goals.md` for OKR alignment
- Search Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files`) for relevant meeting notes, research, or existing PRFAQ drafts; fall back to `Raw/` if Drive MCP is unavailable or returns nothing
- Check `Knowledge/People/` for stakeholder perspectives that should be reflected
- Look for: user pain points, metrics, customer quotes, competitive signals, hard constraints

### Step 2b: Apply voice profile

Read `Knowledge/Context/my-voice.md` — apply its tone, structure, and formatting preferences throughout the draft. If the file only contains the placeholder (not yet generated), proceed with default PM tone.

### Step 3: Draft Using Section-Specific Guidance

---

#### PRESS RELEASE STRUCTURE

**Headline**
- Format: `[City, Date] — [Company] — [What it does in plain English]`
- Must answer: What is this and why does it matter?
- No jargon. No product names that need explanation. If a stranger would be confused, rewrite.
- Test: Would a journalist use this as an article title?

**Subheadline**
- One sentence: Who is it for, and what specific outcome does it give them?
- Make it concrete, not abstract.

**First Paragraph (the lede)**
- Cover: who the customer is, what the product is, the headline benefit
- Write as if quoting the announcement — present tense, third person on the company, present tense on the product
- 3–4 sentences max

**Problem Paragraph**
- Describe the customer's current reality WITHOUT the product
- Be specific: name the friction, the workaround, the cost of the status quo
- Use evidence from research, customer quotes, or data where available
- Do NOT mention the solution in this paragraph
- Good test: does this paragraph make a reader feel the problem?

**Solution Paragraph**
- Explain how the product solves the problem, from the customer's perspective
- Focus on the experience and outcome, not the technical mechanism
- Answer: what is different about how they accomplish their goal now?
- One WOW moment: the thing that makes this 10x better on some dimension

**Leader Quote**
- Attribute to a real VP/Director/GM who would logically own this
- Must sound like a human, not marketing copy
- Should convey: why your company is uniquely positioned to do this + why it matters now
- Bad: "We're excited to launch..." Good: "For years, developers had to choose between..."

**User Journey Paragraph**
- Walk through one specific use case as a short narrative scene
- Name the user type (e.g., "A fleet manager at a logistics company..."), the context, the action, and the result
- Should feel like a real moment, not a feature list
- 4–6 sentences

**Customer Quote**
- Fictional but grounded — should reflect what a real customer would say based on research
- Specific, emotional, concrete — not "Great product, highly recommend"
- Good: "I used to spend 20 minutes manually cleaning data. Now I run one query and it's done. That's hours back per week."

**Call to Action**
- One sentence: where to go, what to do
- Should be realistic for the launch stage (e.g., "Sign up for private preview at...")

---

#### INTERNAL FAQ (I-FAQ)

The I-FAQ surfaces every hard question leadership and engineering will ask. If a question doesn't have a good answer, that's a signal the product strategy needs work — not that you should skip the question.

**Required question categories to cover:**

1. **Market & sizing**
   - How large is the addressable market? What's our realistic capture?
   - Why now — what's changed in the market or our capabilities?

2. **Customer evidence**
   - What customer research supports this? How many customers validated the problem?
   - What happens if we don't build this — do customers churn, go to a competitor, build it themselves?

3. **Business case**
   - What is the revenue/ARR impact? Over what timeline?
   - What does a successful outcome look like in 12 months? In 3 years?
   - What's the cost to build and maintain?

4. **Competitive position**
   - Who else is doing this? Why would customers choose us?
   - What is our sustainable advantage — data, distribution, integration, price?

5. **Technical feasibility**
   - What are the hardest engineering problems?
   - What dependencies exist on other teams or systems?
   - What would cause this to fail or take 3x longer than planned?

6. **Risks and tradeoffs**
   - What are we explicitly not doing, and why?
   - What assumptions are we making that could be wrong?
   - What does failure look like, and how would we know early?

7. **Metrics**
   - What are the primary success metrics? What are the guardrails?
   - How do we measure product-market fit?

**Format:** Question in bold, direct answer below. Don't soften. If the answer is "we don't know yet," say that and state how you'll find out.

---

#### CUSTOMER FAQ (C-FAQ)

The C-FAQ answers questions a real user would have after reading the press release.

**Required question categories:**

1. **What is it / what does it do?** (Plain English, no jargon)
2. **Who is it for?** (Be specific — which personas, which use cases)
3. **How is it different from [existing alternative]?** (Competitor, current product, status quo workaround)
4. **How do I get started?** (Pricing, access, integration effort)
5. **What does it cost?** (Even if TBD, frame the pricing model)
6. **What does it NOT do?** (Explicit scope exclusions prevent misaligned expectations)
7. **Is my data safe / private?** (If relevant)
8. **What support is available?**

**Format:** Question in bold, 1–4 sentence answer. Write the question as the customer would ask it, not as you'd frame it internally.

---

### Step 4: Review Against Amazon Standards

Before delivering a draft, check:

- [ ] **No jargon**: Any term a smart non-expert couldn't understand must be defined or removed
- [ ] **Customer perspective throughout**: Does every sentence serve the customer's understanding, or is it inside-out company speak?
- [ ] **Claims are grounded**: Every factual assertion has a source (data, research, quote). Flag assumptions explicitly.
- [ ] **The WOW moment lands**: Is there a single sentence in the PR that would make a customer lean forward?
- [ ] **The hardest FAQ questions are answered**: Don't leave out uncomfortable questions — that's the whole point
- [ ] **Plain English**: Could you read this aloud to your grandmother and have her understand what you're building?

---

## Notes

- Amazon's rule: if you can't write a compelling PR, you shouldn't build the product. Treat a weak PR as a product strategy signal, not a writing problem.
- The PR is not marketing copy — it's a design tool. It forces precision about what matters to the customer.
- Write the customer quote last. It will naturally reflect whether the rest of the PR actually solved something real.
- For I-FAQ: the goal is to surface the questions you don't want to answer, then answer them. If leadership will ask it in a meeting, it belongs here.
- The PRFAQ is a living document. Sections should be revised as you learn more — especially after customer discovery sessions.
