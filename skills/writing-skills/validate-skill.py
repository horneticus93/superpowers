#!/usr/bin/env python3
"""Validate the portable structure of a Superpowers skill directory."""

from __future__ import annotations

import re
import sys
from pathlib import Path


NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
MARKDOWN_LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def parse_frontmatter(content: str) -> tuple[dict[str, str], str]:
    if not content.startswith("---\n"):
        fail("SKILL.md must start with YAML frontmatter")

    end = content.find("\n---\n", 4)
    if end < 0:
        fail("SKILL.md frontmatter is not closed")

    fields: dict[str, str] = {}
    for raw_line in content[4:end].splitlines():
        if not raw_line.strip() or raw_line.lstrip().startswith("#"):
            continue
        if ":" not in raw_line:
            fail(f"unsupported frontmatter line: {raw_line!r}")
        key, value = raw_line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"\'')

    return fields, content[end + 5 :]


def validate_links(skill_dir: Path, body: str) -> None:
    for target in MARKDOWN_LINK_RE.findall(body):
        target = target.strip().split("#", 1)[0]
        if not target or "://" in target or target.startswith(("#", "mailto:")):
            continue
        if not (skill_dir / target).resolve().exists():
            fail(f"missing linked file: {target}")


def main() -> None:
    if len(sys.argv) != 2:
        fail("usage: validate-skill.py PATH_TO_SKILL")

    skill_dir = Path(sys.argv[1]).expanduser().resolve()
    skill_file = skill_dir / "SKILL.md"
    if not skill_file.is_file():
        fail(f"missing {skill_file}")

    fields, body = parse_frontmatter(skill_file.read_text(encoding="utf-8"))
    name = fields.get("name", "")
    description = fields.get("description", "")

    if not NAME_RE.fullmatch(name):
        fail("name must use lowercase letters, numbers, and single hyphens")
    if name != skill_dir.name:
        fail(f"frontmatter name {name!r} does not match folder {skill_dir.name!r}")
    if not description:
        fail("description is required")
    if len(name) > 64:
        fail("name exceeds 64 characters")
    if len(description) > 1024:
        fail("description exceeds 1024 characters")
    if not body.strip():
        fail("skill body is empty")

    validate_links(skill_dir, body)
    print(f"valid skill: {skill_dir}")


if __name__ == "__main__":
    main()
