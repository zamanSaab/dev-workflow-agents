---
description: Triage human PR reviewer comments, plan the fixes (with approval), apply them, and re-run review/QA.
argument-hint: [paste the human reviewer's PR comments here]
---

Handle feedback from a human pull-request reviewer.

Human reviewer comments:
<comments>
$ARGUMENTS
</comments>

If `<comments>` is empty, ask the user to paste the reviewer comments and stop.

Steps:
1. **Use the `pr-feedback-handler` subagent**, giving it the comments plus the original
   requirement, enhanced requirement, acceptance criteria, approved plan, code-review result,
   and QA result (from this conversation, or ask the user for what's missing).
2. Present the "PR Feedback Plan" verbatim, including any conflicts that need the user's
   decision and any "escaped issues".
3. Stop and ask the user to approve the fix plan (and resolve any flagged conflicts). Do not
   change code until they approve.
4. After approval, apply the must-fix and should-fix changes yourself, maintaining the change
   log. Re-run self-review.
5. **Re-run the `code-reviewer`** (code changed) and **re-run the `qa-engineer`** if behavior
   changed. Update the PR details if needed.
6. If the handler flagged escaped issues (something the human caught that AI review/QA should
   have), tell the user and offer to run `/improve` to harden the responsible agent.
7. Never ignore a reviewer comment; if one was intentionally not actioned, say why.
