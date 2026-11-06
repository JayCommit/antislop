# Patterns to question

These are review prompts, not mechanical violations. Establish actual usage and contracts before proposing removal. “AI-looking” is not evidence of a defect.

| Pattern | Concrete maintenance cost | Prefer | Keep it when |
| --- | --- | --- | --- |
| Factory or strategy for a single fixed implementation | Readers navigate registration and dispatch to find a known operation | Construct or call the concrete implementation near its owner | Runtime selection exists, construction owns a lifecycle, or a required plugin contract applies |
| Pass-through service, repository, or utility wrapper | Adds another name and file without owning behavior | Call the existing API directly at the appropriate boundary | It isolates a volatile external API, enforces policy, or provides a stable public contract |
| Deep inheritance for combinations of behavior | A local change depends on inherited overrides and initialization order | Explicit functions or composition with clear ownership | A framework requires it, or the hierarchy models stable substitutable behavior |
| Generic engine for one workflow | Flags, hooks, and configuration hide a simple sequence | Express the workflow directly; extract demonstrated shared policy | Multiple current workflows share stable semantics and the engine reduces drift |
| Premature DRY across similar code | Unrelated changes require flags or special cases in a common helper | Allow local duplication until a shared responsibility is clear | The repeated code encodes one invariant that must change everywhere together |
| Tiny helpers that only rename syntax | Readers jump away to discover a trivial operation | Keep the expression local | The name expresses domain intent, clarifies a complex condition, or centralizes policy |
| Speculative options or extension points | Enlarges the supported state space without a consumer | Implement the requested behavior with explicit inputs | A current caller, compatibility contract, or required deployment variant needs the option |
| Comments restating code | Adds noise and creates another thing to keep synchronized | Use clear names; comment on reasons and constraints | A non-obvious invariant, external quirk, or decision needs explanation |
| Invented vocabulary or parallel conventions | Maintainers translate between names for the same concept | Reuse established terms, file layout, and error patterns | A new concept is materially different, or existing conventions cannot meet the task |
| Catch-all defaults and silent fallbacks | Failure becomes plausible-looking output and bugs move downstream | Follow the existing error contract and handle known recovery cases explicitly | Degradation is a required behavior and failures remain observable as appropriate |
| Shared dumping-ground modules | Unrelated features become coupled through a convenient import | Keep code near the feature or an existing cohesive module | The module has a narrow responsibility and genuinely shared consumers |
| Compression presented as simplicity | Dense expressions hide branches, mutations, or failure behavior | Name intermediate values and use straightforward control flow | The compact form is idiomatic, readable, and does not obscure semantics |

## Decide from evidence

Start with the current change and actual callers. A file called `Factory`, a long function, or a one-caller interface is not enough to establish a problem. Point to the needless navigation, changing responsibilities, hidden failure, or unused flexibility it causes.

For example: “This export path always constructs `CsvExporter`; the registry and format option have no consumers. Call `CsvExporter` directly here, retaining its escaping behavior.” This gives a maintainer an actionable alternative with a preserved contract.

If a boundary is useful but its implementation is overbuilt, simplify inside the boundary. Removing the whole boundary can be more disruptive than the original problem.

For concrete alternatives when a decision remains unclear, read the relevant section of [examples](examples.md). Do not load all examples for routine reviews.
