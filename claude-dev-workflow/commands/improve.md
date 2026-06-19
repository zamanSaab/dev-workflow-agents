---
description: Root-cause an escaped issue and harden the responsible agent/command so it can't recur (with approval before editing).
argument-hint: [describe what was missed and where it was finally caught]
---

Improve the workflow after an issue escaped review/QA.

What escaped and where it was caught (describe it):
<incident>
$ARGUMENTS
</incident>

If `<incident>` is empty, ask the user what was missed and at which stage it was caught, then stop.

Steps:
1. **Use the `process-improver` subagent**, giving it the incident plus access to the agent
   and command files under `.claude/agents/` and `.claude/commands/`.
2. Present the "Process Improvement Report" verbatim, including the exact proposed edits
   (current text → proposed text) for the responsible agent/command file.
3. Stop and ask the user to approve the proposed instruction changes. Do NOT edit any
   `.claude/` file until they approve.
4. After approval, apply the approved edits to the relevant agent/command file(s) yourself,
   then show a short diff of what changed.
5. Remind the user that subagent file edits take effect on the next session (or immediately if
   created/edited via `/agents`).
6. Keep edits minimal and placed in the right agent — fix the process, not just the one bug.
