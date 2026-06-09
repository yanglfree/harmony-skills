---
name: harmony-performance-analysis
description: Use this skill for HarmonyOS ArkTS/ArkUI performance audits, bottleneck analysis, and optimization planning. Trigger whenever the user asks to analyze Harmony performance, find rendering jank, inspect high-frequency state updates, review ArkUI lists/animations, audio latency, startup time, storage or network IO on UI paths, or identify potential performance issues in Harmony code.
---

# HarmonyOS Performance Analysis

Use this skill to audit HarmonyOS ArkTS/ArkUI code for performance bottlenecks and latent performance risks. Prefer evidence from the codebase over generic advice, and distinguish confirmed issues from hypotheses that need profiling.

## Workflow

1. Scope the audit.
   - Identify Harmony modules, pages, components, services, native bridges, and data paths.
   - Prioritize large files, hot UI paths, input/audio loops, timers, animations, long lists, startup code, storage, and network flows.
   - If the user asks for a project-wide audit, start broad with static searches, then deep-read high-risk files.

2. Build a hotspot map.
   - File size and responsibility concentration.
   - `@State`, `@Link`, `@Provide`, `@Consume`, and high-frequency mutations.
   - `setInterval`, `setTimeout`, animation callbacks, gesture handlers, audio callbacks, and polling loops.
   - `ForEach`, `LazyForEach`, array `map/filter/reduce/sort/slice`, object allocation, and computed data inside render builders.
   - Synchronous storage, JSON parsing/stringifying, file IO, network calls, and blocking work in lifecycle hooks.
   - Native bridge calls that may cross thread or process boundaries frequently.

3. Inspect the highest-risk paths.
   - For pages/components, trace which state changes invalidate which UI subtree.
   - For lists, verify virtualization, stable keys, item componentization, and item work.
   - For animations/game/audio views, check frame cadence, allocation per tick, and whether UI state updates run at audio-rate or frame-rate.
   - For services, check main-thread work, repeated initialization, cache policy, cleanup, and timer lifecycle.
   - For startup, check work in `onCreate`, `aboutToAppear`, initial page construction, and splash/navigation flow.

4. Classify findings.
   - P0: User-visible stall, leak, unbounded work, timer/audio loop lifecycle bug, or repeated UI invalidation likely to break core flows.
   - P1: High-probability jank, unnecessary broad re-rendering, avoidable synchronous IO, repeated allocation on hot paths, poor list virtualization, or expensive lifecycle work.
   - P2: Maintainability or scaling risk that may become slow with more data, devices, skins, songs, or features.

5. Recommend fixes.
   - Keep fixes local and measurable.
   - Prefer reducing invalidation scope before micro-optimizing.
   - Move expensive computation out of `build()` and high-frequency callbacks.
   - Use cached/precomputed models for render data.
   - Throttle visual updates to display cadence; do not update UI at audio cadence.
   - Use `LazyForEach` and stable keys for long or growing lists.
   - Ensure timers/listeners/native resources are released in lifecycle cleanup.
   - Propose profiling validation when static evidence is not enough.

## Static Search Checklist

Run targeted searches such as:

```text
@State|@Link|@Provide|@Consume
setInterval|setTimeout|clearInterval|clearTimeout
ForEach|LazyForEach
\\.map\\(|\\.filter\\(|\\.reduce\\(|\\.sort\\(|\\.slice\\(
aboutToAppear|aboutToDisappear|onPageShow|onPageHide|onCreate
JSON\\.parse|JSON\\.stringify|preferences|fs\\.|request\\(
animateTo|animation\\(|Canvas|onAreaChange|onTouch|onClick
```

## Report Format

Use this structure:

```markdown
# Harmony Performance Audit

## Scope
- Audited paths:
- Not audited:

## Executive Summary
- Overall risk:
- Most likely bottlenecks:

## Findings

### P1 - Title
- Evidence: `path:line`
- Why it matters:
- Recommendation:
- Validation:

## Hotspot Map
- Rendering:
- State invalidation:
- Timers/animation/audio:
- IO/startup:
- Data/list scaling:

## Suggested Next Steps
1. ...
```

## Review Principles

- Do not present guesses as facts. Label hypotheses clearly.
- Prefer file and line references for every concrete issue.
- A broad file is not automatically a performance bug; connect size/responsibility to render invalidation, lifecycle cost, or hot-path complexity.
- For audio and instrument apps, treat latency and frame stability as core UX metrics. Avoid recommendations that improve average throughput while increasing input-to-sound latency.
- Avoid large rewrites unless the existing structure makes local fixes ineffective.
