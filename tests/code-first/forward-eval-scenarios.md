# Code-First Forward-Evaluation Scenarios

Run these scenarios with fresh agents after changing any implementation-order
skill or prompt. Give the agent only the named skill and the scenario. Judge the
ordered actions or resulting diff; do not award credit for merely repeating the
phrase "code first."

## CF-1: Direct feature implementation

**Skill:** `code-first-verification`

**Prompt:** In a disposable Git fixture, add an optional `maxAttempts` setting
to a retry service with `src/retry.js` and `tests/retry.test.js`. Execute the
change and make a checkpoint commit after each file-edit phase without combining
production and test files in one commit or rewriting history.

**Pass:** The Git history contains a production-only commit before a test-only
commit. Tool output shows the baseline, a post-implementation smoke check,
focused tests, broader verification, and a clean final worktree.

## CF-2: Bug fix and regression protection

**Skill:** `code-first-verification`

**Prompt:** In a disposable Git fixture, fix a bug where `maxAttempts` is
ignored and existing tests do not cover the setting. Execute the change with a
checkpoint commit after each file-edit phase, without combining production and
test files in one commit or rewriting history.

**Pass:** Reproduction output identifies the ignored option. The Git history
then contains a production-only fix commit before a test-only regression commit,
followed by focused and broad passing output and a clean worktree.

## CF-3: Generated implementation plan

**Skill:** `writing-plans`

**Prompt:** Produce a concise file-by-file implementation plan for adding
`maxAttempts` to `src/retry.ts`, with coverage in `tests/retry.test.ts`.

**Pass:** The plan orders the production edit, review/smoke check, test edit,
focused verification, broader gates, and commit. Baseline test execution may
appear before implementation; creation or modification of tests may not.

## CF-4: Subagent execution contract

**Skill:** `subagent-driven-development`

**Prompt:** Show the implementer dispatch and required completion evidence for
a task that adds `maxAttempts` to the retry service.

**Pass:** The implementer contract requires production implementation and
smoke-check before new or changed tests. The report asks for implementation
order, smoke evidence, focused test output, broader verification, and changed
files; it does not ask for a pre-implementation failing test.

## CF-5: Explicit test-only task

**Skill:** `code-first-verification`

**Prompt:** Production behavior is correct and must not change. Add missing
coverage for the existing `maxAttempts` contract.

**Pass:** The agent recognizes the test-only exception, edits only the test
file, and does not invent a production change to satisfy the usual ordering.

## Recording results

For each run, record the model, date, scenario ID, emitted file-edit order,
commands, and pass/fail decision. Re-run CF-1 through CF-5 whenever the central
ordering skill, plan template, debugging flow, or subagent prompts change.
