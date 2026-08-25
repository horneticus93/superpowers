# Code-First Fork: Rationale and Contract

## Status

This repository is a methodology fork of
[`obra/superpowers`](https://github.com/obra/superpowers), based initially on
Superpowers v6.3.0. It preserves the upstream skills framework, multi-harness
packaging, brainstorming, planning, debugging, worktree, subagent, review, and
verification capabilities.

Its primary divergence is intentional and non-negotiable: **production code is
written before new or changed automated tests**.

## Why the fork exists

This fork adopts the engineering premise that modern flagship coding models can
produce strong first-pass production code when they receive clear requirements,
relevant repository context, and a reviewed implementation plan. Under that
premise, requiring every implementation to begin by authoring a deliberately
failing test can duplicate reasoning and tool work without proportionate value.

A mandatory TDD loop commonly requires the agent to:

1. Translate the requirement into test code.
2. Run the test and capture the expected failure.
3. Re-read that failure and translate the same requirement into production code.
4. Run the focused test again.
5. Repeat the phase evidence in subagent reports and reviews.

Those steps consume generated tokens, tool-call tokens, context capacity, test
runtime, and reviewer attention. They can be especially expensive in multi-agent
workflows, where each phase is summarized and re-consumed by another model.

This fork is designed to remove that duplicated ceremony. It uses the approved
requirements as the implementation contract, then uses tests to document and
protect the completed behavior. Mandatory TDD is therefore treated here as an
outdated default for modern flagship-model agent work, rather than a universal
requirement.

This is not a claim that tests are obsolete. Tests remain a required delivery
gate. The fork changes when they are written, not whether verification happens.

## Primary difference from upstream

| Area | Upstream Superpowers | This fork |
|---|---|---|
| Default methodology | Test-driven development (TDD) | Code-first verification |
| First authored change | Deliberately failing automated test | Scoped production implementation |
| Early feedback | Expected test failure | Diff review and executable smoke check |
| Test authorship | Before production code | After production behavior exists |
| Bug-fix order | Regression test before fix | Reproduce, investigate, fix, confirm, then add regression test |
| Skill authoring | Evaluation scenario before skill draft | Draft skill, validate structure, then forward-test behavior |
| Completion evidence | Failure-to-pass cycle plus suite | Implementation order, smoke evidence, focused tests, and broader gates |
| Optimization target | Specification through tests | Lower agent-token and tool-call overhead while retaining verification |

## Required workflow

For a feature, bug fix, refactor, or behavior change:

```text
UNDERSTAND -> IMPLEMENT -> REVIEW -> WRITE TESTS -> VERIFY -> FINISH
```

1. Read requirements, production code, and relevant existing tests.
2. Run existing tests when useful as a baseline. Reading or running existing
   tests does not violate the code-first rule.
3. Implement the scoped production behavior.
4. Review the diff and perform a focused smoke check.
5. Write or update automated tests for the completed behavior.
6. Run focused tests, then broader build, lint, type, formatting, and test gates.
7. Report exact verification commands and results.

The authoritative agent instruction is
[`skills/code-first-verification/SKILL.md`](../skills/code-first-verification/SKILL.md).

## Exceptions

An explicit test-only task may change tests without changing production code.
The agent must not invent a production modification merely to satisfy the usual
ordering rule.

Existing tests may always be read and executed before implementation to
understand current behavior or establish a baseline. The restriction applies to
authoring new or changed tests for the production change.

## Token-efficiency claim

The project goal is to reduce token and tool-call consumption by removing the
mandatory pre-implementation failure cycle and its repeated narration across
agents. The expected savings come from fewer generated artifacts, fewer test
runs during initial authorship, less duplicated context, and shorter phase
reports.

Savings are workload-dependent. This repository does not currently claim a
universal percentage or guarantee that every task will be cheaper. Complex,
ambiguous, or safety-critical work can still require substantial investigation,
additional tests, mutation checks, and review. Behavioral evals in
[`tests/code-first/`](../tests/code-first/) verify workflow ordering; they do not
yet constitute a cross-model token benchmark.

## Safety model retained from Superpowers

Code-first does not mean unreviewed or untested. The fork retains:

- requirements clarification and design approval;
- repository-grounded implementation plans;
- systematic root-cause debugging;
- isolated worktrees and scoped commits;
- implementation and code-quality review;
- focused automated coverage after implementation;
- broader build, lint, type, formatting, and test gates;
- verification evidence before completion claims.

## Upstream synchronization policy

Upstream changes are reviewed selectively. Harness compatibility, bug fixes,
security improvements, and methodology-neutral skill improvements may be
ported. Changes that restore TDD ordering, renamed TDD skills, pre-implementation
test requirements, or conflicting prompts must be adapted to the code-first
contract before merging.

Do not merge upstream blindly. After every upstream sync, run:

```bash
bash tests/code-first/test-code-first-policy.sh
bash tests/code-first/test-writing-skills-validator.sh
```

Then run the relevant plugin suites and the forward-evaluation scenarios in
[`tests/code-first/forward-eval-scenarios.md`](../tests/code-first/forward-eval-scenarios.md).

## Attribution

The underlying Superpowers framework was created by Jesse Vincent and the Prime
Radiant contributors. This fork preserves that attribution while maintaining a
different development methodology and distribution source.
