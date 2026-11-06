# Release verification — 2026-11-06

## Audit and changes

No measured-improvement claims were present. Missing basics were a license and ignore file; install paths needed updating; review-only usage was buried; and the catalog lacked an onward examples link. The core repeated some advice and could be more explicit about ambiguous cleanup, unknown contracts, and keeping useful boundaries. These were tightened without adding patterns or examples. Core size fell from 703 to 513 whitespace-delimited words; this is not a measured token count.

## Host and installation

Tested on Windows with Codex CLI `0.166.0-alpha.6`, provider `openai`, CLI-default model `gpt-6.1-sol`, reasoning effort `none` (reported by the host banner). Separate ephemeral sessions used the same CLI defaults and flags; the model was not explicitly pinned. User configuration was ignored, inherited desktop `CODEX_*` variables were excluded, and the shared daemon was disabled.

A release-file copy was installed under an isolated project's `.agents/skills/antislop/`. Explicit `$antislop` invocation discovered it, and successful tool traces show the agent reading that installed `SKILL.md`, source, and tests. This exercised local discovery rather than pasting the skill into a prompt. No global skill installation was made.

Initial pilots could not read files: an unconfigured Windows sandbox blocked execution, and the elevated sandbox failed with Windows error 267. They were excluded from the comparisons. Successful runs used `--no-daemon exec --ignore-user-config --ephemeral --skip-git-repo-check -s read-only -c 'windows.sandbox="unelevated"'`. This is a local host setup detail, not an antislop dependency.

## Three paired reviews

Each pair used identical `app.py` and `test_app.py` in separate project roots. The baseline had no installed antislop; the treatment had a copy. The common prompt was:

```text
Review app.py for maintainability. Inspect current callers and tests. Report actionable findings with locations and smallest useful alternatives. Do not modify any files. Stay within this project and do not use other skills. Load deeper references only if needed for a decision.
```

The treatment prepended only `Use $antislop. `. No expected answers, rubric, or example solutions were supplied to either run. These were small constructed fixtures equivalent to the manual scenarios, not production changes.

| Case and supplied behavior | Without skill | With skill | Assessment |
| --- | --- | --- | --- |
| CSV download always selects `"csv"` through `WriterRegistry` and a stateless `CsvWriter`; only the download function has callers | Remove registry; direct writer call is the smallest alternative, inlining optional | Inline rendering in download and remove both classes; explicitly retain quoting, newline handling, and empty output | Comparable useful feedback. Different simplification extent; no demonstrated improvement |
| `Gateway.debit` maps request ID to provider idempotency key, translates `CardRejected` to `CheckoutRejected`, and propagates unexpected errors | No actionable finding; retain SDK boundary | No actionable finding; retain mapping, translation, cause, and propagation; notes no real SDK integration | Comparable; no over-correction observed |
| Refund function uses a named cancellation rule and a shipping-policy comment; tests omit eligible `queued` status | Keep structure; reports missing queued-status coverage as a low finding | Keep structure/comment; suggests the same coverage addition | Comparable. The fixture had a genuine test gap, so a completely empty review was not the expected outcome after inspection |

Representative output: baseline factory review said “call `CsvWriter().render(rows)` directly and remove `WriterRegistry`”; treatment said “move the three-line CSV rendering body into `download()` and remove both classes.” Neither proposed hand-built CSV escaping. Both payment reviews retained the meaningful adapter, and both clean-code reviews identified the same untested status.

All six runs inspected their project files and passed the existing fixture tests (`python -B -m unittest -v`, or equivalent): two CSV tests covering escaping/embedded newlines and empty input; three payment tests covering forwarding, decline/cause, and unexpected failure; two refund tests covering eligible/ineligible cases. File-content checks confirmed no project source, tests, or installed skill content changed. This verifies read-only behavior for these runs, not universal instruction enforcement.

Result: **no clear quality improvement demonstrated across these three pairs**. The skill produced usable, scoped review feedback and did not remove useful structure. Evaluation was a single unblinded comparison per case, judged by the authoring agent. No independent human review, repeated trials, implementation comparisons, cleanup-time measurement, or long-term maintenance evidence was collected.

## Progressive disclosure

The three treatment reviews read the core without loading either optional reference. A separate, explicitly requested routing probe followed `SKILL.md` → `references/patterns.md` → `examples.md` (relative to the catalog, resolving to `references/examples.md`). Its tool output included only the requested “A one-caller boundary can still be valuable” example section. It concluded that one caller alone does not justify removing the adapter. Other example sections and the evaluation guide were not loaded. All release-local Markdown links were also checked for existence and containment within the copied folder.

## Input identity and remaining limits

Core SHA-256: `68110399392d046dbe16b8e345af626feb8e0eb6ddfa4afa8bb31690f7bf3fd1`.

The hashes identify the local paired fixtures; raw CLI logs and scratch projects are ignored under `.verification/` and are not release dependencies. To repeat the methodology with your own fixtures, follow [manual evaluation](README.md).

| Fixture | app.py SHA-256 | test_app.py SHA-256 |
| --- | --- | --- |
| factory | `f4c6cf66b0b48fc3110e01c45a77fb0b2b3cdba6d1d5c2483660d35f61252484` | `5c1e57bda494c988dc2dd269083e09807e53b23e5fd8fc21dd1551e0e3aa97ee` |
| payments | `5d5c3c3cfbf996869c8be895bfe62930f7859e2200f664a2f7783649daddc939` | `137767baee03055b2fdbc7dd888ee9823dbd5d0fdbdce93d6c18b906190e2c82` |
| clean | `f90d8a7f6a7fb9e040d20ff9d5511e8b88d567867ceed29b348f2c654ae99cee` | `327c39d4c476325fcdbe9473ad1239ce53a79de536df1e5c22a25636fd7e283d` |

Fresh-copy packaging, frontmatter validation, local links, example syntax, and CSV/payment example contracts were checked. General Agent Skills hosts, global Codex installation, implicit triggering, and interactive skill-picker behavior were not tested. Real-world effectiveness remains under evaluation; these smoke checks support basic usability, not claims of higher maintainability.

## Linux public-release checks — 2026-11-06

This section was appended for the public repository. It does not replace, re-score, or rewrite the Windows Codex record above. No quality improvement is claimed. The release tag chosen by the maintainer is `v0.0.1`. A removed pre-release checklist had drafted `v0.1.0`; that draft is not the published version and is not in this tree.

The maintainer checklist was followed for items that can run on this machine, then the checklist file was deleted before the first commit. It is not an install input or a skill dependency.

### Environment

- OS: Debian GNU/Linux 12 (bookworm), kernel 6.12.8+, x86_64.
- git 2.39.5, GitHub CLI 2.102.0, Python 3.10.22.
- PyYAML 6.0.3 was installed in a temporary virtualenv outside this repository. System Python raised `ModuleNotFoundError: No module named 'yaml'`.
- Optional validator: the host's skill-creator `scripts/quick_validate.py`, which is not shipped in this pack.
- Codex CLI was not on `PATH`. `pwsh` and `powershell` were not installed, so the README PowerShell example was not executed.
- This was not a separately imaged clean machine, not Windows, and not a screen-reader pass.

### What was run

`wc -w SKILL.md` printed `513`. `SKILL.md` was not edited for this release. That matches the recorded whole-file baseline above; it is still not a token count.

Both the PyYAML interpreter and system Python ran `quick_validate.py` on this directory and printed `Skill is valid!` (exit 0).

PyYAML `safe_load` parsed `agents/openai.yaml`, the `SKILL.md` frontmatter (`name: antislop`), and `.github/workflows/whitespace.yml`. The default prompt still says not to modify files.

A script checked local Markdown links on Linux (case-sensitive paths). 21 local links resolved to files inside the pack. None were missing or outside it. `HEAD` requests returned HTTP 200 for the README's Agent Skills documentation URL and for Contributor Covenant 2.1.

All 9 Python fences in `references/examples.md` parsed with `ast.parse`. The direct CSV example was executed: a field containing a comma was quoted, an embedded newline survived `csv.reader`, and empty input returned an empty string. The payment example still passes `idempotency_key` through and uses `raise PaymentDeclined() from error` for `ProviderDeclined` only.

The README shell copy was run from a separate temporary project, with the source path set to this directory. `.agents/skills/antislop/SKILL.md` existed. `.agents/skills/antislop/antislop` did not. A second run hit the existing-install guard. The copied `SKILL.md`, `references/patterns.md`, and `references/examples.md` were readable. The catalog link `examples.md` resolves to `references/examples.md`, including the heading "A one-caller boundary can still be valuable". That is a file check. An agent was not asked to load or skip those files.

`python3 -B -m unittest -v` in this directory printed `Ran 0 tests` and `OK` (exit 0). That is not a test suite and is not a pass.

A whitespace scan found no CR characters, no trailing spaces or tabs, and no missing final newline. Before the first commit, `git diff --cached --check` on the staged tree exited 0 with no output. A tracked-content search for drive-letter paths, common personal home prefixes, the parent checkout name, and parent-relative segments matched only the README placeholder path and `https://` URLs (the scheme looks like a drive prefix). No personal directory, credential, or parent-checkout dependency was left in tracked files.

### Not verified here

- Explicit `$antislop` invocation, core reads, or selective reference loading in Codex or any other host. No agent host was launched.
- Global installation, implicit triggering, and interactive skill selection.
- The manual paired scenarios in `evals/README.md`. They were not repeated.
- Other operating systems, screen readers, and a clean machine with a configured host.
- GitHub Actions. The whitespace workflow had not run on GitHub at the time of this section. It is not evidence about skill behavior.
- Whether the public clone URL installs. That check is after the first push and is not claimed here.
