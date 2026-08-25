#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATOR="$REPO_ROOT/skills/writing-skills/validate-skill.py"
FIXTURE_ROOT="$(mktemp -d)"
trap 'rm -rf "$FIXTURE_ROOT"' EXIT

pass() {
  echo "  [PASS] $1"
}

fail() {
  echo "  [FAIL] $1"
  exit 1
}

mkdir -p "$FIXTURE_ROOT/example-skill"
cat >"$FIXTURE_ROOT/example-skill/SKILL.md" <<'EOF'
---
name: example-skill
description: Use when validating a portable example skill
---

# Example Skill

Read [reference.md](reference.md).
EOF
printf 'reference\n' >"$FIXTURE_ROOT/example-skill/reference.md"

if python3 "$VALIDATOR" "$FIXTURE_ROOT/example-skill" >/dev/null; then
  pass "accepts a valid skill with a reachable relative reference"
else
  fail "accepts a valid skill with a reachable relative reference"
fi

mkdir -p "$FIXTURE_ROOT/wrong-folder"
cat >"$FIXTURE_ROOT/wrong-folder/SKILL.md" <<'EOF'
---
name: different-name
description: Use when checking a folder mismatch
---

# Wrong Folder
EOF

if python3 "$VALIDATOR" "$FIXTURE_ROOT/wrong-folder" >/dev/null 2>&1; then
  fail "rejects a frontmatter and folder-name mismatch"
else
  pass "rejects a frontmatter and folder-name mismatch"
fi

mkdir -p "$FIXTURE_ROOT/missing-reference"
cat >"$FIXTURE_ROOT/missing-reference/SKILL.md" <<'EOF'
---
name: missing-reference
description: Use when checking a missing relative reference
---

# Missing Reference

Read [missing.md](missing.md).
EOF

if python3 "$VALIDATOR" "$FIXTURE_ROOT/missing-reference" >/dev/null 2>&1; then
  fail "rejects a missing relative reference"
else
  pass "rejects a missing relative reference"
fi

echo "All writing-skills validator tests passed"
