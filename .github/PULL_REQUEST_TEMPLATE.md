## What changed

## Why

Instruction-only change. Do not add a detector, dependency, or pattern unless the task requires it.

## Checks

- [ ] `git diff --check`
- [ ] Local Markdown links resolve, and referenced files exist
- [ ] `SKILL.md` frontmatter and `agents/openai.yaml` still parse
- [ ] Public claims match evidence already recorded (no measured quality gain)

There is no committed test suite. The whitespace workflow runs `git diff --check` only and does not test skill behavior.

## Not checked

List any host, operating system, or invocation you did not run.
