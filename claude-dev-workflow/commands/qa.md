---
description: Run strict end-to-end QA on the current changes and handle the fix loop with approval.
argument-hint: [optional: requirement/acceptance-criteria context or how to run the app/tests]
---

Run strict, end-to-end QA on the current change set.

Context provided by the user (optional — may be empty):
<context>
$ARGUMENTS
</context>

Steps:
1. Gather the change set and any test/build commands. Inspect with git and the file tools.
2. **Use the `qa-engineer` subagent**, giving it the requirement, acceptance criteria, plan,
   final changes, and the latest code-review result if available (from `<context>` or this
   conversation). If acceptance criteria aren't available, ask for them or QA against the
   stated expected behavior and say which you did.
3. Present the subagent's "QA Result" verbatim.
4. If status is "Fail": propose a QA fix plan, stop and ask the user to approve it, apply the
   fixes, re-run the `code-reviewer` if code changed, then **re-run the `qa-engineer`**.
   Repeat until "Pass".
5. Do not claim QA passed unless the subagent returned "Pass".
