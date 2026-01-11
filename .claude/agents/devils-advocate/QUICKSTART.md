# Devil's Advocate - Quick Start Guide

**Challenge assumptions and improve decisions in 3 minutes.**

---

## 🚀 Your First Critical Review in 3 Steps

### Step 1: Present Your Proposal (1 minute)

**Prompt:**
```
Proposer, I want to present this proposal for review:

Proposal: Migrate all Azure resources to a single subscription for simplified management

Background:
- Currently have 5 subscriptions (dev, staging, prod, shared-services, sandbox)
- Managing separate subscriptions is complex (RBAC, policies, cost tracking)
- Want to reduce overhead

Present this proposal with rationale and benefits.
```

**What Proposer Does:**
- Structures your proposal clearly
- Articulates benefits with evidence
- Acknowledges potential concerns upfront
- Frames the problem and solution

---

### Step 2: Challenge the Proposal (1 minute)

**Prompt:**
```
Challenger, critique the single-subscription proposal.

Identify:
- Risks and potential issues
- Flawed assumptions
- Alternative approaches
- Edge cases or failure modes
```

**What Challenger Does:**
- Identifies blast radius risks (one sub = all environments affected)
- Questions cost management complexity in single sub
- Raises RBAC and security boundary concerns
- Proposes alternatives (management groups, better tooling)

---

### Step 3: Synthesize Decision (1 minute)

**Prompt:**
```
Moderator, synthesize the discussion.

Evaluate:
- Valid points from both sides
- Which concerns are critical vs manageable
- What middle ground exists
- What the final recommendation should be

Document as ADR.
```

**What Moderator Does:**
- Weighs Proposer's benefits vs Challenger's risks
- Identifies hybrid solution (consolidate dev/staging, keep prod separate)
- Documents decision with rationale
- Lists follow-up actions

---

## 📋 Copy & Paste Templates

### Template 1: Architecture Decision

```
Proposer: Present proposal to [architecture decision]

Proposal: [Your proposed solution]
Context: [Current state and problem]
Benefits: [Why this is better]
Risks: [Known concerns]

---

Challenger: Critique the proposal above

Focus on:
- Technical risks
- Scalability concerns
- Security implications
- Cost impact
- Alternative approaches

---

Moderator: Synthesize and decide

Consider:
- Business requirements: [List]
- Risk tolerance: [HIGH|MEDIUM|LOW]
- Timeline constraints: [Duration]

Provide ADR with recommendation.
```

---

### Template 2: Technology Selection

```
Proposer: We need to choose between [Technology A] and [Technology B] for [use case]

I propose: [Technology A]

Reasons:
1. [Benefit 1]
2. [Benefit 2]
3. [Benefit 3]

Present full case.

---

Challenger: Identify weaknesses in [Technology A] choice

Consider:
- Vendor lock-in
- Community support
- Learning curve
- Long-term viability
- Hidden costs

Argue for [Technology B] or alternatives.

---

Moderator: Which technology should we choose and why?

Create decision matrix with scoring.
```

---

### Template 3: Process Change

```
Moderator: Facilitate discussion on proposed process change

Proposal: [Process change description]

1. Proposer: Make the case for this change
   - Current pain points
   - How change addresses them
   - Implementation plan

2. Challenger: Identify risks and unintended consequences
   - Team disruption
   - Edge cases
   - Alternative improvements

3. Synthesize: What version of this change should we adopt?
```

---

## 🎯 When to Use Devil's Advocate

### ✅ High-Value Use Cases

**1. Major Architecture Decisions**
```
Example: Moving from VMs to Kubernetes

Proposer: Present K8s migration benefits
Challenger: Question complexity, cost, team readiness
Moderator: Decide on phased approach vs all-in
```

**2. Security Design Reviews**
```
Example: Opening firewall port for third-party integration

Proposer: Present business need and security controls
Challenger: Identify attack vectors, alternative approaches
Moderator: Approve with specific security conditions
```

**3. Cost/Performance Trade-offs**
```
Example: Using Premium vs Standard storage tier

Proposer: Present performance requirements justifying Premium
Challenger: Question if requirements are accurate, suggest testing
Moderator: Approve test period with metrics to decide
```

**4. Technology Platform Selection**
```
Example: Azure SQL vs PostgreSQL on VMs

Proposer: Present PaaS benefits (Azure SQL)
Challenger: Question vendor lock-in, cost scaling
Moderator: Choose Azure SQL with documented migration path
```

**5. Compliance vs Usability**
```
Example: Mandatory MFA for all accounts vs developer friction

Proposer: Present compliance requirements
Challenger: Present developer productivity impact
Moderator: Tiered approach (prod=MFA required, dev=optional)
```

---

### ❌ Don't Use For (Low-Value Cases)

- ❌ Routine implementation details
- ❌ Well-established patterns
- ❌ Minor configuration changes
- ❌ Time-sensitive tactical decisions
- ❌ Decisions easily reversible

**Why not?** The Devil's Advocate process adds time and overhead. Use it for decisions that matter.

---

## 💡 Pro Tips

### Tip 1: Define Success Criteria First

Before starting the dialectic, establish what "good decision" means.

**Example:**
```
Moderator, before we debate [proposal], establish decision criteria:

Must-haves:
- [Criteria 1]
- [Criteria 2]

Important but negotiable:
- [Criteria 3]

Use these to evaluate the final recommendation.
```

---

### Tip 2: Time-Box the Discussion

Don't let debates go in circles. Set limits.

**Example:**
```
Moderator: We have 30 minutes to decide on [topic]

- 10 min: Proposer presents
- 10 min: Challenger critiques
- 5 min: Proposer responds
- 5 min: You synthesize and decide

Keep us on track.
```

---

### Tip 3: Focus on High-Impact Risks

Challenger should prioritize big risks over nitpicking.

**❌ Low-value critique:**
```
Challenger: The naming convention in the proposal has a typo.
```

**✅ High-value critique:**
```
Challenger: The proposal doesn't address what happens if the primary region fails completely. This is a critical gap for our RTO requirements.
```

---

### Tip 4: Proposer Should Thank Challenger

Good critiques improve proposals. Acknowledge them.

**Example:**
```
Proposer: Challenger raised a valid point about [issue].

I'm revising the proposal to address this by [solution].

This is a better outcome than my original proposal. Thank you for catching this.
```

---

### Tip 5: Moderator Decides Even Without Consensus

Sometimes there's no perfect answer. Moderator must still decide.

**Example:**
```
Moderator: There are legitimate concerns on both sides.

Decision: We proceed with [Option A] because [primary reason], BUT we will [mitigation for Challenger's top concern].

This is not consensus, but it's the best path forward given our constraints.
```

---

## 🔧 Common Patterns

### Pattern 1: Pre-Mortem Analysis

Use when you want to identify failure modes before committing.

```
Challenger, run a pre-mortem on [proposal]:

Scenario: We implemented this proposal 6 months ago. It failed badly.

What went wrong? List 5 most likely failure modes.

---

Proposer, for each failure mode Challenger identified, provide mitigation strategy.

---

Moderator, which failure modes are deal-breakers? Should we proceed?
```

---

### Pattern 2: SWOT Analysis

Use for comprehensive evaluation.

```
Challenger, perform SWOT analysis on [proposal]:

Strengths: [Internal positives]
Weaknesses: [Internal negatives]
Opportunities: [External positives]
Threats: [External negatives]

---

Proposer, respond to the weaknesses and threats. How do we address them?

---

Moderator, given the SWOT, what's the verdict?
```

---

### Pattern 3: Red Team Exercise

Use for security-critical decisions.

```
Challenger, act as attacker/adversary for [security proposal]:

How would you:
- Bypass the proposed controls?
- Exploit edge cases?
- Use social engineering?
- Persist after initial compromise?

---

Proposer, strengthen the proposal to defend against these attacks.

---

Moderator, is the security posture acceptable?
```

---

### Pattern 4: Cost-Benefit Analysis

Use when cost is a primary concern.

```
Proposer, present [proposal] with detailed cost breakdown:
- Implementation cost
- Ongoing cost (3-year TCO)
- Quantified benefits

---

Challenger, question the cost assumptions:
- Hidden costs
- Optimistic projections
- Cheaper alternatives

---

Moderator, does ROI justify the investment?
```

---

## 🔗 Integration with BMAD Agents

### Use Case: Architecture Review with Astra

```
Astra, you proposed hub-spoke network topology for the landing zone.

Now, critical review:

Proposer: Defend the hub-spoke design
- Why hub-spoke vs alternatives?
- How does it meet requirements?
- What are the benefits?

Challenger: Identify weaknesses
- Cost concerns ($2.5K/month for firewall)
- Complexity for small team
- Hub as single point of failure

Moderator: Is hub-spoke the right choice? If yes, with what conditions?
```

---

### Use Case: Cost Review with Finn

```
Finn, you recommended Reserved Instances for 50 VMs ($100K upfront, 40% savings).

Critical review:

Proposer (Finn): Make the case for RIs
- ROI calculation
- Break-even timeline
- Risk mitigation

Challenger: Challenge the recommendation
- What if workload patterns change?
- What if we migrate to AKS (VMs no longer needed)?
- Opportunity cost of $100K upfront

Moderator: Should we buy RIs? All 50 or just a subset?
```

---

### Use Case: Security Review with Cora

```
Cora, you proposed zero-trust network with Private Link for all PaaS services.

Critical review:

Proposer (Cora): Present security benefits
- Reduced attack surface
- Compliance advantages
- Defense in depth

Challenger: Question practicality
- High cost (Private Endpoints add up)
- Complexity for developers
- Does it address actual threats?

Moderator: What level of Private Link adoption is appropriate?
```

---

## 📚 Next Steps

### Learn More
- **Full Documentation**: See [README.md](./README.md) for complete system details
- **Integration**: See [bmad-azure-infra/README.md](../bmad-azure-infra/README.md) for technical agent system
- **ADR Template**: In README.md for documenting decisions

### Practice Makes Perfect

Start with low-stakes decisions:
1. **Week 1**: Technology comparison (e.g., tool selection)
2. **Week 2**: Process improvement (e.g., PR review process)
3. **Week 3**: Architecture refinement (e.g., caching strategy)
4. **Week 4**: High-stakes decision (e.g., multi-region design)

### Customize for Your Team

Adapt the process:
- Adjust time-boxing based on decision complexity
- Add domain-specific critique frameworks
- Integrate with your ADR workflow
- Train team members on roles

---

## 🆘 Common Pitfalls & Solutions

### Pitfall 1: Challenger is Too Aggressive
**Symptom:** Personal attacks, dismissive tone, nitpicking
**Solution:** 
```
Moderator: Challenger, focus on the idea, not the person. Critique constructively and offer alternatives.
```

---

### Pitfall 2: Proposer is Defensive
**Symptom:** Dismissing all critiques, refusing to adapt
**Solution:**
```
Moderator: Proposer, the goal is to improve the proposal, not win an argument. Which critiques have merit?
```

---

### Pitfall 3: Circular Discussion
**Symptom:** Same points repeated, no progress
**Solution:**
```
Moderator: We're repeating arguments. Here's what I've heard from both sides: [summary]

The core disagreement is: [issue]

My decision: [verdict] because [reasoning]
```

---

### Pitfall 4: Analysis Paralysis
**Symptom:** Endless critique, no decision
**Solution:**
```
Moderator: Time's up. We have enough information.

Decision: [choice] with these caveats: [list]

Acknowledge this isn't perfect, but we must proceed. Document risks and monitor.
```

---

### Pitfall 5: Groupthink Despite Process
**Symptom:** Challenger agrees too easily
**Solution:**
```
Moderator: Challenger, I notice you're agreeing with everything. That defeats the purpose.

Your job is to identify flaws. If you genuinely see none, say "I've tried to find issues and cannot." But really try.
```

---

## 🎓 Mastery Checklist

**Beginner:**
- [ ] Understand 3 agent roles
- [ ] Run first dialectic session
- [ ] Document decision in ADR

**Intermediate:**
- [ ] Facilitate 5+ sessions
- [ ] Time-box discussions effectively
- [ ] Apply critique frameworks (SWOT, Pre-Mortem)
- [ ] Integrate with BMAD agents

**Advanced:**
- [ ] Customize process for team
- [ ] Train others on Devil's Advocate
- [ ] Know when NOT to use it
- [ ] Measure decision quality improvement

---

**Ready? Start with Template 1 and a simple architecture decision!**
