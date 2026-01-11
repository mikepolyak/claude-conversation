# Quick Start Guide

Get started with Devil's Advocate conversations in 5 minutes.

## Prerequisites

```bash
# Install jq if not already installed
brew install jq  # macOS
# or
apt install jq   # Linux
```

## Test the System

Run a simple test conversation:

```bash
.claude/scripts/orchestrate-conversation.sh \
  --topic "Should we write tests before or after code?" \
  --max-turns 6 \
  --auto-continue
```

This will:
1. Create a new conversation session
2. Run 6 turns alternating between Proposer and Challenger
3. Display each turn's response
4. Generate an insights summary

## View Results

```bash
# Find your session ID (timestamp-based)
ls -l .claude/conversations/

# View the insights
cat .claude/conversations/<session-id>/insights.md

# View the full transcript
cat .claude/conversations/<session-id>/transcript.jsonl | jq
```

## Your First Real Conversation

```bash
.claude/scripts/orchestrate-conversation.sh \
  --topic "Your actual technical decision" \
  --user-context "Your team context, constraints, goals" \
  --max-turns 10
```

Press Enter between turns to review each agent's response.

## What to Expect

**Currently**: The system runs with placeholder agent responses (see `invoke-agent.sh`).

**To make it fully functional**: Edit `.claude/scripts/invoke-agent.sh` to integrate with:
- Claude API (via curl)
- Claude CLI tool
- MCP integration
- Or manually copy agent context between sessions

## Next Steps

1. **Review the example**: Read `examples/example-conversation.md` for a complete sample
2. **Customize agents**: Edit agent definitions in `.claude/agents/devils-advocate/`
3. **Integrate API**: Update `invoke-agent.sh` with your preferred Claude invocation method
4. **Run real debates**: Use for actual technical decisions your team faces

## Tips

- Start with 6-8 turns for simple topics
- Add `--user-context` for better results
- Use `--auto-continue` to skip pauses between turns
- Review full transcript (not just insights) for nuanced arguments

---

**Ready to stress-test your next big idea? Let the agents debate it out! 🎭**
