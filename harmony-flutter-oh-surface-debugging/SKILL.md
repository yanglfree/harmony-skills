---
name: harmony-flutter-oh-surface-debugging
description: Use when debugging Flutter-OH on HarmonyOS, especially 2-in-1 devices, white screen after launch, XComponent surface lifecycle issues, first frame not rendered, fullscreen/windowed/maximized rendering problems, windowRect/drawableRect mismatch, or pointer/click coordinate offset after resize. This skill is important whenever Dart logs show the Flutter app is running but the visible UI is blank or input hit testing does not match rendering.
---

# Harmony Flutter-OH Surface Debugging

Use this skill to diagnose Flutter-OH rendering and input failures on HarmonyOS, especially 2-in-1 devices running in floating, windowed, or maximized mode.

The key mental model: rendering and input are separate pipelines. A fix that makes pixels visible can still leave hit testing wrong.

## Triage Order

Follow this order. Do not skip directly to Dart UI changes unless the early checks prove Dart is the failing layer.

### 1. Prove Whether Dart Is Alive

Look for logs around:

- `main.start`
- `WidgetsFlutterBinding.ensureInitialized`
- service initialization completion
- `runApp`
- router build
- page build
- first post-frame callback

If Dart reaches route/page build, treat pure Dart startup, auth, routing, and page layout as lower-probability causes.

If Dart does not reach build, debug normal Flutter startup first.

### 2. Prove Whether ArkUI Is Alive

Add or inspect a small native ArkUI probe/overlay if needed.

Interpretation:

- Native ArkUI probe renders, Flutter area is blank: suspect Flutter-OH surface/engine/XComponent lifecycle.
- Native ArkUI probe does not render: suspect ArkUI page, window stage, ability lifecycle, or process startup.

### 3. Separate First Frame From First Widget Build

Do not equate Dart first post-frame with visible native first frame.

Check or instrument:

- `FlutterPage` lifecycle: `aboutToAppear`, `onPageShow`, `onAppear`
- XComponent lifecycle: `onLoad`, surface created callback
- Flutter view state: `isAttachedToFlutterEngine`, `hasRenderedFirstFrame`
- native first-frame state, if Flutter-OH exposes it through `FlutterNapi`

Probable root cause when Dart builds but `hasRenderedFirstFrame` stays false:

1. `FlutterView` was created before XComponent surface existed.
2. Engine attached too early.
3. Native side entered a preload or stale surface path.
4. Dart kept running, but frames were not submitted to the visible surface.

### 4. Validate Window And Viewport Metrics

On HarmonyOS 2-in-1 devices, decorated windows can report different app window and drawable sizes.

Log these together:

- `windowRect`
- `drawableRect`
- `globalDisplayRect`
- window status: floating, maximized, fullscreen
- XComponent/ArkUI area size
- native preDraw size
- Dart `View.physicalSize`
- Dart `devicePixelRatio`

Prefer `drawableRect` over `windowRect` for Flutter viewport size when the system title bar is outside the drawable area. Fall back to `windowRect` only when drawable size is zero.

### 5. Diagnose Surface Attachment

For Flutter-OH white screen with live Dart:

- Start Dart at the ability lifecycle timing.
- Avoid automatic early attachment if XComponent surface is not ready.
- Attach the engine after XComponent surface creation.
- Retry attachment over a few short delays because ArkUI area and drawable rect may settle over several frames.
- Push native surface metrics after surface creation and after window changes.
- Process pending engine messages after attachment or metric changes when the embedding exposes that API.

Keep this logic idempotent. Retrying should be safe when already attached.

### 6. Diagnose Pointer Coordinate Offset

If the UI is visible but clicks land at the wrong logical position, treat this as an input-pipeline bug, not a page-layout bug.

Check whether these diverge:

- Visual XComponent size
- Native buffer size
- Dart viewport size
- Input coordinate space
- Device pixel ratio

High-risk pattern:

```text
Dart viewport stays old size
XComponent grows after maximize
RenderFit.RESIZE_FILL stretches old buffer visually
Input events are still delivered in the unstretched coordinate space
```

In that case, `RESIZE_FILL` can make rendering look correct while breaking hit testing.

Prefer a true viewport update if Flutter-OH accepts it. If Dart viewport does not update reliably after resize, avoid XComponent-level visual stretching. Move the transform to ArkUI so hit testing follows the same transform as rendering.

Practical workaround:

- Use `RenderFit.TOP_LEFT` for `FlutterPage`.
- Disable frame cache for the page if resizing is expected.
- Keep the Flutter page at its first stable measured size.
- Apply an outer ArkUI scale transform based on current area divided by base area.
- Anchor both layout and transform to top-left.
- Use a zero transform center, for example `centerX: '0vp'`, `centerY: '0vp'`.

Validate by clicking known visible targets after maximize, not only by checking screenshots.

## Common False Leads

Do not spend much time on these once Dart route/page logs prove they ran:

- Authentication state
- Router configuration
- Login page layout
- cache/service initialization
- generic process failure
- `setWindowLayoutFullScreen` failure as the only root cause

Full-screen/window API failures can be part of the environment problem, but they do not explain a live Dart app whose frames never reach the visible XComponent surface.

## Flutter-OH Patch Discipline

Flutter-OH dependencies often live under ignored directories such as `oh_modules`.

If the fix requires modifying Flutter-OH source:

1. Create a tracked patch file in the app repository.
2. Apply it from the Harmony build script before compile.
3. Make the patch idempotent.
4. Ensure a clean dependency reinstall still gets the patch.
5. Never rely on manual edits inside ignored dependency directories.

For CopoHub, read the project case study if available:

```text
docs/harmony-2in1-flutter-oh-surface-lifecycle.md
```

## Validation Checklist

Before claiming the issue is fixed:

- Dart startup and page build logs are present.
- Native ArkUI page lifecycle is present.
- XComponent surface creation is logged.
- First-frame state becomes true, or a device screenshot proves Flutter content is visible.
- Windowed mode displays correctly.
- Maximized/fullscreen mode displays correctly.
- Known clickable targets hit the correct Flutter controls after resize.
- Harmony build passes.
- If shared Dart changed, Flutter analysis/build checks are run for the relevant toolchains.

For Harmony builds, follow the repository's build rules. In CopoHub, use:

```bash
hvigorw assembleHap
```

Do not use legacy module/product hvigor commands if the repository forbids them.

## Report Template

When reporting results, include:

```text
Conclusion:
Root cause:
Fix:
Excluded causes:
Validation:
Remaining risks:
```

Keep the explanation focused on evidence. Distinguish inference from observed logs/screenshots.
