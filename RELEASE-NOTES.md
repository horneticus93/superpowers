# Superpowers Code-First Fork Notes

This fork tracks the Superpowers skills framework while using a code-first development methodology designed to reduce token and tool-call overhead in modern flagship-model agent workflows.

The complete motivation, upstream comparison, workflow contract, and claim
limits are documented in
[`docs/CODE-FIRST-FORK.md`](docs/CODE-FIRST-FORK.md).

For the complete release history before this fork diverged, see the [upstream repository](https://github.com/obra/superpowers/releases).

## Code-First Workflow (2026-08-25)

Base: Superpowers v6.3.0.

### Development methodology

- Documented why mandatory TDD is no longer the default in this fork: modern flagship models can implement reviewed requirements directly, avoiding duplicated failing-test authorship and repeated agent narration.
- Added `code-first-verification`: implement production behavior, review and smoke-check it, then write focused automated tests and run broader verification.
- Reordered implementation plans so production changes precede new or modified tests.
- Updated bug-fix guidance to investigate root cause, implement the fix, confirm the symptom, and add regression protection afterward.
- Updated implementer and reviewer contracts to report implementation order, smoke evidence, and focused and broader verification results.

### Skill authoring

- Reworked `writing-skills` around draft, structural validation, post-implementation forward-testing, revision, and deployment.
- Added `validating-skills-with-subagents.md` for clean-context behavioral evaluation after a skill draft exists.
- Preserved falsifiable, behavior-focused test design guidance in `code-first-verification/writing-good-tests.md`.

### Distribution and documentation

- Updated plugin metadata and installation sources for `horneticus93/superpowers` while preserving the `superpowers` plugin name and skill namespace.
- Removed obsolete historical implementation artifacts that prescribed the replaced development order.
- Added repository checks that reject reintroduction of the replaced skill, references, metadata, or implementation-order language.
