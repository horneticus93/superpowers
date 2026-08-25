# Code-First Forward-Evaluation Results

Date: 2026-08-25

Evaluator: fresh Codex subagents using the session-default model

Source: `feature/code-first-workflow` after the initial code-first implementation

| Scenario | Result | Recorded evidence |
|---|---|---|
| CF-1 Direct feature | PASS | Disposable repo: baseline `7ca8f2d`; production-only `9cea8dd`; test-only `b1ecd95`; final Node suite 10/10. |
| CF-2 Bug fix | PASS | Disposable repo: baseline `d762957`; production-only `35841c4`; test-only `803747d`; final Node suite 4/4. |
| CF-3 Generated plan | PASS | Production edit; no-file smoke check; test edit; focused and broader verification; commit. |
| CF-4 Subagent contract | PASS | Implementer contract required implementation and smoke-check before new or changed tests, followed by focused and broader evidence. |
| CF-5 Test-only task | PASS | Recognized the explicit exception, edited only `tests/retry.test.ts`, and refused to invent a production change. |

The evaluators received the target skill and scenario without the expected
answer. Full prompts and pass criteria are in
[`forward-eval-scenarios.md`](forward-eval-scenarios.md). Raw commit isolation,
diffs, reproduction output, and test summaries for the executed scenarios are
retained in [`artifacts/cf1-execution.md`](artifacts/cf1-execution.md) and
[`artifacts/cf2-execution.md`](artifacts/cf2-execution.md).
