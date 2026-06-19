# Development workflow

This repository uses a strict, gated, multi-agent development workflow. For any **feature,
bug fix, or change request**, drive the work through the `/workflow` command rather than coding
ad hoc. For quick questions or one-off lookups, just answer normally.

## Entry points
- `/workflow <ticket or requirement>` — full gated flow: requirement → plan → implement →
  strict code review → QA → final PR details, with a human approval gate at each step.
- `/review [base/diff]` — strict code review of the current changes + fix loop.
- `/qa [context]` — strict end-to-end QA of the current changes + fix loop.
- `/pr-feedback <pasted reviewer comments>` — triage human PR comments, plan, fix, re-verify.
- `/improve <what was missed>` — root-cause an escaped issue and harden the responsible agent.

## Specialist subagents (in `.claude/agents/`)
requirement-enhancer · planner · advisor · code-reviewer · qa-engineer · pr-feedback-handler ·
process-improver. The main session orchestrates; subagents do isolated analysis and report back.
Approval gates and the actual coding always stay in the main session.

## Non-negotiable behavior rules
- Never skip a gate and never fake an approval — wait for explicit user approval at each gate.
- Do not mark a task complete until the requirement is approved, the plan is approved,
  implementation is done, self-review is done, strict code review has PASSED, QA has PASSED,
  and any human PR comments are resolved.
- Be strict, professional, and honest. Don't over-engineer simple tasks or under-engineer
  complex ones. Don't silently assume important details — surface them as questions or
  labelled assumptions.
- Code review and QA must be requirement-focused and must not rubber-stamp weak, partial, or
  risky work. If a human reviewer catches something the AI gates missed, treat it as a process
  failure and run `/improve`.
- Completion means the requirement is actually fulfilled — not merely that code was written.
