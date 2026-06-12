# 🎯 Harmony Skills

<p align="center">
  <strong>一组为 AI 编码助手设计的 HarmonyOS 开发技能集合</strong>
</p>

<p align="center">
  <a href="#技能目录">技能目录</a> •
  <a href="#快速开始">快速开始</a> •
  <a href="#目录结构">目录结构</a> •
  <a href="#贡献指南">贡献指南</a> •
  <a href="#许可证">许可证</a>
</p>

---

## 📖 简介

**Harmony Skills** 是一个面向 HarmonyOS 生态的 **AI 编码助手技能库**。每个 Skill 是一个结构化的知识模块，包含领域专家级别的开发规范、调试方法论和最佳实践，可被 Gemini 等 AI 编码助手加载，从而在 HarmonyOS 项目开发中提供专业指导。

本项目涵盖了从 **ArkTS/ArkUI 编码规范**、**代码审查**、**性能分析**、**Flutter-OH 调试** 到 **应用商店截图生成** 的完整工作流，旨在帮助开发者和 AI 协同构建高质量的 HarmonyOS 应用。

### 核心特性

- 🧠 **AI-Native** — 专为 AI 编码助手设计的结构化 Skill 格式（YAML 前置元数据 + Markdown 指令）
- 📐 **标准化** — 涵盖 17 项 ArkTS/ArkUI 编码规范，定义清晰的分层架构（Page → ViewModel → Service → Repository → Model）
- 🔍 **系统化审查** — 6 维度代码审查体系，含 P0/P1/P2 分级和可交付的检查清单
- ⚡ **性能导向** — 结构化性能审计流程，含热点图、静态检查正则模式和分级报告模板
- 🐛 **专业调试** — Flutter-OH 渲染与输入故障的系统化分诊方法论
- 📱 **商店就绪** — 自动化应用商店宣传截图生成，支持 Apple App Store、华为 AGC 和 Google Play

---

## 📋 技能目录

| 技能 | 描述 | 语言 | 评测 |
|------|------|------|------|
| [harmony-develop](./harmony-develop/) | ArkTS/ArkUI 原生开发编码规范与最佳实践 | 中文 | — |
| [harmony-review](./harmony-review/) | 基于编码规范的自动化代码审查流程 | 中文 | — |
| [harmony-launch-system-bars](./harmony-launch-system-bars/) | 应用启动体验、系统栏与安全区域适配 | 英文/中文 | — |
| [harmony-performance-analysis](./harmony-performance-analysis/) | HarmonyOS 性能瓶颈审计与优化规划 | 英文 | — |
| [harmony-flutter-oh-surface-debugging](./harmony-flutter-oh-surface-debugging/) | Flutter-OH 渲染白屏/输入偏移系统化调试 | 英文 | ✅ |
| [store-screenshot-composer](./store-screenshot-composer/) | 应用商店宣传截图自动化生成 | 英文 | ✅ |

### 技能依赖关系

```
harmony-develop (基础编码规范)
    │
    ├──▶ harmony-review (基于规范的代码审查)
    │
    ├──▶ harmony-launch-system-bars (启动与系统栏适配)
    │
    └──▶ harmony-performance-analysis (性能审计)

harmony-flutter-oh-surface-debugging (独立 · Flutter-OH 调试)

store-screenshot-composer (独立 · 商店截图生成)
```

---

## 🚀 快速开始

### 前提条件

- 支持加载 Skill 的 AI 编码助手（如 [Gemini](https://gemini.google.com/) + 支持的 IDE 插件）
- 对于 HarmonyOS 开发类 Skill：需要 [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 和 HarmonyOS SDK

### 使用方式

1. **克隆仓库**

   ```bash
   git clone https://github.com/your-username/harmony-skills.git
   ```

2. **加载 Skill**

   将需要的 Skill 目录路径配置到你的 AI 编码助手中。每个 Skill 的入口文件为 `SKILL.md`，AI 助手会读取其中的 YAML 前置元数据和结构化指令。

3. **在项目中使用**

   当你在 HarmonyOS 项目中与 AI 助手协作时，已加载的 Skill 会自动为 AI 提供对应领域的专业知识和规范指导。

### Skill 文件格式

每个 Skill 的 `SKILL.md` 遵循以下格式：

```markdown
---
name: skill-name
description: Skill 的简要描述
---

# Skill 正文

结构化的领域知识、规范、流程和代码示例...
```

---

## 📁 目录结构

```
harmony-skills/
│
├── harmony-develop/                      # ArkTS/ArkUI 编码规范
│   ├── SKILL.md                          # 17 项开发规范（核心）
│   └── examples/                         # ArkTS 参考模板
│       ├── page-template.ets             # 标准页面模板（Loading/Error/Content 状态）
│       ├── list-page-template.ets        # 长列表页面模板（LazyForEach + 下拉刷新）
│       ├── viewmodel-template.ets        # ViewModel 模式模板
│       └── repository-template.ets       # 数据仓库层模板
│
├── harmony-review/                       # 代码审查流程
│   ├── SKILL.md                          # 6 维度审查流程与报告格式
│   └── resources/
│       └── review-checklist.md           # 可填写的代码审查检查清单
│
├── harmony-launch-system-bars/           # 启动与系统栏
│   ├── SKILL.md                          # 启动窗口、系统栏、安全区域适配
│   └── assets/
│       └── transparent_start_window_icon.png  # 可复用的透明启动图标
│
├── harmony-performance-analysis/         # 性能分析
│   └── SKILL.md                          # 性能审计方法论与报告模板
│
├── harmony-flutter-oh-surface-debugging/ # Flutter-OH 调试
│   ├── SKILL.md                          # 渲染/输入故障分诊指南
│   └── evals/
│       └── evals.json                    # 3 项评测用例
│
├── store-screenshot-composer/            # 商店截图生成
│   ├── SKILL.md                          # 全流程截图生成规范
│   └── evals/
│       └── evals.json                    # 4 项评测用例
│
└── README.md                            # 本文件
```

---

## 🔧 各技能详细说明

### harmony-develop — 编码规范

**HarmonyOS 原生开发的基础规范**，定义了 17 项覆盖全生命周期的开发标准：

- **命名约定** — UpperCamelCase（类）、lowerCamelCase（变量）、UPPER_SNAKE_CASE（常量）、is/has 前缀（布尔）
- **分层架构** — Page → ViewModel → Service → Repository → Model，各层职责清晰分离
- **状态管理** — `@State`、`@Prop`、`@Link`、`@Provide`/`@Consume` 的正确用法和最小化作用域
- **路由规范** — 集中式路由名称、类型化参数、`Navigation` + `NavPathStack`
- **Git 工作流** — Conventional Commits、分支命名、PR 检查清单
- **国际化** — 使用 `$r('app.string.xxx')` 资源引用

包含 4 个 ArkTS 参考模板文件，展示标准页面、列表页、ViewModel 和 Repository 模式的最佳实践。

### harmony-review — 代码审查

基于 `harmony-develop` 规范的 **自动化代码审查流程**，从 6 个维度进行系统化审查：

1. **基础风格** — 命名、缩进、行宽、括号、函数长度
2. **类型与建模** — 类型声明、禁止 `any`/`ESObject`
3. **ArkUI 状态** — `@State` 作用域、初始化、`@Prop` vs `@Link`
4. **UI 与渲染** — 组件提取、列表组件化、`build()` 纯净性
5. **路由** — 集中管理、类型化参数
6. **日志与异常** — 统一 Logger、分级策略、禁止吞没异常

产出结构化审查报告，包含 P0（阻断合并）/P1（必须解决）/P2（建议优化）分级。

### harmony-launch-system-bars — 启动与系统栏

解决 HarmonyOS 应用 **启动体验和全屏适配** 的常见问题：

- 系统启动窗口（Start Window）配置模式
- 状态栏与导航栏透明化
- 安全区域（Safe Area）展开策略
- 平板 vs 手机的全屏分流逻辑
- 6 大常见反模式及规避方法

### harmony-performance-analysis — 性能分析

提供结构化的 **性能审计方法论**：

- 热点图构建（状态变更、定时器、动画、同步 IO）
- 静态检查正则模式库
- 发现分级（P0 用户可感知卡顿 → P2 扩展性风险）
- 标准化审计报告模板

### harmony-flutter-oh-surface-debugging — Flutter-OH 调试

针对 Flutter-OH（Flutter for OpenHarmony）的 **系统化故障分诊**：

- 白屏问题的 6 步分层诊断法
- 输入坐标偏移的根因分析
- `RenderFit` 与视口不匹配的修复策略
- `oh_modules` 补丁管理规范

### store-screenshot-composer — 商店截图

**全自动化应用商店宣传截图生成**：

- 支持 Apple App Store（1284×2778）、华为 AGC（1080×1920）、Google Play 等平台
- 手机、平板、二合一设备多模板
- 自动裁切系统栏、智能选取放大区域
- 中英双语文案生成

---

## 🤝 贡献指南

欢迎贡献新的 Skill 或改进现有 Skill！

### 如何贡献

1. **Fork** 本仓库
2. 创建特性分支：`git checkout -b feat/new-skill-name`
3. 提交你的更改：`git commit -m 'feat: add new-skill-name skill'`
4. 推送到分支：`git push origin feat/new-skill-name`
5. 创建 **Pull Request**

### 创建新 Skill

每个新 Skill 应包含以下结构：

```
your-skill-name/
├── SKILL.md          # 必需：Skill 定义文件（含 YAML 前置元数据）
├── examples/         # 可选：参考代码或模板
├── resources/        # 可选：辅助资源文件
├── assets/           # 可选：图片等静态资源
└── evals/            # 推荐：评测用例
    └── evals.json    # 评测用例定义
```

### Skill 编写规范

- `SKILL.md` 必须包含 `name` 和 `description` 的 YAML 前置元数据
- 内容应结构清晰、步骤明确，适合 AI 助手解析和执行
- 包含具体的代码示例和反模式说明
- 推荐添加 `evals/` 目录，用于验证 Skill 的有效性
- 遵循 [Conventional Commits](https://www.conventionalcommits.org/) 提交规范

### 代码风格

- Markdown 文件使用 UTF-8 编码
- 代码示例应完整且可运行
- 中英文混排时，中英文之间添加空格

---

## 📄 许可证

本项目基于 [MIT License](LICENSE) 发布。

---

## 🙏 致谢

本项目中的开发规范和最佳实践源自以下项目的实际开发经验：

- **Jimu** — HarmonyOS 原生应用
- **PinyinDic** — 拼音词典应用
- **CopoHub** — 协作平台应用

---

<p align="center">
  <sub>Built with ❤️ for the HarmonyOS ecosystem</sub>
</p>
