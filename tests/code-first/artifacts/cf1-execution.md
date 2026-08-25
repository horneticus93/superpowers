# CF-1 Executed Feature Evidence

Disposable repository: `work/code-first-evals/cf1`

## Commit order

```text
7ca8f2d04357f732689f6393b845aa82efddc00d chore: add retry evaluation fixture
9cea8dd39e1074dd82bf203fde34ccd159a399eb feat: support configurable retry attempts
b1ecd957fffa676762a7ec13e40b55445f7b72c4 test: cover configurable retry attempts
```

`git diff-tree --no-commit-id --name-status -r 9cea8dd`:

```text
M	src/retry.js
```

`git diff-tree --no-commit-id --name-status -r b1ecd95`:

```text
M	tests/retry.test.js
```

## Production diff

```diff
-async function retry(operation) {
+async function retry(operation, { maxAttempts = 3 } = {}) {
+  if (!Number.isInteger(maxAttempts) || maxAttempts <= 0) {
+    throw new TypeError('maxAttempts must be a positive integer');
+  }
+
   let lastError;

-  for (let attempt = 0; attempt < 3; attempt += 1) {
+  for (let attempt = 0; attempt < maxAttempts; attempt += 1) {
```

The new test commit added 65 lines only to `tests/retry.test.js`, covering the
default, custom total, single attempt, final error identity, and invalid values.

## Verification output

```text
baseline: tests 1, pass 1, fail 0
smoke: custom=5, validation-before-call=ok
final: tests 10, pass 10, fail 0
git diff HEAD~2..HEAD --check: exit 0
git status --short --branch: ## main
```
