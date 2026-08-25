# Code-First Forward-Evaluation Results

Date: 2026-08-25

Evaluator: fresh Codex subagents using the session-default model

Source: `feature/code-first-workflow` after the initial code-first implementation

| Scenario | Result | Observed edit/action order |
|---|---|---|
| CF-1 Direct feature | PASS | Read and baseline existing tests; edit `src/retry.ts`; review and smoke-check; edit `tests/retry.test.ts`; run focused and broader gates. |
| CF-2 Bug fix | PASS | Reproduce and investigate; edit `src/retry.ts`; confirm symptom; add regression in `tests/retry.test.ts`; verify broadly. |
| CF-3 Generated plan | PASS | Production edit; no-file smoke check; test edit; focused and broader verification; commit. |
| CF-4 Subagent contract | PASS | Implementer contract required implementation and smoke-check before new or changed tests, followed by focused and broader evidence. |
| CF-5 Test-only task | PASS | Recognized the explicit exception, edited only `tests/retry.test.ts`, and refused to invent a production change. |

The evaluators received the target skill and scenario without the expected
answer. Full prompts and pass criteria are in
[`forward-eval-scenarios.md`](forward-eval-scenarios.md).
