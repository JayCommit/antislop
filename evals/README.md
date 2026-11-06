# Manual evaluation

Use these scenarios to assess decisions, including resistance to unnecessary cleanup. They require no harness or external packages. This guide is for maintainers evaluating the skill; agents need not load it during normal work.

1. Choose a scenario below and prepare a small project or real diff with relevant callers, contracts, tests, and conventions.
2. Make two identical copies. Install antislop in only one; keep it unavailable or disabled in the baseline. Start separate sessions with the same model and settings.
3. Give both the same request, adding only the explicit skill invocation to the treatment. Start with review-only requests that say “Do not modify files.” Do not supply the expected result column to the agent.
4. Compare correctness and actionable feedback using the criteria below. Record ties, regressions, and uncertainty as well as improvements; do not score repetition of skill terminology.

See the [release verification record](release-verification.md) for three completed paired reviews and their limits.

| Scenario and request | Observable success | Failure to watch for |
| --- | --- | --- |
| Add CSV export to a small reporting tool with no format selection | Direct implementation using correct CSV escaping and the existing module layout | New plugin registry, base exporter, or speculative format setting |
| Review a pass-through factory whose only caller chooses a fixed implementation | Checks callers and contracts; proposes the smallest useful simplification | Declares every factory wrong or removes a public API without considering consumers |
| Simplify checkout with the payment boundary in the examples | Retains error translation and idempotency behavior | Inlines provider details or drops failure semantics to reduce lines |
| Remove duplication between activation and invoice filters | Recognizes independent policy; leaves local expressions or domain-specific helpers | Creates a mode flag that couples unrelated feature changes |
| Fix a small bug in a project with an established service layer | Fixes the behavior using local conventions and focused verification | Reorganizes the architecture or renames unrelated modules |
| Review a clean direct implementation with one domain helper and a constraint comment | Produces no unsupported findings; keeps useful names and knowledge | Invents cleanup to satisfy a quota or deletes all comments |
| Simplify a generic helper used by several supported variants | Preserves each variant and weighs the actual cost before changing structure | Treats all options as speculative without tracing consumers |

## Record evidence

For each run, record the source revision or fixture, request, model/settings, skill version, resulting diff, relevant checks, and review notes. Check correctness first: a shorter implementation that breaks a contract is a failure.

Compare these outcomes across repeated tasks:

- **Cleanup effort:** reviewer time and edits needed to make the change acceptable.
- **Unnecessary structure:** layers or options a reviewer identifies as lacking a current purpose; record the supporting evidence, not just a count.
- **Maintenance judgment:** whether the reviewer can trace ordinary and failure behavior and identify where a realistic follow-up change belongs.
- **Scope and conventions:** unrelated edits, inconsistent terms, or invented patterns introduced.
- **Continued usefulness:** whether users choose to keep the skill after using it on real work.

Treat these as a review rubric, not a validated scoring system. Report observed results and sample size; do not claim long-term maintainability from a few examples. Adjust guidance for demonstrated failures without adding a universal rule for each individual preference.
