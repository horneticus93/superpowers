#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FAILURES=0

pass() {
  echo "  [PASS] $1"
}

fail() {
  echo "  [FAIL] $1"
  FAILURES=$((FAILURES + 1))
}

assert_file() {
  local path="$1"
  local description="$2"
  if [[ -f "$REPO_ROOT/$path" ]]; then
    pass "$description"
  else
    fail "$description"
  fi
}

assert_absent() {
  local path="$1"
  local description="$2"
  if [[ ! -e "$REPO_ROOT/$path" ]]; then
    pass "$description"
  else
    fail "$description"
  fi
}

assert_order() {
  local path="$1"
  local earlier="$2"
  local later="$3"
  local description="$4"
  local earlier_line
  local later_line

  earlier_line="$(grep -nF "$earlier" "$REPO_ROOT/$path" | head -1 | cut -d: -f1 || true)"
  later_line="$(grep -nF "$later" "$REPO_ROOT/$path" | head -1 | cut -d: -f1 || true)"

  if [[ -n "$earlier_line" && -n "$later_line" && "$earlier_line" -lt "$later_line" ]]; then
    pass "$description"
  else
    fail "$description"
    echo "    earlier line: ${earlier_line:-missing}"
    echo "    later line:   ${later_line:-missing}"
  fi
}

legacy_acronym='t''dd'
legacy_skill='test''-driven-development'
legacy_order='test''-first'
legacy_cycle='red''[- /]?green'
forbidden="(^|[^[:alnum:]_])(${legacy_acronym}|${legacy_skill}|${legacy_order}|${legacy_cycle}|write[[:space:]]+(the[[:space:]]+)?tests?[[:space:]]+first|tests?[[:space:]]+before[[:space:]]+(implementation|code))([^[:alnum:]_]|$)"

echo "Code-first policy checks"

assert_file "skills/code-first-verification/SKILL.md" "code-first verification skill exists"
assert_file "skills/code-first-verification/writing-good-tests.md" "good-test reference moved with the new skill"
assert_file "skills/writing-skills/validating-skills-with-subagents.md" "post-implementation skill validation reference exists"
assert_absent "skills/$legacy_skill" "replaced implementation-order skill is absent"
assert_absent "skills/writing-skills/testing-skills-with-subagents.md" "replaced skill-authoring reference is absent"

assert_order \
  "skills/code-first-verification/SKILL.md" \
  "### 2. Implement Production Behavior" \
  "### 4. Write Focused Tests" \
  "implementation precedes test writing in the code-first skill"

assert_order \
  "skills/writing-plans/SKILL.md" \
  "**Step 1: Implement production behavior**" \
  "**Step 3: Write focused tests for the completed behavior**" \
  "implementation precedes test writing in plan templates"

assert_order \
  "skills/writing-skills/SKILL.md" \
  "## 3. Write" \
  "## Forward-Testing" \
  "skill drafting precedes behavioral evaluation"

metadata_files=(
  ".claude-plugin/marketplace.json"
  ".claude-plugin/plugin.json"
  ".codex-plugin/plugin.json"
  ".cursor-plugin/plugin.json"
  ".devin-plugin/plugin.json"
  ".kimi-plugin/plugin.json"
  "gemini-extension.json"
  "package.json"
)

for path in "${metadata_files[@]}"; do
  if grep -qiF "code-first" "$REPO_ROOT/$path"; then
    pass "$path identifies the code-first workflow"
  else
    fail "$path identifies the code-first workflow"
  fi
done

fork_install_files=(
  "README.md"
  ".opencode/INSTALL.md"
  "docs/README.opencode.md"
  "docs/README.kimi.md"
  ".hermes-plugin/__init__.py"
)

for path in "${fork_install_files[@]}"; do
  if grep -qF "horneticus93/superpowers" "$REPO_ROOT/$path"; then
    pass "$path installs or links to the code-first fork"
  else
    fail "$path installs or links to the code-first fork"
  fi

  if grep -qF "obra/superpowers" "$REPO_ROOT/$path"; then
    fail "$path does not route users to upstream Superpowers"
  else
    pass "$path does not route users to upstream Superpowers"
  fi
done

assert_file \
  "tests/code-first/forward-eval-scenarios.md" \
  "code-first behavioral forward-evaluation scenarios exist"
assert_file \
  "tests/code-first/forward-eval-results.md" \
  "code-first behavioral forward-evaluation results are recorded"
assert_file \
  "tests/code-first/artifacts/cf1-execution.md" \
  "direct-feature execution evidence is retained"
assert_file \
  "tests/code-first/artifacts/cf2-execution.md" \
  "bug-fix execution evidence is retained"

matches=""
while IFS= read -r -d '' path; do
  if file_matches="$(grep -IinE "$forbidden" "$REPO_ROOT/$path" 2>/dev/null || true)"; then
    if [[ -n "$file_matches" ]]; then
      matches+="$path:$file_matches"$'\n'
    fi
  fi
done < <(git -C "$REPO_ROOT" ls-files --cached --others --exclude-standard -z)

if [[ -z "$matches" ]]; then
  pass "repository contains no replaced methodology names or ordering directives"
else
  fail "repository contains no replaced methodology names or ordering directives"
  printf '%s' "$matches" | sed 's/^/    /'
fi

if [[ "$FAILURES" -gt 0 ]]; then
  echo ""
  echo "Results: $FAILURES failure(s)"
  exit 1
fi

echo ""
echo "Results: all code-first policy checks passed"
