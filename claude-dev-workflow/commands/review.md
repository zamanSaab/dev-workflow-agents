---
description: Run a strict code review on the current changes (or a provided diff) and handle the fix loop with approval.
argument-hint: [optional: base branch, file, or paste of the diff/requirement context]
---

Run a strict code review of the current change set.

Context provided by the user (optional — may be empty):
<context>
$ARGUMENTS
</context>

Steps:
1. Gather the diff yourself first (`git status`, then `git diff` / `git diff HEAD` /
   `git diff <base>...<branch>`). If `<context>` names a base branch or file, use it.
2. **Use the `code-reviewer` subagent**, giving it the diff and whatever requirement/plan
   context is available (from `<context>` or from this conversation). If the requirement and
   acceptance criteria aren't available, ask the user for them or review against general
   correctness/quality/security/performance and say so.
3. Present the subagent's "Code Review Result" verbatim.
4. If status is "Changes Required": propose a fix plan, stop and ask the user to approve it,
   then apply the fixes, and **re-run the `code-reviewer`**. Repeat until "Approved".
5. Do not claim the review passed unless the subagent returned "Approved".
