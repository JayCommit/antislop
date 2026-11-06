---
name: antislop
description: Review or prevent unnecessary abstraction, speculative flexibility, and maintenance problems in agent-written code. Use when implementing, refactoring, or reviewing code; preserve project conventions and required behavior.
---

# antislop

Prefer code whose ordinary behavior, failure paths, and ownership a maintainer can follow locally. Optimize for change and deletion, not minimum line count.

## Scope first

Read affected code, nearby conventions, applicable project instructions, and actual callers. Identify required behavior and public contracts. Search for suitable existing code before adding another implementation; do not force reuse across unrelated policies.

For a review or an ambiguous request to “clean up,” report findings without editing files. Make changes when implementation or refactoring is requested, within that scope. Do not turn a small fix into architecture cleanup.

## Decide whether structure earns its place

- Prefer direct control flow over factories, wrappers, hierarchies, and configuration introduced for hypothetical variants.
- Require a concrete benefit from indirection: shared policy that must change together, a meaningful domain rule, dependency isolation, lifecycle ownership, or a required contract. A layer that only forwards a call needs justification.
- A helper can name useful policy with one caller. Similar code can represent unrelated policies. Caller counts, line counts, and class names are clues, not verdicts.
- Follow local naming, layout, dependencies, and error handling. Explain a departure only when a concrete requirement or maintenance cost warrants it.
- Comment on constraints and intent. Remove restating or stale comments only within the touched scope; retain non-obvious operational knowledge.
- Keep errors, resource ownership, and recovery explicit. Preserve validation, security checks, compatibility, public interfaces, and relevant edge cases.

Before adding or removing a layer, ask:

1. Which current caller, contract, or invariant needs it?
2. Does it clarify behavior or merely move it elsewhere?
3. Can this feature change or disappear without edits to unrelated features?
4. Does it prevent drift, or need flags and exceptions for unrelated cases?

Stop abstracting when direct code satisfies current contracts and the extra layer has no concrete benefit. Keep useful dependency, transaction, and domain boundaries, even with one caller. If only the implementation is overbuilt, simplify inside the boundary. Never remove structure solely to meet a simplicity target.

## Check and report

Inspect the diff and trace ordinary and relevant failure paths. Use appropriate project checks when changing behavior; do not add tests that merely assert implementation shape.

For each review finding, give its location, concrete maintenance cost, and smallest useful alternative; state what contract must remain. If callers or contracts are unknown, qualify the suggestion rather than prescribe removal. Do not invent findings or present taste as a defect.

Briefly report consequential decisions and verification limits. Do not claim measured maintainability improvements without evidence.

## Optional detail

Read only the reference needed for a decision; do not load the catalog and examples by default.

- [Patterns](references/patterns.md): diagnose a suspected pattern and its justified exceptions.
- [Examples](references/examples.md): compare concrete alternatives when the decision remains unclear.

No other skill is required. With other skills active, use antislop for maintenance judgment without repeating their workflows.
