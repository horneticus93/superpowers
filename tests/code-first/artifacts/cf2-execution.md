# CF-2 Executed Bug-Fix Evidence

Disposable repository: `work/code-first-evals/cf2`

## Commit order

```text
d7629575d3f49317d31d16b8040c0da67a169bc7 chore: add retry evaluation fixture
35841c4cdb0fdc06470deb8d566424598bc4c9c1 fix: honor retry maxAttempts option
803747dbd57016e0f92596aab738385d25caf4af test: cover custom retry attempt limits
```

`git diff-tree --no-commit-id --name-status -r 35841c4`:

```text
M	src/retry.js
```

`git diff-tree --no-commit-id --name-status -r 803747d`:

```text
M	tests/retry.test.js
```

## Reproduction and production diff

Before the fix:

```text
{"maxAttempts":1,"calls":3,"message":"temporary"}
{"maxAttempts":5,"calls":3,"message":"temporary"}
```

```diff
-  for (let attempt = 0; attempt < 3; attempt += 1) {
+  for (let attempt = 0; attempt < maxAttempts; attempt += 1) {
```

After the production-only commit, before editing tests:

```text
{"maxAttempts":1,"calls":1}
{"maxAttempts":5,"calls":5}
```

The subsequent test-only commit added 23 lines to `tests/retry.test.js` for
limits 1 and 5. Running those tests against the pre-fix module produced
`3 !== 1` and `3 !== 5`, then the final production passed them.

## Verification output

```text
focused: tests 3, pass 3, fail 0
final: tests 4, pass 4, fail 0
git status --short --branch: ## main
```
