# Contributing

antislop is instruction text for an Agent Skill. It has no package, build step, detector, dependency manifest, or committed test suite.

## Install

Mac is the primary platform. Windows commands are second and were not executed in the v0.0.2 checks. From a separate project, this copies the repository so the entry point is `.agents/skills/antislop/SKILL.md`, not a nested `antislop/antislop/` directory:

```sh
bash /path/to/antislop/scripts/install.sh --host openai --scope project
```

Default `--scope user` writes under `$HOME`. Other hosts and paths are in [README.md](README.md). The script refuses an existing destination and skips `.git`.

Manual project copy (macOS/Linux), run from the target project. Do not create the final `antislop` directory first. On Linux, `cp -R` into an existing destination nested an extra directory. Do not use `cp -a`.

```sh
source="/path/to/antislop"
destination="${PWD}/.agents/skills/antislop"
mkdir -p "$(dirname "$destination")"
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -R "$source" "$destination"
```

Windows, from the target project. This block was not run:

```powershell
$source = "$env:USERPROFILE\src\antislop"
$destination = Join-Path (Get-Location) ".agents\skills\antislop"
if (Test-Path -LiteralPath $destination) { throw "Installation already exists" }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
```

`scripts/install.ps1` accepts the same `--host` and `--scope` flags.

In Codex, a read-only check is:

```text
Use $antislop to review this change. Do not modify files.
```

`$antislop` is Codex syntax. Other hosts were not verified in the recorded evidence. See [README.md](README.md).

## Checks that exist

From this repository:

```sh
git diff --check
bash -n scripts/install.sh
```

`bash -n` only parses the shell installer. It does not install the skill or prove the PowerShell script. Do not claim either installer was run on macOS or Windows unless you did that.

Also confirm local Markdown links resolve inside the pack, `SKILL.md` frontmatter parses, and [agents/openai.yaml](agents/openai.yaml) parses. There is no committed test command. Discovering zero `unittest` tests is not a pass.

If a development machine has skill-creator's `scripts/quick_validate.py`, that external script can be run against this directory. It is not part of this repository. Use PyYAML when you want its YAML parser path. Do not document that command as available in every fresh clone.

For instruction changes, follow [evals/README.md](evals/README.md): identical tasks, separate sessions, with and without the skill. Record ties and regressions. Do not claim measured quality gains, time savings, or untested host support.

GitHub Actions runs `git diff --check` for whitespace only, in [.github/workflows/whitespace.yml](.github/workflows/whitespace.yml). It does not test skill behavior. Do not describe that workflow as a test suite.

## Scope

Do not add dependencies, detectors, patterns, or features unless a maintainer task explicitly requires them. Preserve review-only defaults and useful boundaries. Append new results to [evals/release-verification.md](evals/release-verification.md); do not rewrite earlier evidence. Do not commit scratch logs, credentials, or machine-specific paths.
