---
name: harmony-launch-system-bars
description: Use this skill whenever adapting a HarmonyOS ArkTS/ArkUI or Flutter-OHOS app launch experience, system start window, splash screen, status bar, navigation bar, safe area, fullscreen mode, tablet layout, or recent-tasks preview. This skill is especially important when the user reports a separate status-bar color strip, status bar changing before page transition, ugly desktop-to-app launch animation, or tablet recent-task previews showing a standalone top bar.
---

# Harmony Launch, System Bars, And Safe Areas

This skill captures the verified launch/status-bar pattern from Jimu and PinyinDic.
The main rule: make the system start window, the app splash first frame, the window fullscreen policy, and safe-area expansion agree with each other. Do not fix this by changing only `statusBarColor`.

## When To Use

Use this skill for HarmonyOS work involving:

- `startWindowIcon` or `startWindowBackground`
- in-app splash or launch animation
- `setWindowLayoutFullScreen`, `setWindowSystemBarEnable`, or `setWindowSystemBarProperties`
- `expandSafeArea`, `SafeAreaType.SYSTEM`, or `SafeAreaEdge`
- tablet/Pad status bar adaptation
- recent-task preview showing a separate status-bar strip
- desktop icon launch where the status bar changes before content transitions in

Also use `harmony-develop` for general ArkTS rules, and run `harmony-review` after code changes.

## Root Cause Checklist

Before patching, identify which layer is wrong:

1. System start window:
   - Check `entry/src/main/module.json5`.
   - If the app has its own animated splash, `startWindowIcon` should normally be a transparent icon, not the app icon.
   - `startWindowBackground` should match the first frame of the app splash.
2. Ability early setup:
   - Check `EntryAbility.ets`.
   - Do not set status/nav bar colors before `loadContent()` unless there is a strong reason.
   - Early system-bar writes often cause the status bar to change before the page transition.
3. Root page window policy:
   - The first real page should own fullscreen/system-bar policy.
   - For tablet/large screens, use fullscreen layout with visible transparent system bars so recent-task previews do not show a standalone top strip.
4. Safe area:
   - If the window is fullscreen, the root must expand into top and bottom system safe areas.
   - If the window is not fullscreen, do not force top safe-area expansion.

## System Start Window Pattern

For apps with a custom splash screen:

1. Add a transparent PNG named `transparent_start_window_icon.png` to:

```text
entry/src/main/resources/base/media/transparent_start_window_icon.png
```

This skill bundles a reusable 256x256 transparent PNG at:

```text
assets/transparent_start_window_icon.png
```

Copy it into the target project when needed.

2. Configure `module.json5`:

```json5
"startWindowIcon": "$media:transparent_start_window_icon",
"startWindowBackground": "$color:start_window_background"
```

3. Configure `color.json` so `start_window_background` matches the app splash first frame:

```json
{
  "color": [
    {
      "name": "start_window_background",
      "value": "#AED43A"
    }
  ]
}
```

Use the project splash color, not necessarily `#AED43A`.

Why: the system start window is shown before ArkUI/Flutter renders. If it displays the app icon while the app splash also animates an icon, the launch feels duplicated and abrupt. A transparent start icon lets the custom splash own the visual transition.

## Ability Setup Rule

Keep `EntryAbility` early window setup minimal:

```ts
private prepareWindow(mainWindow: window.Window): void {
  mainWindow.setPreferredOrientation(window.Orientation.UNSPECIFIED).catch((error: Error) => {
    hilog.warn(DOMAIN, 'EntryAbility', 'Reset orientation failed: %{public}s', JSON.stringify(error));
  });
}
```

Avoid these before `loadContent()`:

```ts
mainWindow.setWindowLayoutFullScreen(...);
mainWindow.setWindowSystemBarEnable(...);
mainWindow.setWindowSystemBarProperties(...);
```

Set window chrome from the root page/component after the app content exists.

## Root Window Policy

Use one source of truth for fullscreen and system bars.

Recommended tablet/phone split:

```ts
private shouldUseFullScreenWindow(): boolean {
  return !LayoutConstants.isPhone || this.state.route === 'build';
}

private shouldHideSystemBars(): boolean {
  return LayoutConstants.isPhone && this.state.route === 'build';
}
```

Meaning:

- Tablet/Pad: fullscreen layout on all pages, with status/nav bars visible and transparent.
- Phone normal pages: not fullscreen.
- Phone immersive/build page: fullscreen and hide system bars.

Apply policy through the main window:

```ts
private applyRouteWindowPolicy(): void {
  const mainWindow = AppStorage.get<window.Window>('mainWindow');
  if (mainWindow === undefined) {
    return;
  }
  const shouldUseFullScreen = this.shouldUseFullScreenWindow();
  const systemBarStyle = this.systemBarStyle();

  mainWindow.setWindowLayoutFullScreen(shouldUseFullScreen).catch((error: Error) => {
    hilog.warn(LOG_DOMAIN, LOG_TAG, 'Set fullscreen layout failed: %{public}s', JSON.stringify(error));
  });

  const enabledSystemBars: ('status' | 'navigation')[] = systemBarStyle.isHidden ? [] : ['status', 'navigation'];
  mainWindow.setWindowSystemBarEnable(enabledSystemBars).catch((error: Error) => {
    hilog.warn(LOG_DOMAIN, LOG_TAG, 'Set system bars failed: %{public}s', JSON.stringify(error));
  });

  this.applySystemBarStyle(mainWindow, systemBarStyle);
}
```

Cache applied values in real projects to avoid repeated window calls on every state update.

## System Bar Style

When fullscreen, use transparent system bars. Let the page background paint under them.

```ts
private systemBarStyle(): SystemBarStyle {
  if (this.isLaunchChromeVisible) {
    return {
      isHidden: false,
      statusBarColor: this.shouldUseFullScreenWindow() ? '#00000000' : SPLASH_BACKGROUND_COLOR,
      navigationBarColor: this.shouldUseFullScreenWindow() ? '#00000000' : SPLASH_BACKGROUND_COLOR,
      contentColor: '#000000',
      useLightIcon: false
    };
  }

  if (this.shouldHideSystemBars()) {
    return {
      isHidden: true,
      statusBarColor: '#00000000',
      navigationBarColor: '#00000000',
      contentColor: '#FFFFFF',
      useLightIcon: true
    };
  }

  return {
    isHidden: false,
    statusBarColor: this.shouldUseFullScreenWindow() ? '#00000000' : APP_BACKGROUND_COLOR,
    navigationBarColor: this.shouldUseFullScreenWindow() ? '#00000000' : APP_BACKGROUND_COLOR,
    contentColor: '#000000',
    useLightIcon: false
  };
}
```

Use modal scrim colors only when the window is not fullscreen. In fullscreen mode, keep system bars transparent and let the modal overlay cover the system-safe area.

## Safe Area Expansion

Attach `expandSafeArea` to the root full-screen container:

```ts
.width('100%')
.height('100%')
.backgroundColor(this.systemEdgeBackgroundColor())
.expandSafeArea([SafeAreaType.SYSTEM], this.systemSafeAreaEdges())
```

Recommended edge logic:

```ts
private systemSafeAreaEdges(): SafeAreaEdge[] {
  if (this.isLaunchChromeVisible) {
    return this.shouldUseFullScreenWindow() ? [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM] : [];
  }
  if (this.shouldShowModalScrim()) {
    return [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM];
  }
  return this.shouldUseFullScreenWindow() ? [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM] : [SafeAreaEdge.BOTTOM];
}
```

Why:

- Tablet fullscreen: content background fills top/bottom system areas, so recent tasks do not show a separate top strip.
- Phone non-fullscreen: avoid top expansion; the system owns the status area.
- Modal overlays should cover system-safe areas so the scrim is continuous.

## Layout Padding

After enabling tablet fullscreen, the root background fills the system bars. Keep actual content visually safe using page layout padding, not by reserving a separate system-bar band.

For tablet pages, `pagePaddingTop` should be enough to clear status icons. For phone immersive pages, handle controls with explicit top/bottom padding or a route-specific layout.

## Verification

Run these checks before claiming the issue is fixed:

1. Build:

```sh
hvigorw assembleHap
```

Do not use the old module/product hvigor command.

2. Install and launch on device.

3. Verify all four states:

- Desktop icon cold launch: no status bar color changes before the app transition.
- App splash: no duplicate system start icon and app splash icon.
- Normal Pad page: status bar icons float on page background, no separate colored top strip.
- Recent tasks on Pad: app card does not show an independent status-bar band.

4. Capture screenshots or video when possible. A plain running screenshot is not enough if the user reported recent-task or desktop-launch transition artifacts.

## Common Mistakes

- Using the app icon as `startWindowIcon` while also rendering an in-app splash icon.
- Setting status bar colors in `EntryAbility` before `loadContent()`.
- Using fullscreen only for phone build pages but not for Pad, which leaves a standalone status-bar strip in recent-task previews.
- Setting transparent system bars without expanding the root into top/bottom safe areas.
- Expanding safe area but forgetting enough content padding, causing UI to collide with status icons.
- Fixing the running page but not checking recent tasks.
