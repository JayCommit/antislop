# Working on antislop

antislop is an instruction-only Agent Skill for maintainability judgment: question unnecessary abstraction while preserving useful boundaries and existing behavior. It is not a detector, linter, or enforcement tool. Treat this folder as the complete future repository; do not depend on its enclosing checkout or sibling projects.

## Layout

- `SKILL.md`: discoverable metadata and short core instructions.
- `references/patterns.md`, `references/examples.md`: optional diagnostic detail, loaded on demand.
- `agents/openai.yaml`: Codex interface metadata; default prompt requests review without edits.
- `evals/README.md`: manual comparison method; `evals/release-verification.md`: dated evidence and limitations.
- `scripts/install.sh`, `scripts/install.ps1`: optional copy helpers for the host paths in `README.md`. They are not used during ordinary skill review and are not a test suite.
- `README.md`, `LICENSE`: public installation guidance and MIT terms.
- `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`: contributor checks, private vulnerability reporting, and conduct. They are not part of ordinary skill use.
- `.github/workflows/whitespace.yml`: runs `git diff --check` only. It does not test skill behavior. `.github/ISSUE_TEMPLATE/bug_report.md` and `.github/PULL_REQUEST_TEMPLATE.md` are GitHub prompts, not skill instructions.
- `.verification/`: ignored local scratch projects and logs, not shipped or required.

## Setup and checks

Edit Markdown/YAML directly. No build, package installation, dependency manifest, or committed test suite is present. `.github/workflows/whitespace.yml` runs `git diff --check` for whitespace only and does not test skill behavior. Use an already configured agent host for behavioral checks. Follow `README.md` to copy the pack into a separate test project's `.agents/skills/antislop/`. From that project, `bash scripts/install.sh --host openai --scope project` does the same copy. Then explicitly invoke `$antislop` for a read-only review. The v0.0.2 shell installer was path-checked on Linux only. `scripts/install.ps1` was not run. Neither script was run on macOS or Windows.

Run from this directory:

```sh
git diff --check
```

If the host provides skill-creator's `scripts/quick_validate.py`, run `python <skill-creator-directory>/scripts/quick_validate.py .`. That validator is optional external development tooling, not bundled with this pack; its Python environment needs PyYAML. Do not document it as a command available in every fresh clone.

For instruction changes, follow `evals/README.md`: compare identical tasks in separate sessions with and without the skill, holding source/model/settings constant. Check useful-boundary retention as well as removal of unnecessary layers. The historical `python -B -m unittest -v` commands ran in local scratch fixtures; running unittest in this repository is not a meaningful test suite.

## Constraints

- Keep the core high-signal. Its recorded baseline is 513 whitespace-delimited words, not a token limit or measured token count. Justify growth; keep long guidance in optional references.
- Preserve core → catalog → examples relative links. Do not require loading all references, evals, or maintainer docs for ordinary skill use.
- Add no dependencies, detectors, new patterns, or features without an explicit task requiring them.
- Preserve review-only defaults, project conventions, contracts, and justified abstractions. Do not turn preferences into universal bans.
- Record neutral and negative results. Three local paired reviews showed no clear improvement; do not claim proven quality gains, time savings, or broad host compatibility.
- Do not commit scratch logs, credentials, machine-specific paths, or parent-repository assumptions. Do not alter historical evidence to imply it tested later changes.

## Before committing

Inspect the scoped diff and status; exclude unrelated edits. Check changed local Markdown links resolve inside the pack, YAML/frontmatter parses, and referenced files exist. For behavior-guidance changes, verify a fresh installation reads the core and loads references only when needed; record model, prompt, checks, and limitations. Run applicable checks above and update public claims only when supported by evidence. Append new results to `evals/release-verification.md`; do not rewrite earlier evidence.
