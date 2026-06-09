---
name: store-screenshot-composer
description: Generate App Store, Google Play, HarmonyOS, AGC, or AppGallery Connect promotional screenshot images from user-provided app screenshots. Use this whenever the user asks to create store screenshots, fill screenshot templates, generate titles/subtitles for screenshots, create Chinese/English store marketing images, compose app screenshots into simple generic phone-outline promo images, create 2in1 or large-screen 16:9 promotional images, add magnified feature callouts, or export one finished promo image per screenshot.
---

# Store Screenshot Composer

Create polished store-listing promotional screenshots from real app screenshots. The default output is:

- one image per provided screenshot, preserving the user's screenshot order
- Chinese and English versions unless the user requests a different language set
- phone screenshots rendered with a platform-neutral black-outline template
- Pad/iPad screenshots rendered with a simple tablet-outline variant when tablet screenshots are provided
- 2in1 screenshots rendered as additional 16:9 large-screen promotional images only when requested

The goal is to sell one idea per image. Do not document every UI detail, and do not invent capabilities that are not visible in the screenshot or known from project context.

## Inputs

Accept any of these input forms:

- a directory of screenshots
- explicit screenshot file paths
- separate phone and Pad/iPad screenshot directories
- a `2in1/` screenshot directory for large-screen 2in1 promotional images
- optional app name, brand colors, font, target stores, locales, and output directory

If there are more than 10 screenshots for a device type, use the first 10 in user-provided order. If the order is ambiguous, use natural filename sort and state that assumption. Ask the user only when ordering is business-critical and cannot be inferred.

Never alter source screenshots.

## Output

Create a project-local output directory unless the user specifies one:

```text
app-store-assets/generated/
├── apple-iphone-6.9/
│   ├── zh-Hans/
│   └── en/
├── harmony-agc-phone/
│   ├── zh-Hans/
│   └── en/
├── harmony-agc-2in1/
│   ├── zh-Hans/
│   └── en/
├── google-play-phone/
│   ├── zh-Hans/
│   └── en/
├── pad/
│   ├── zh-Hans/
│   └── en/
└── previews/
    └── contact-sheet-*.jpg
```

Also create a copy table:

```text
app-store-assets/generated/copy.md
```

For each screenshot, include:

- index
- source filename
- Chinese title and subtitle
- English title and subtitle
- any additional requested languages
- selected focus/callout region when useful

Store-ready folders must contain only one final submission image per source screenshot. Contact sheets or multi-image overview files are allowed only under `app-store-assets/generated/previews/`, and they must be labeled as non-submission assets.

## Platform Targets

When the user specifies a platform, choose the matching store target before rendering:

- `apple` / App Store: iPhone portrait `1284x2778` by default. App Store Connect accepted iPhone screenshot sizes include `1242x2688`, `2688x1242`, `1284x2778`, and `2778x1284`; never export arbitrary scaled sizes such as `1320x2868`.
- `harmony` / AGC / AppGallery Connect: generate 3-5 screenshots only, use `1080x1920`, keep a strict `9:16` aspect ratio, and export PNG/JPG/JPEG files under 5 MB each. If exporting WEBP, keep each file under 200 KB. Use `app-store-assets/generated/harmony-agc-phone/{locale}/`.
- `2in1` / Harmony 2in1 / AGC large-screen: generate additional large-screen promotional images only when requested. Use a strict `16:9` canvas with minimum size `1920x1080`, and export PNG/JPG/JPEG files under 5 MB each. Use `app-store-assets/generated/harmony-agc-2in1/{locale}/`.
- `google-play`: use `1080x1920` phone portrait unless the user requests tablet or feature graphic assets.

If the source set has more screenshots than the selected platform accepts, keep the first screenshots in user-provided order unless the user asks for a different priority. For Harmony/AGC, prefer 5 screenshots when at least 5 are available, because it uses the full allowed range.

## Copy Workflow

Generate copy before rendering.

Default languages:

- `zh-Hans`
- `en`

For each screenshot, infer the single strongest idea visible in the UI. If screenshot content is unclear, use the surrounding app context or ask for labels.

Copy rules:

- One idea per image.
- Title should be very short.
- Subtitle should add context, not repeat the title.
- Avoid feature-list headlines.
- Avoid joining two unrelated ideas.
- Do not invent capabilities that are not visible in the screenshot or supported by project context.
- Keep line breaks intentional for template placement.

Chinese copy constraints:

- Title: preferably 2-6 Chinese characters, or one short phrase.
- Subtitle: preferably 4-12 Chinese characters.
- Use concise product copy, not documentation phrasing.

English copy constraints:

- Title: preferably 1-3 words.
- Subtitle: preferably 2-6 words.
- Use sentence case or title case consistently.

Example:

```markdown
| # | Source | 中文主标题 | 中文副标题 | English Title | English Subtitle |
|---|---|---|---|---|---|
| 1 | home.png | 随身仓库 | Star 与 PR 随时管理 | Your Repos | Stars and PRs in reach |
```

If the user asks only for copy, stop after the table. If the user asks for generated images, continue.

## Phone Template

Use a generic phone-outline composition. This replaces device mockups, branded shells, camera cutouts, status bars, and tilted overlapping phone layouts.

Required characteristics:

- Portrait canvas with a very light background.
- Optional subtle pale-blue glow or geometric texture, kept low contrast.
- Main title centered near the top.
- Subtitle centered directly below the title with stable spacing.
- A simple black rounded-rectangle phone outline.
- No brand marks, no device-specific shell, no camera cutout, no notch, no Dynamic Island, no side buttons, no status bar, and no hardware home indicator.
- The source screenshot is clipped into the outline after removing system chrome from the screenshot when present.
- A magnified floating callout from the same screenshot overlaps the middle of the phone outline.
- The callout is a rounded rectangle with a light shadow, slightly larger scale than the phone content, and enough opacity/contrast to read as a feature focus.
- The callout must not cover the title/subtitle and should not hide the entire underlying screenshot.

Recommended design constants:

```text
Canvas Apple: 1284 x 2778
Canvas Harmony/Google: 1080 x 1920
Background: #F4FAFF to #FFFFFF
Title color: #111827
Subtitle color: #1F2937
Accent tint: app brand color at low opacity
Phone outline: #05070A
Callout fill: #FFFFFF
Font: Inter, SF Pro, system-ui, Arial fallback
```

Suggested `1080x1920` layout:

```text
Top safe area: 145
Title: 70-82 px
Subtitle: 34-42 px
Phone outer box: x 202, y 480, w 676, h 1290
Phone stroke: 10-14 px
Screenshot inset: 18-24 px
Callout box: x 110-145, y 760-980, w 790-860, h 420-560
```

Adapt proportions for other target sizes. Keep all elements inside store safe areas and check that long localized text fits.

### Source Screenshot Cropping

Many user screenshots include OS status bars or gesture indicators. Remove those before placing the screenshot in the generic outline:

- Detect or assume a top system-chrome crop when the screenshot has a status bar.
- Crop the bottom only enough to remove a system gesture indicator; preserve in-app bottom navigation.
- Keep the crop deterministic and document the crop in `copy.md` if it is not obvious.
- Do not add a replacement status bar.

### Magnified Callout Selection

Pick a region from the same source screenshot that best supports the slide copy:

- Prefer cards, repository rows, report headers, PR summaries, search results, profile stats, or other dense product value areas.
- Avoid selecting blank space, navigation bars, status bars, keyboard areas, or purely decorative content.
- If no per-slide focus region is supplied, choose a central region between 25% and 62% of the cropped screenshot height.
- The callout may be horizontally wider than the phone outline. Clip it with rounded corners.

## Pad Template

Use the same visual language for tablet screenshots:

- Landscape canvas by default.
- Title and subtitle near the top.
- Simple black rounded tablet outline below the copy.
- Screenshot clipped into the tablet outline with no device-specific hardware details.
- Optional magnified floating callout when it improves legibility.

Recommended canvas: `2732x2048`. If the Pad screenshots are portrait and the user explicitly wants portrait iPad App Store exports, use `2064x2752`.

## 2in1 Template

Use this template only when the user explicitly requests 2in1 or large-screen promotional images.

Required characteristics:

- Canvas is exactly `16:9`, at least `1920x1080`; default to `1920x1080`.
- Export PNG/JPG/JPEG under 5 MB each.
- Source screenshots come from a `2in1/` directory when present.
- Preserve the real large-screen UI; avoid stretching or distorting the screenshot.
- Place the screenshot inside a generic large-screen window or tablet-like outline, without brand marks or device-specific hardware.
- Use the same title/subtitle copy style as phone screenshots, but adapt the layout for landscape space.
- Do not add a phone frame, camera cutout, notch, or mobile status bar.
- If the source screenshot includes desktop/taskbar chrome, crop only when it improves focus and does not remove meaningful app UI; document the crop in `copy.md`.

Recommended `1920x1080` layout:

```text
Canvas: 1920 x 1080
Background: same light gradient/pattern as phone assets
Copy block: left side or top-left, title 72-92 px, subtitle 34-44 px
Large-screen frame: right/center, 1300-1500 px wide, 760-860 px tall
Frame: black or dark neutral outline with rounded corners and light shadow
```

When the screenshot itself is not 16:9, place it with `object-fit: cover` inside the large-screen frame while keeping the main UI content visible. Do not stretch non-16:9 screenshots to fill the canvas.

## Render Implementation

Prefer a deterministic local renderer:

1. Use a project-local generator script, HTML/SVG/Canvas renderer, or PIL renderer.
2. Export PNGs at exact target dimensions.
3. Avoid modifying app source code unless the user explicitly asks.
4. Put generated files under `app-store-assets/generated/`.

Implementation requirements:

- Generate every requested language for every screenshot.
- Preserve ordering in filenames with two-digit prefixes: `01.png`, `02.png`, ...
- Include the target store size, language, and device in the folder path.
- Use a mainstream store-accepted resolution, and state the selected target in `copy.md`.
- For Harmony/AGC, enforce 3-5 final images per locale, `9:16`, `1080x1920`, and per-file size limits before reporting completion.
- For 2in1, enforce exact `16:9`, minimum `1920x1080`, and per-file size limits before reporting completion.
- Keep the source screenshot visible and legible.
- Do not crop out important UI unless the template intentionally frames a detail.
- Do not use stock imagery unless the user requests it.

## Verify Before Completion

Before reporting completion:

- Confirm the number of generated images equals the screenshot count times language count for each target.
- Check image dimensions with `file`, `sips`, or equivalent.
- Check file sizes against the selected platform's limits.
- Verify store-ready folders do not contain contact sheets or multi-image previews.
- Create or inspect a contact sheet when possible.
- Open at least one generated image from each target and language group.
- Report limitations, such as missing Pad screenshots, ambiguous screenshot order, or manually inferred callout regions.

## Default Copy Strategy

Use a narrative arc when the screenshots allow it:

1. Hero / main promise
2. Dashboard or daily insight
3. Discovery or search
4. Repository/detail workflow
5. Organization or profile workflow
6-10. Remaining strongest single-feature slides

Do not force this order if the user-provided screenshot order is different. The user's screenshot order wins.

## Final Response

Keep the final response short and include:

- output folder
- language versions generated
- device templates generated
- validation performed
- any assumptions or blocked items
