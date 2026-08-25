# Validating Skills with Subagents

Use this reference after a skill has been created or changed. It describes post-implementation evaluation of agent behavior.

## Purpose

Source inspection can catch ambiguity, but only realistic use shows whether another agent discovers and follows the workflow. Forward-testing provides that evidence without exposing the evaluator to the author's conclusions.

## Order

1. Finish the skill draft.
2. Run structural validation.
3. Create scenarios that exercise the completed workflow.
4. Run scenarios with fresh agents.
5. Score observable behavior and artifacts.
6. Revise the skill, then re-run the affected scenarios.

Do not delay the skill draft until an evaluator fails. The skill requirements and intended workflow drive the implementation; evaluation checks the finished guidance afterward.

## Scenario Types

### Discipline Skills

Use pressure that tempts the agent to skip a known requirement:

- Tight deadline
- Existing sunk cost
- Authority requesting a shortcut
- Fatigue or long context
- Several pressures combined

Score the actual decision, not whether the agent can repeat the rule academically.

### Technique Skills

Use a realistic problem that requires applying the technique:

- Normal case
- Meaningful edge case
- Missing or ambiguous input
- A superficially attractive wrong approach

Score whether the resulting commands, code, or explanation apply the technique correctly.

### Pattern Skills

Include:

- A case where the pattern applies
- A case where it does not
- A case with competing trade-offs

Score recognition and judgment, not keyword repetition.

### Reference Skills

Ask the agent to retrieve and apply details from the skill:

- Common operation
- Less obvious option
- Boundary or error case

Score factual retrieval and correct application.

## Clean Dispatch

Give each evaluator:

- The skill path or explicit skill name
- A realistic user request
- Only task-local files and context
- Permission boundaries needed for the task

Do not provide:

- The intended answer
- Your suspected wording flaw
- Prior evaluator findings
- A summary of what the skill is supposed to force

Example:

```text
Use the skill at /path/to/skill to handle this request:
[realistic request]
```

## Rubric

Define observable criteria before scoring the output:

| Dimension | Evidence |
|-----------|----------|
| Triggering | Agent loads the skill in the intended situation |
| Ordering | Actions occur in the required sequence |
| Completeness | Required outputs or gates are present |
| Judgment | Exceptions and edge cases are handled correctly |
| Efficiency | No duplicated work or unnecessary context loading |
| Honesty | Unverified results are not presented as confirmed |

Prefer raw artifacts: diffs, command logs, reports, generated files, and final responses. Do not score from an agent's self-assessment alone.

## Comparison Runs

When useful, compare the completed revision with the prior released version. Run both after the new draft exists, using fresh contexts and the same task, model, effort, and environment.

Use multiple repetitions for behavior that varies between runs. Read every output; automated keyword counts can mistake quoted guidance for compliance.

Track:

- Pass rate against the rubric
- Variance between runs
- Tool calls and elapsed time
- Token usage when available
- New failure modes introduced by the revision

## Revision Loop

When a scenario exposes a problem:

1. Cite the exact action or omission that failed the rubric.
2. Classify it as a trigger, ordering, completeness, judgment, or efficiency problem.
3. Choose the smallest guidance form that addresses that class.
4. Edit the skill.
5. Re-run structural validation.
6. Re-run the affected scenario with a fresh agent.

Do not add broad prose for one ambiguous sample. Confirm the behavior is reproducible or clearly tied to a missing instruction.

## Warning Signs

- Evaluator received the expected answer
- Scenario depends on private context a real user would not provide
- Success is based on source text rather than agent behavior
- One lucky run is treated as conclusive
- Failed runs are explained away without revising the rubric or skill
- Evaluation modifies production or external systems unnecessarily
- Artifacts from earlier runs remain visible to later evaluators

## Completion Checklist

- [ ] Skill draft and structural validation completed before new scenarios were authored
- [ ] Scenarios resemble real user requests
- [ ] Fresh agents received minimal, uncontaminated context
- [ ] Rubric measures observable behavior and artifacts
- [ ] Variable behavior received multiple runs where practical
- [ ] Findings were addressed with focused revisions
- [ ] Revised scenarios meet the rubric consistently
