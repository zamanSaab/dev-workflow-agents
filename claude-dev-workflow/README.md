# Gated Multi-Agent Development Workflow (for Claude Code)

A faithful Claude Code implementation of your 14-step development workflow: requirement
refinement → planning → implementation → strict code review → QA → human PR feedback →
process improvement → final PR details, with a **human approval gate** at every critical step.

## How it maps to your document

| Your concept | Implemented as | File |
|---|---|---|
| Orchestrator (Steps 1–14) | Slash command (runs in main thread, owns all gates) | `commands/workflow.md` |
| Requirement Enhancer Skill | Subagent | `agents/requirement-enhancer.md` |
| Planning Agent | Subagent | `agents/planner.md` |
| Advisor Agent | Subagent | `agents/advisor.md` |
| Implementation Agent | **The main session itself** (so you can watch + intervene) | `commands/workflow.md` (Phase 3) |
| Strict Code Review Agent | Subagent | `agents/code-reviewer.md` |
| QA Agent | Subagent | `agents/qa-engineer.md` |
| Human PR Feedback Handler | Subagent + command | `agents/pr-feedback-handler.md`, `commands/pr-feedback.md` |
| Agent/Skill Improvement Agent | Subagent + command | `agents/process-improver.md`, `commands/improve.md` |
| Final PR Assistant | Folded into the orchestrator (Phase 8) | `commands/workflow.md` |

### The one important design decision
A Claude Code **subagent runs in an isolated context and returns only a result — it cannot
stop to ask you for approval.** So everything that needs your sign-off (the approval gates)
and the actual code-writing stay in the **main session**, which acts as the orchestrator and
delegates the heavy *analysis* (enhance / plan / advise / review / QA) to subagents. This keeps
all of your human-in-the-loop gates intact instead of silently bypassing them.

## What's in the box
```
CLAUDE.md            # always-on rules + entry points (project root)
agents/              # 7 specialist subagents  -> install to .claude/agents/
commands/            # 5 slash commands        -> install to .claude/commands/
install.sh           # copies everything into the right place
```

## Install

### Option A — script (recommended)
```bash
# from inside this unzipped folder
chmod +x install.sh

# into a specific repo:
./install.sh /Users/zaman.chaudhary/ulmo-edly-saas

# or into the repo you're currently in:
./install.sh

# or globally for every project (agents + commands only):
./install.sh --user
```

### Option B — manual
From inside this folder, with `REPO` set to your project path:
```bash
REPO=/Users/zaman.chaudhary/ulmo-edly-saas
mkdir -p "$REPO/.claude/agents" "$REPO/.claude/commands"
cp agents/*.md   "$REPO/.claude/agents/"
cp commands/*.md "$REPO/.claude/commands/"
cp CLAUDE.md     "$REPO/CLAUDE.md"   # skip if you already have one; merge instead
```

### After installing — IMPORTANT
Subagents are loaded when a session starts. **Restart Claude Code** (or run `/agents`) so the
seven new agents are picked up. Then run `/agents` to confirm they're listed.

> Project scope (`.claude/` in the repo) is shared with your team via git. User scope
> (`~/.claude/`) is personal and applies to every project. Project wins on name collision.

## Use it

```text
/workflow EDLY-1234  Course discovery: marketing_id is not saved when a Person is created via the admin
```
The orchestrator then walks every phase and **stops at each gate** until you reply "approved":

1. Analyzes the ticket → runs `requirement-enhancer` **only if the requirement needs it**
   (if it's already clear and complete it's skipped; if it's borderline you're asked first)
   → **GATE: approve the requirement baseline**
2. Runs `planner` (and `advisor` if the task is risky) → **GATE: approve plan**
3. Implements the change in the main session (with a live change log)
4. Self-reviews
5. Runs `code-reviewer` → if "Changes Required" → **GATE: approve fix plan** → fix → re-review (loops until Approved)
6. Runs `qa-engineer` → if "Fail" → **GATE: approve fix plan** → fix → re-QA (loops until Pass)
7. Final verification, then prints branch name, PR title, PR description, and PR checklist

After you open the PR and a human leaves comments:
```text
/pr-feedback <paste the reviewer's comments>
```
It triages each comment, plans the fixes (**gate**), applies them, and re-runs review/QA.
If the human caught something the AI gates should have caught:
```text
/improve The reviewer found an N+1 query the code-reviewer missed; caught at human PR review
```
It root-causes the miss and proposes exact edits to the responsible agent file (**gate** before
editing), so the same class of issue is caught next time.

You can also run the gates standalone any time: `/review`, `/qa`.

## Customize

- **Models per agent.** Each agent's frontmatter has `model: opus | sonnet | haiku | inherit`.
  Defaults: `advisor`, `code-reviewer`, and `process-improver` use `opus` (judgment-heavy);
  the rest use `sonnet`. Set any of them to `inherit` to follow your main session's model, or
  pin a full model id. To force one model for all subagents in a session, set
  `CLAUDE_CODE_SUBAGENT_MODEL`.
- **Tools per agent.** The `tools:` line scopes each agent. Reviewers/QA have `Bash` so they
  can run `git diff`, tests, and linters; planning/advisor agents are read-only. Tighten or
  widen as you like.
- **Reuse your existing `code-review` skill.** If you keep a `code-review` skill in
  `.claude/skills/`, you can wire it into the reviewer by adding a `skills: [code-review]`
  line to `agents/code-reviewer.md` (supported in recent Claude Code). The agent is also
  self-contained, so this is optional.
- **Tune the strictness/gates.** All gate wording and rules live in `commands/workflow.md`
  and `CLAUDE.md` — edit them to make the process lighter or heavier.

## Notes & limits
- Edits to agent **files** need a session restart (or use `/agents`) to take effect; agents
  created/edited via `/agents` apply immediately.
- This targets **Claude Code**. If you want the same flow in a different tool, the agent prompt
  bodies are portable — only the frontmatter and the slash-command wrapper are Claude-Code-specific.
