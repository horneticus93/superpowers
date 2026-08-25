---
name: code-first-verification
description: Use when implementing any feature, bugfix, refactor, or behavior change that needs automated verification
---

# Code-First Verification

## Overview

Implement the requested production behavior first. Add or update automated tests after the implementation exists, then use those tests to verify and protect the completed behavior.

**Core principle:** Requirements define the implementation. Tests document and protect what was built.

## The Order

```
UNDERSTAND -> IMPLEMENT -> REVIEW -> WRITE TESTS -> VERIFY -> FINISH
```

For a task that changes production code, do not create or modify its tests until the production change exists.

This rule controls authorship order, not investigation:

- Read existing tests whenever they help explain current behavior.
- Run the existing suite before implementation to establish a clean baseline.
- Reproduce a bug with logs, a manual scenario, or an existing command before fixing it.
- Write new or changed automated tests only after the production change.

An explicit test-only task is different: when the requested deliverable is solely missing test coverage and production code must remain unchanged, write the tests without inventing a production change.

## Workflow

### 1. Understand the Contract

Before editing:

- Read the requirements, relevant production code, and existing tests.
- Identify the observable behavior, edge cases, and error paths.
- Run an appropriate baseline check when one exists.
- Resolve ambiguity with your human partner instead of encoding guesses.

### 2. Implement Production Behavior

Write the complete, scoped production change:

- Follow existing architecture and naming.
- Implement only requested behavior.
- Keep boundaries small and responsibilities clear.
- Avoid test-only methods or production hooks created solely to make later tests easier.

Do not edit test files during this step.

### 3. Review and Smoke-Check

Inspect the implementation before writing tests:

- Re-read the requirements against the diff.
- Run a focused manual or executable smoke check when practical.
- Check error handling, boundary conditions, and unintended changes.
- Fix implementation issues discovered here.

### 4. Write Focused Tests

Now add or update tests for the completed behavior. Read [writing-good-tests.md](writing-good-tests.md) before writing or changing tests.

Tests should:

- Assert observable behavior and public contracts.
- Cover the main path plus meaningful errors and boundaries.
- Derive expected values independently from the production implementation.
- Exercise real code; use mocks only at genuinely slow or external boundaries.
- Avoid locking in private structure or incidental implementation details.

### 5. Run and Respond

Run the narrowest relevant tests first.

If a test fails:

1. Compare the failure with the requirement.
2. Fix production code when the implementation is wrong.
3. Fix the test only when its expectation is wrong or the requirement changed.
4. Re-run the focused test.

Do not weaken an expectation merely to make the suite pass.

### 6. Verify Broadly

After focused tests pass:

- Run the relevant broader suite once.
- Run required build, lint, type, or formatting gates.
- Confirm output is clean and no unrelated behavior regressed.
- Use `superpowers:verification-before-completion` before reporting success.

## Bug Fixes

For a bug:

1. Reproduce and investigate the symptom.
2. Identify the root cause with `superpowers:systematic-debugging`.
3. Implement the fix in production code.
4. Confirm the original symptom is gone.
5. Add a regression test after the fix.
6. Run focused and broader verification.

The regression test records the corrected contract; it does not gate writing the fix.

## Refactoring

For refactoring:

1. Run existing tests as a baseline.
2. Refactor production code without changing intended behavior.
3. Review the diff and smoke-check critical paths.
4. Add or update tests afterward only where the refactor exposed a real coverage gap.
5. Run the relevant suite.

Do not manufacture tests for trivial forwarding, private layout, or coverage numbers alone.

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Editing tests alongside the first implementation pass | Finish the production change, then write tests |
| Creating a test as a private implementation checklist | Use requirements and the production contract as the checklist |
| Changing production APIs only to simplify tests | Test the consumer-visible boundary or use a test utility |
| Treating a passing smoke check as complete verification | Add focused automated protection after implementation |
| Copying production logic into expected values | Use literals or hand-checked fixtures |
| Changing a test to match an unexpected result | Resolve the result against the requirement first |
| Running the full suite after every small edit | Run focused checks while iterating; run the broad suite once before completion |

## Completion Checklist

Before reporting completion:

- [ ] Production behavior was implemented before its new or changed tests
- [ ] The implementation matches the stated requirements
- [ ] The diff contains no unrelated changes
- [ ] Tests assert real behavior and meaningful edge cases
- [ ] Focused tests pass with clean output
- [ ] Required broader verification passes
- [ ] Exact commands and results are reported

## Final Rule

```
Production change first -> tests afterward -> fresh verification evidence
```
