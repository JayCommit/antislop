# antislop

An instruction-only Agent Skill for reviewing or writing code with fewer unnecessary layers, speculative options, and maintenance surprises. It guides judgment; it does not enforce rules, detect slop automatically, or guarantee better code.

## Install and try a review

Requires an agent host with local Agent Skills support. The pack itself needs no packages, scripts, connectors, sibling skills, or parent repository files. Your host still needs its usual setup and access to a model.

### Codex (project-local)

1. Download or copy this complete folder. It must contain `SKILL.md`, `references/`, and `agents/` together.
2. In the project you want reviewed, create `.agents/skills/` and copy this folder into it as `antislop`. The resulting entry point must be `.agents/skills/antislop/SKILL.md`, not an extra nested `antislop/antislop/` directory. Do not overwrite an existing installation without checking it.
3. Open Codex in that project and start a new session. Use the prompt below. If the skill is missing, restart Codex and check the folder path.

PowerShell example, run from the target project, with the source path replaced:

```powershell
$source = "C:\path\to\antislop"
$destination = Join-Path (Get-Location) ".agents\skills\antislop"
if (Test-Path -LiteralPath $destination) { throw "Installation already exists" }
New-Item -ItemType Directory -Force -Path ".agents\skills" | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
```

Shell example, run from the target project, with the source path replaced. This is the same folder copy as the PowerShell example. It does not by itself invoke a host:

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

```text
Use $antislop to review this change. Do not modify files.
Report concrete maintenance costs, locations, and the smallest useful alternatives.
```

Check that the agent reads the installed `SKILL.md`; if discovery fails, do not assume that merely mentioning the name activated it. For installation across projects, Codex also supports `~/.agents/skills/antislop/`. See [official skill locations and invocation](https://learn.chatgpt.com/docs/build-skills). Project-local installation is the path exercised in this pack's verification (Codex on Windows; see the verification record). The shell copy above was checked on Linux as a file layout only; that check did not launch Codex.

### Other Agent Skills hosts

1. Find your host's documented local skill directory; there is no universal path.
2. Copy the complete folder into it as `antislop`, preserving relative paths.
3. Refresh or restart the host as its documentation requires, then explicitly select `antislop` using its skill picker or invocation syntax. `$antislop` is the Codex syntax, not a portable requirement.
4. Ask for the read-only review above and check that the host loaded `SKILL.md`.

`agents/openai.yaml` is optional Codex metadata. Other hosts have not been verified here.

## What it does

The [core rules](SKILL.md) ask the agent to trace callers and contracts, justify indirection, follow existing conventions, and preserve useful boundaries. Review is the default for ambiguous cleanup requests. To authorize changes, ask explicitly, for example: `Use $antislop to implement this feature following existing conventions.`

The core is self-contained. The [pattern catalog](references/patterns.md) and [examples](references/examples.md) are optional, loaded only when a decision needs them. Other skills are not required. Automatic selection remains enabled where the host supports it; explicit invocation is easier to verify.

## Verification and evaluation

See the [verification record](evals/release-verification.md) for the tested host, paired task results, and remaining gaps. To evaluate your own setup, follow the [manual scenarios](evals/README.md): run the same task in separate sessions with and without the skill, hold model/settings/source constant, and compare correctness, actionable feedback, and unnecessary cleanup. Record neutral or worse results too.

## Limitations / MVP boundaries

- Suggestions depend on the model and the context it reads. Check callers, public contracts, and behavior before accepting a simplification.
- This is not a linter, security audit, style guide, or replacement for tests and human review. Read-only instructions are not a permission sandbox; use your host's read-only mode when needed.
- Small local comparisons cannot establish long-term maintainability, reviewer time savings, or adoption. Real-world effectiveness is still being evaluated.
- Host discovery and instruction-following vary. No detectors, dependencies, or automatic fixes are included.

## Repository checks

There is no committed test suite. [CONTRIBUTING.md](CONTRIBUTING.md) lists the manual checks used for this pack. [SECURITY.md](SECURITY.md) tells reporters to use GitHub private vulnerability reporting. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) is the conduct summary.

The [whitespace workflow](.github/workflows/whitespace.yml) runs `git diff --check` only. It does not install the skill, invoke an agent, or judge review quality. A whitespace result is not a green behavioral test and is not evidence of better code.

[MIT license](LICENSE).
