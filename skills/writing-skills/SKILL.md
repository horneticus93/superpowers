---
name: writing-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment
---

# Writing Skills

## Overview

Write the skill first, then validate its structure and behavior. Skills are executable process guidance: concise wording, accurate triggers, and realistic forward-testing matter more than explanatory volume.

**Core principle:** Draft the intended workflow from real requirements, then test the completed draft against realistic tasks and revise from evidence.

For code changes to skill tooling, also use `superpowers:code-first-verification`.

## What Is a Skill?

A skill is a reusable reference for a technique, pattern, tool, or workflow.

Skills are:

- Reusable across tasks
- Focused on a recognizable goal or situation
- Written for another capable agent
- Backed by examples, references, or scripts only when those resources add real value

Skills are not:

- A narrative about one past session
- Project-specific policy that belongs in `AGENTS.md`
- A substitute for deterministic validation that a script can enforce
- A collection of loosely related advice

## Authoring Order

```
UNDERSTAND -> DRAFT -> STRUCTURAL VALIDATION -> FORWARD-TEST -> REVISE -> DEPLOY
```

Create or edit the skill before writing new evaluation scenarios for that change. After the draft exists, validate it with realistic tasks and revise as needed.

## 1. Understand the Goal

Before editing, identify:

- What user request or situation should trigger the skill?
- What outcome must the agent produce?
- Which decisions are fragile enough to need explicit guidance?
- What should remain flexible because context determines the best answer?
- Which existing skills overlap or should be referenced?

Read the existing skill completely when modifying one. Preserve deliberate voice, terminology, and workflow boundaries unless the requested change explicitly replaces them.

## 2. Plan the Contents

Choose only resources that the workflow genuinely needs:

```
skill-name/
├── SKILL.md
├── scripts/       # deterministic or repeatedly reused operations
├── references/    # detailed material loaded only when needed
└── assets/        # templates or files used in outputs
```

Keep principles, decisions, and short examples in `SKILL.md`. Move long reference material out of the main file. Prefer running a bundled script over restating a large deterministic procedure.

## 3. Write `SKILL.md`

### Frontmatter

Use only the required fields:

```yaml
---
name: descriptive-skill-name
description: Use when [specific triggering conditions and symptoms]
---
```

Rules:

- Use lower-case letters, digits, and hyphens in names.
- Keep names under 64 characters.
- Start descriptions with `Use when...`.
- Put trigger conditions in the description, not a workflow summary.
- Keep frontmatter concise so skill discovery remains cheap.

### Body

A useful skill body normally includes:

1. A one-paragraph overview and core principle
2. The ordered workflow or decision model
3. A compact example when the pattern is not obvious
4. Common mistakes or failure modes
5. A completion or verification checklist when omissions are costly

Use imperative language. State observable actions and outputs instead of motivational prose.

## Skill Discovery Optimization

The description answers only: **Should the agent load this skill now?**

Good:

```yaml
description: Use when tests have race conditions, timing dependencies, or inconsistent results
```

Bad:

```yaml
description: Use this workflow to poll conditions, inspect logs, and retry until stable
```

The bad version summarizes the workflow, encouraging agents to act from metadata without reading the body.

Use concrete keywords that agents will encounter: symptoms, error text, tools, formats, and domain terms. Keep technology-specific triggers only when the skill itself is technology-specific.

## Token Efficiency

Context is shared by the system prompt, conversation, tools, and every loaded skill.

Targets:

- Bootstrap and frequently loaded skills: under 200 words when practical
- Other skills: under 500 words when practical
- Any skill: under 500 lines; split details into references before reaching that size

Reduce cost by:

- Removing repeated explanations
- Keeping one strong example instead of several variants
- Referring to another skill instead of duplicating its workflow
- Sending command options to `--help`
- Keeping heavy schemas and references outside `SKILL.md`

## Match Guidance to the Problem

| Problem | Effective form |
|---------|----------------|
| Agent skips a required rule under pressure | Direct requirement plus specific warning signs |
| Agent produces the wrong output shape | Positive template or ordered output contract |
| Agent omits a recurring field | Required slot in the template it fills |
| Behavior depends on context | Conditional keyed to an observable fact |
| Operation is deterministic and fragile | Script or validator |

Avoid long prohibition lists when a positive recipe can define the correct output directly. Express real exceptions as explicit conditions rather than vague escape clauses.

## Cross-Referencing Skills

Reference skill names with an explicit relationship:

- `**REQUIRED SUB-SKILL:** Use superpowers:systematic-debugging`
- `**REQUIRED BACKGROUND:** Read superpowers:code-first-verification`

Do not use forced file-loading syntax or internal filesystem paths. The runtime resolves skill names and loads bodies only when needed.

## Flowcharts

Use a small flowchart only for a decision or loop that is genuinely easier to misunderstand in prose. Use tables for mappings, Markdown for linear steps, and code blocks for executable examples.

See `graphviz-conventions.dot` for diagram style. Render diagrams with:

```bash
./render-graphs.js ../some-skill
./render-graphs.js ../some-skill --combine
```

## Code Examples

One complete example is better than several partial examples.

A good example is:

- Runnable or directly adaptable
- Focused on the central decision
- Commented where the reason is not obvious
- Written in the most relevant language for the skill

Avoid fill-in-the-blank boilerplate and copies in multiple languages.

## Structural Validation

After the skill draft exists:

```bash
python3 skills/writing-skills/validate-skill.py skills/your-skill
```

Resolve both paths from the Superpowers checkout. The validator uses only the
Python standard library and works across supported harnesses.

Also check:

- Folder name matches the frontmatter name
- Referenced files exist
- No placeholder text remains
- Scripts execute successfully on representative inputs
- Frequently loaded content meets the intended word budget

## Forward-Testing

After structural validation, exercise the finished draft on realistic tasks. Read [validating-skills-with-subagents.md](validating-skills-with-subagents.md) for the full method.

Use fresh agents with minimal context. Give them the skill and a normal task, not your diagnosis or desired answer. Judge emitted artifacts, commands, diffs, and decisions against an explicit rubric.

When revising after a result:

1. Identify the smallest instruction gap that caused the behavior.
2. Edit the skill.
3. Re-run structural validation.
4. Re-run the relevant forward scenario.
5. Stop when the skill is clear and the scenarios consistently meet the rubric.

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Writing for a novice instead of a capable agent | Include only non-obvious procedural knowledge |
| Putting workflow details in the description | Keep the description trigger-only |
| Adding large reference sections inline | Move them to `references/` |
| Testing exact source wording | Test the consuming agent's behavior |
| Giving evaluators the expected answer | Provide the skill and realistic task only |
| Keeping a script without running it | Execute representative cases after implementation |
| Expanding the skill for every hypothetical edge case | Revise from observed failures and real requirements |

## Deployment Checklist

- [ ] Skill goal and trigger are explicit
- [ ] Name and frontmatter validate
- [ ] Body is concise and uses imperative language
- [ ] References, scripts, and assets are necessary and reachable
- [ ] Draft was forward-tested after implementation
- [ ] Findings were fixed and relevant scenarios re-run
- [ ] Repository and plugin validation pass
- [ ] Final diff contains no placeholders or unrelated changes
