# Devil's Advocate Command

description: "Initiate a multi-agent Devil's Advocate conversation where agents debate a topic to surface blind spots and stress-test ideas"

parameters:
  - name: topic
    description: "The topic or position to debate"
    type: string
    required: true
  - name: max_turns
    description: "Maximum number of conversation turns"
    type: integer
    default: 10
  - name: include_moderator
    description: "Include moderator synthesis at the end"
    type: boolean
    default: true
  - name: user_context
    description: "Additional context for the agents"
    type: string
    default: ""
  - name: auto_continue
    description: "Run conversation without pausing between turns"
    type: boolean
    default: false
  - name: help
    description: "Display usage examples and help"
    type: boolean
    default: false

instructions: |
  IF help parameter is true, display the following and exit:
  
  # 🎭 Devil's Advocate - Multi-Agent Debate System
  
  ## Overview
  
  The Devil's Advocate command orchestrates structured debates between multiple Claude agents:
  - **Proposer Agent**: Proposes and defends positions
  - **Challenger Agent**: Questions assumptions and finds weaknesses
  - **Moderator Agent**: Synthesizes insights and identifies consensus
  
  ## Usage Examples
  
  ### Basic Conversation
  ```bash
  # Simple debate on a technical decision
  claude devils-advocate --topic "Should we use microservices for this project?"
  
  # Quick architectural discussion
  claude devils-advocate --topic "API design: REST vs GraphQL"
  ```
  
  ### Extended Conversations
  ```bash
  # Longer debate with more turns
  claude devils-advocate --topic "Database choice: PostgreSQL vs MongoDB" --max_turns 12
  
  # With additional context
  claude devils-advocate --topic "Authentication approach" --user_context "We have 3 teams, expecting 100k users"
  ```
  
  ### Automated Conversations
  ```bash
  # Run without pausing between turns
  claude devils-advocate --topic "Code review strategy" --auto_continue
  
  # Quick synthesis without moderator
  claude devils-advocate --topic "Testing approach" --max_turns 6 --include_moderator false
  ```
  
  ## Common Use Cases
  
  ### Architecture Decisions
  ```bash
  claude devils-advocate --topic "Should we adopt event-driven architecture?"
  claude devils-advocate --topic "Monorepo vs polyrepo strategy"
  claude devils-advocate --topic "Serverless vs container deployment"
  ```
  
  ### Technology Choices
  ```bash
  claude devils-advocate --topic "React vs Vue for our frontend"
  claude devils-advocate --topic "gRPC vs REST for microservices"
  claude devils-advocate --topic "Self-hosted vs managed Kubernetes"
  ```
  
  ### Process and Strategy
  ```bash
  claude devils-advocate --topic "TDD vs test-after development"
  claude devils-advocate --topic "Sprint length: 1 week vs 2 weeks"
  claude devils-advocate --topic "Code ownership: collective vs individual"
  ```
  
  ### Problem-Solving
  ```bash
  claude devils-advocate --topic "How to reduce deployment time"
  claude devils-advocate --topic "Improving code review turnaround"
  claude devils-advocate --topic "Scaling team productivity"
  ```
  
  ## Conversation Flow
  
  ### Phase 1: Opening (Turns 1-2)
  - Proposer states position with supporting arguments
  - Challenger identifies assumptions and initial concerns
  
  ### Phase 2: Deep Exploration (Turns 3-8)
  - Back-and-forth debate diving deep into specific points
  - Proposer defends and refines position
  - Challenger stress-tests assumptions and proposes alternatives
  
  ### Phase 3: Synthesis (Final turns)
  - Moderator identifies consensus and remaining disagreements
  - Surfaces blind spots revealed through debate
  - Provides actionable recommendations
  
  ## Output
  
  Conversations are stored in `.claude/conversations/<session-id>/`:
  - `transcript.jsonl` - Complete conversation in structured format
  - `session-metadata.json` - Session information and status
  - `responses/` - Individual agent responses
  - `insights.md` - Generated summary and key takeaways
  - `checkpoints/` - Periodic state snapshots
  
  ## Tips for Effective Debates
  
  1. **Be Specific**: "Should we use microservices for the API backend?" is better than "Should we use microservices?"
  
  2. **Add Context**: Use `--user_context` to provide relevant information about team, scale, constraints
  
  3. **Right-Size Debates**: Simple questions need 6-8 turns, complex architectural decisions need 10-12
  
  4. **Review Transcript**: The full transcript often contains insights beyond the summary
  
  5. **Iterate**: Run multiple debates on related topics to explore different angles
  
  OTHERWISE, execute the Devil's Advocate conversation:
  
  You are orchestrating a multi-agent Devil's Advocate conversation. Your role is to:
  
  1. **Validate the Topic**: Ensure the topic is suitable for debate (has multiple perspectives)
  
  2. **Execute the Orchestrator**: Run the orchestrate-conversation.sh script with provided parameters
  
  3. **Monitor Progress**: Track the conversation as it progresses through phases
  
  4. **Handle Errors**: If agent invocation fails, provide helpful diagnostics
  
  5. **Present Results**: Display insights and provide access to full transcript
  
  ## Execution Steps
  
  1. Validate that the topic is suitable for debate
  2. Prepare the conversation environment
  3. Invoke the orchestrator script:
     ```bash
     .claude/scripts/orchestrate-conversation.sh \
       --topic "$topic" \
       --max-turns $max_turns \
       $(if $include_moderator; then echo "--include-moderator"; else echo "--no-moderator"; fi) \
       $(if [ -n "$user_context" ]; then echo "--user-context \"$user_context\""; fi) \
       $(if $auto_continue; then echo "--auto-continue"; fi)
     ```
  4. Display the conversation as it progresses
  5. Present the final insights summary
  6. Provide path to full transcript and session files
  
  ## Implementation Notes
  
  The orchestrator script manages:
  - Turn-taking between agents
  - Context building from conversation history
  - Agent invocation via invoke-agent.sh
  - Transcript recording in JSONL format
  - Checkpointing for resumption
  - Termination condition checking
  
  Agents receive:
  - Full conversation history
  - Current phase and turn number
  - Their role-specific instructions
  - User-provided context
  
  ## Success Criteria
  
  A successful Devil's Advocate conversation:
  - ✅ Surfaces assumptions that weren't initially obvious
  - ✅ Explores multiple perspectives on the topic
  - ✅ Identifies trade-offs and costs
  - ✅ Proposes alternatives worth considering
  - ✅ Arrives at actionable insights or recommendations
  
  ## Troubleshooting
  
  **Agent invocation fails:**
  - Check that invoke-agent.sh has execute permissions
  - Verify agent definition files exist in .claude/agents/devils-advocate/
  - Review agent invocation logs in session directory
  
  **Conversation quality is low:**
  - Topic may be too broad - be more specific
  - Add relevant context via --user_context
  - Increase --max_turns for complex topics
  
  **Script not found:**
  - Ensure you're running from project root
  - Check that .claude/scripts/ directory exists
  - Verify scripts have execute permissions (chmod +x)
  
  ---
  
  **Ready to start a Devil's Advocate conversation? Provide your topic and let the agents debate!**
