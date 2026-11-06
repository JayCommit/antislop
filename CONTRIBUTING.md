# Contributing

antislop is instruction text for an Agent Skill. It has no package, build step, detector, dependency manifest, or committed test suite.

## Install

Copy this repository root into a separate project so the entry point is `.agents/skills/antislop/SKILL.md`, not a nested `antislop/antislop/` directory. Do not overwrite an existing installation without checking it. From the target project, with the source path replaced:

```sh
source="/path/to/antislop"
destination="${PWD}/.agents/skills/antislop"
mkdir -p .agents/skills
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -a "$source" "$destination"
```

In Codex, a read-only check is:

```text
Use $antislop to review this change. Do not modify files.
```

`$antislop` is Codex syntax. Other hosts were not verified in the recorded evidence. See [README.md](README.md).

## Checks that exist

From this repository:

```sh
git diff --check
```

Also confirm local Markdown links resolve inside the pack, `SKILL.md` frontmatter parses, and [agents/openai.yaml](agents/openai.yaml) parses. There is no committed test command. Discovering zero `unittest` tests is not a pass.

If a development machine has skill-creator's `scripts/quick_validate.py`, that external script can be run against this directory. It is not part of this repository. Use PyYAML when you want its YAML parser path. Do not document that command as available in every fresh clone.

For instruction changes, follow [evals/README.md](evals/README.md): identical tasks, separate sessions, with and without the skill. Record ties and regressions. Do not claim measured quality gains, time savings, or untested host support.

GitHub Actions runs `git diff --check` for whitespace only, in [.github/workflows/whitespace.yml](.github/workflows/whitespace.yml). It does not test skill behavior. Do not describe that workflow as a test suite.

## Scope

Do not add dependencies, detectors, patterns, or features unless a maintainer task explicitly requires them. Preserve review-only defaults and useful boundaries. Append new results to [evals/release-verification.md](evals/release-verification.md); do not rewrite earlier evidence. Do not commit scratch logs, credentials, or machine-specific paths.
