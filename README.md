# antislop

An instruction-only Agent Skill for reviewing or writing code with fewer unnecessary layers, speculative options, and maintenance surprises. It guides judgment; it does not enforce rules, detect slop automatically, or guarantee better code.

Release v0.0.2 adds install paths. It does not change `SKILL.md`.

## Install

Mac is the primary platform. Each host below shows macOS commands first and a shorter Windows block second. These commands were not run on macOS or Windows. On Linux, `bash -n scripts/install.sh` passed, and that script's paths were exercised only against temporary directories. `scripts/install.ps1` was not executed. No host was launched, so discovery was not re-tested in Grok, Grok Bot, Cursor, the ChatGPT app, Codex, Antigravity, or Claude. There is no measured quality gain.

The skill is instruction text. It needs no package and no runtime. The scripts only copy this repository. They skip `.git` and `.verification`, refuse to replace an existing destination, and put `SKILL.md` directly in the skill folder (`.../antislop/SKILL.md`, never `.../antislop/antislop/SKILL.md`). A manual `cp -R` of a git clone also copies `.git`; the scripts do not.

Run the scripts from this repository. Defaults are `--host all` and `--scope user`.

macOS or Linux:

```sh
bash scripts/install.sh
bash scripts/install.sh --host all --scope user
```

`--host` is one of `grok`, `grok-bot`, `cursor`, `openai`, `antigravity`, `claude`, or `all`. `--scope user` writes under `$HOME`. `--scope project` writes under the current directory; run it from the project that should receive the skill.

Windows:

```powershell
powershell -NoProfile -File .\scripts\install.ps1
powershell -NoProfile -File .\scripts\install.ps1 --host all --scope user
```

User scope uses `$env:USERPROFILE`. Project scope uses the current directory.

Manual copies use the same layout. Replace the source path. Create the parent directory only. On Linux, `cp -R` of a folder named `antislop` into a destination that already existed produced `antislop/antislop/SKILL.md`. The exists-check avoids that. macOS `cp` was not run. Do not use `cp -a`.

### 1. Grok

Project: `.grok/skills/antislop/`. User: `$HOME/.grok/skills/antislop/`. Invoke `/antislop`.

Grok can also read `$HOME/.agents/skills/antislop/` and Claude Code skills. Still install the `.grok` path. `--host grok` writes `.grok` only. `--host all` also writes the OpenAI and Claude paths below.

macOS, user scope. Set `source` to this repo:

```sh
source="$HOME/src/antislop"
destination="$HOME/.grok/skills/antislop"
mkdir -p "$(dirname "$destination")"
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -R "$source" "$destination"
```

Project scope, from the target project: `destination="${PWD}/.grok/skills/antislop"` with the same `cp -R`, or `bash scripts/install.sh --host grok --scope project`.

Windows, user scope:

```powershell
$source = "$env:USERPROFILE\src\antislop"
$destination = "$env:USERPROFILE\.grok\skills\antislop"
if (Test-Path -LiteralPath $destination) { throw "Installation already exists" }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
```

Project scope: `powershell -NoProfile -File .\scripts\install.ps1 --host grok --scope project` from the target project.

### 2. Grok Bot

The same `SKILL.md` on the bot computer at `~/.grok/skills/antislop/` (`$HOME/.grok/skills/antislop/` on macOS, `$env:USERPROFILE\.grok\skills\antislop` on Windows). There is no second file format. Invoke `/antislop` when the bot accepts slash skills.

macOS or Linux, on the bot computer:

```sh
git clone https://github.com/JayCommit/antislop.git "$HOME/src/antislop"
source="$HOME/src/antislop"
destination="$HOME/.grok/skills/antislop"
mkdir -p "$(dirname "$destination")"
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -R "$source" "$destination"
```

Or, from that clone: `bash scripts/install.sh --host grok-bot --scope user`.

Windows, on the bot computer:

```powershell
git clone https://github.com/JayCommit/antislop.git "$env:USERPROFILE\src\antislop"
powershell -NoProfile -File "$env:USERPROFILE\src\antislop\scripts\install.ps1" --host grok-bot --scope user
```

If you can only paste a prompt, use this once:

```text
Clone https://github.com/JayCommit/antislop onto this computer. Copy that repository so SKILL.md is at ~/.grok/skills/antislop/SKILL.md, not ~/.grok/skills/antislop/antislop/SKILL.md. Skip the .git directory. If the destination already exists, stop. Do not edit the skill and do not invent another skill format. Then show the path of SKILL.md.
```

### 3. Cursor

Project: `.cursor/skills/antislop/` (Cursor also reads `.agents/skills/`). User: `$HOME/.cursor/skills/antislop/`. Invoke `/antislop`. The `name` in `SKILL.md` frontmatter is `antislop`, matching the folder.

macOS, user scope:

```sh
source="$HOME/src/antislop"
destination="$HOME/.cursor/skills/antislop"
mkdir -p "$(dirname "$destination")"
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -R "$source" "$destination"
```

Project scope, from the target project: `destination="${PWD}/.cursor/skills/antislop"`, or `bash scripts/install.sh --host cursor --scope project`.

Windows:

```powershell
$source = "$env:USERPROFILE\src\antislop"
$destination = "$env:USERPROFILE\.cursor\skills\antislop"
if (Test-Path -LiteralPath $destination) { throw "Installation already exists" }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
```

### 4. OpenAI / ChatGPT app

Disk, project: `.agents/skills/antislop/`. Disk, user: `$HOME/.agents/skills/antislop/`. Codex invoke `$antislop`. Keep `agents/openai.yaml` with the pack; it is optional Codex metadata.

macOS, user scope:

```sh
source="$HOME/src/antislop"
destination="$HOME/.agents/skills/antislop"
mkdir -p "$(dirname "$destination")"
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -R "$source" "$destination"
```

Project scope, from the target project: `destination="${PWD}/.agents/skills/antislop"`, or `bash scripts/install.sh --host openai --scope project`. That project path is the one recorded for Codex on Windows in the [verification record](evals/release-verification.md). This release did not launch Codex.

ChatGPT app: zip the skill folder that directly contains `SKILL.md`, then Plugins → Skills → Add → Upload. This upload was not tried.

macOS: after the copy above, open the parent folder in Finder, select that `antislop` folder, and choose File → Compress "antislop". Upload that zip. Do not compress a parent that would put `SKILL.md` at `antislop/antislop/SKILL.md`.

Windows:

```powershell
$source = "$env:USERPROFILE\src\antislop"
$destination = "$env:USERPROFILE\.agents\skills\antislop"
if (Test-Path -LiteralPath $destination) { throw "Installation already exists" }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
Compress-Archive -Path $destination -DestinationPath "$env:USERPROFILE\Desktop\antislop.zip"
```

Codex locations are also documented at [Build skills](https://learn.chatgpt.com/docs/build-skills). That page is not a test of this pack.

### 5. Antigravity

Project: `.agents/skills/antislop/` (exactly one level under `skills/`; the same folder as the OpenAI project path). User: `$HOME/.gemini/config/skills/antislop/`. CLI also: `$HOME/.gemini/antigravity-cli/skills/antislop/`. The `description` frontmatter in `SKILL.md` is required and is already set. Invoke `/antislop`.

`--host antigravity --scope user` writes both user directories. `--scope project` writes only `.agents/skills/antislop/`.

macOS, user scope:

```sh
source="$HOME/src/antislop"
dest_a="$HOME/.gemini/config/skills/antislop"
dest_b="$HOME/.gemini/antigravity-cli/skills/antislop"
for destination in "$dest_a" "$dest_b"; do
  if [ -e "$destination" ]; then
    echo "Installation already exists: $destination" >&2
    exit 1
  fi
done
for destination in "$dest_a" "$dest_b"; do
  mkdir -p "$(dirname "$destination")"
  cp -R "$source" "$destination"
done
```

Project scope, from the target project: `bash scripts/install.sh --host antigravity --scope project` writes `${PWD}/.agents/skills/antislop` only. A manual copy uses the same `cp -R` guard with `destination="${PWD}/.agents/skills/antislop"`.

Windows, user scope: `powershell -NoProfile -File .\scripts\install.ps1 --host antigravity --scope user`. Or copy manually (do not run both against the same folders):

```powershell
$source = "$env:USERPROFILE\src\antislop"
$destinations = @(
  "$env:USERPROFILE\.gemini\config\skills\antislop",
  "$env:USERPROFILE\.gemini\antigravity-cli\skills\antislop"
)
foreach ($destination in $destinations) {
  if (Test-Path -LiteralPath $destination) { throw "Installation already exists: $destination" }
}
foreach ($destination in $destinations) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
  Copy-Item -LiteralPath $source -Destination $destination -Recurse
}
```

### 6. Claude

Project: `.claude/skills/antislop/`. User: `$HOME/.claude/skills/antislop/`. Invoke `/antislop`.

macOS, user scope:

```sh
source="$HOME/src/antislop"
destination="$HOME/.claude/skills/antislop"
mkdir -p "$(dirname "$destination")"
if [ -e "$destination" ]; then
  echo "Installation already exists" >&2
  exit 1
fi
cp -R "$source" "$destination"
```

Project scope, from the target project: `destination="${PWD}/.claude/skills/antislop"`, or `bash scripts/install.sh --host claude --scope project`.

Windows:

```powershell
$source = "$env:USERPROFILE\src\antislop"
$destination = "$env:USERPROFILE\.claude\skills\antislop"
if (Test-Path -LiteralPath $destination) { throw "Installation already exists" }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
```

## Try a review

Ask for a read-only review and check that the host actually read the installed `SKILL.md`. Mentioning the name is not proof that discovery worked.

Codex:

```text
Use $antislop to review this change. Do not modify files.
Report concrete maintenance costs, locations, and the smallest useful alternatives.
```

Grok, Cursor, Antigravity, and Claude use `/antislop` instead of `$antislop`. Grok Bot uses the same skill folder as Grok on the bot computer. Those invocations were not re-tested. The recorded Codex session was on Windows; see the verification record.

## What it does

The [core rules](SKILL.md) ask the agent to trace callers and contracts, justify indirection, follow existing conventions, and preserve useful boundaries. Review is the default for ambiguous cleanup requests. To authorize changes, ask explicitly, for example: `Use $antislop to implement this feature following existing conventions.`

The core is self-contained. The [pattern catalog](references/patterns.md) and [examples](references/examples.md) are optional, loaded only when a decision needs them. Other skills are not required. Automatic selection remains enabled where the host supports it; explicit invocation is easier to verify.

## Verification and evaluation

See the [verification record](evals/release-verification.md) for the tested host, paired task results, and remaining gaps. v0.0.2 did not repeat those reviews. To evaluate your own setup, follow the [manual scenarios](evals/README.md): run the same task in separate sessions with and without the skill, hold model/settings/source constant, and compare correctness, actionable feedback, and unnecessary cleanup. Record neutral or worse results too.

## Limitations / MVP boundaries

- Suggestions depend on the model and the context it reads. Check callers, public contracts, and behavior before accepting a simplification.
- This is not a linter, security audit, style guide, or replacement for tests and human review. Read-only instructions are not a permission sandbox; use your host's read-only mode when needed.
- Small local comparisons cannot establish long-term maintainability, reviewer time savings, or adoption. Real-world effectiveness is still being evaluated. No measured quality gain is claimed.
- Host discovery and instruction-following vary. v0.0.2 documents more install paths. Discovery was not re-tested in those products. Install commands were not run on macOS or Windows.
- No detectors, dependencies, or automatic fixes are included.

## Repository checks

There is no committed test suite. [CONTRIBUTING.md](CONTRIBUTING.md) lists the manual checks used for this pack. [SECURITY.md](SECURITY.md) tells reporters to use GitHub private vulnerability reporting. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) is the conduct summary.

The [whitespace workflow](.github/workflows/whitespace.yml) runs `git diff --check` only. It does not install the skill, invoke an agent, or judge review quality. A whitespace result is not a green behavioral test and is not evidence of better code.

[MIT license](LICENSE).
