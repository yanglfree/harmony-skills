---
name: harmony-develop
description: HarmonyOS ArkTS/ArkUI 开发规范与最佳实践。在进行 Harmony 原生开发时自动加载，指导命名、类型、分层架构、状态管理、路由、日志、异常处理、性能优化和 Git 工作流。
---

# HarmonyOS 原生应用开发规范 Skill

> 本 Skill 适用于所有基于 ArkTS + ArkUI 的 HarmonyOS 原生应用开发。
> 开发完成后，应自动触发 `harmony-review` Skill 进行代码审查。

---

## 一、总原则

1. **可读性优先** — 代码是给人读的
2. **显式类型优先** — 不依赖隐式推断
3. **单一职责** — 一个文件/函数只做一件事
4. **状态边界清晰** — 状态只在需要的范围内存在
5. **最小渲染范围** — 状态变化只影响必要的 UI
6. **日志可追踪** — 出了问题能快速定位
7. **异常可恢复** — 不吞异常、不崩溃
8. **敏感信息不落日志** — 安全底线

---

## 二、命名规范

| 类别 | 规则 | 示例 |
|------|------|------|
| 类 / 枚举 / 类型 | `UpperCamelCase` | `UserProfile`, `OrderStatus` |
| 变量 / 方法 / 参数 | `lowerCamelCase` | `userName`, `fetchOrders()` |
| 常量 | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| 布尔值 | `is/has/can/should` 前缀 | `isLoading`, `hasPermission` |
| 文件名 | 与主导出一致 | `UserProfile.ets`, `OrderService.ets` |

---

## 三、格式规范

- 使用**空格缩进**（2 或 4 空格，项目统一），禁止 Tab
- 单行不超过 **120 字符**
- 条件 / 循环**必须加大括号**，即使只有一行
- 字符串统一使用**单引号**
- 一行只做一件事
- 末尾逗号策略项目内统一

---

## 四、类型规范

- 公共方法**必须声明参数和返回值类型**
- **禁止 `any`** — 使用具体类型或泛型
- **禁止 `ESObject`** — 使用明确的接口定义
- 数组统一使用 `T[]` 而非 `Array<T>`
- NaN 判断使用 `Number.isNaN()` 而非全局 `isNaN()`
- `finally` 中**禁止** `return` / `break` / `continue` / `throw`

---

## 五、分层架构

推荐的项目分层结构：

```
entry/src/main/ets/
├── pages/              # Page：页面展示与交互编排
├── viewmodels/         # ViewModel：页面状态与交互流程
├── services/           # Service：业务服务
├── repositories/       # Repository：数据获取与聚合
├── models/             # Model：数据模型 / DTO
├── components/         # 公共 UI 组件
├── constants/          # 常量、枚举集中管理
├── utils/              # 工具类
└── router/             # 路由服务
```

### 分层职责

| 层 | 职责 | 禁止 |
|----|------|------|
| **Page** | UI 展示、用户交互编排 | 不写业务逻辑、不直接调 API |
| **ViewModel** | 管理页面状态、协调 Service | 不直接操作 UI 组件 |
| **Service** | 业务规则、流程编排 | 不依赖 UI 框架 |
| **Repository** | 数据获取（网络/本地）、聚合 | 不包含业务规则 |
| **Model** | 数据结构定义 | 不包含业务逻辑 |

---

## 六、UI 与渲染规范

### `build()` 函数限制

- ❌ 不得在 `build()` 中发起**网络请求**
- ❌ 不得在 `build()` 中执行 `sort()` / `filter()` / `reduce()` 等**复杂计算**
- ❌ 不得在 `build()` 中编写复杂分支逻辑
- ✅ 数据处理在 ViewModel / `aboutToAppear()` 中完成

### 组件拆分

- 超过 **3 层嵌套**必须考虑拆组件
- 页面文件超过 **300~400 行**建议拆分
- 长列表 item **必须组件化**
- 样式、颜色、字号、间距统一**资源化 / 主题化**

---

## 七、状态管理规范

| 装饰器 | 用途 | 要求 |
|--------|------|------|
| `@State` | 组件内局部状态 | 私有、声明类型、本地初始化 |
| `@Prop` | 父传子只读 | 单向数据流 |
| `@Link` | 父子双向绑定 | 谨慎使用，明确标注 |
| `@Provide` / `@Consume` | 跨层级共享 | 统一封装 |

### 关键规则

- `@State` **只用于组件内局部状态**，不要把全局业务数据塞进 `@State`
- `@State` 必须**声明类型**并**本地初始化**
- 不保存**冗余状态**，只保存源状态（派生数据用 getter 计算）
- 页面状态数量超过阈值时**必须拆 ViewModel**
- 子组件入参必须明确区分 `@Prop` 和 `@Link`

---

## 八、路由规范

- 路由名**集中管理**在常量文件中，禁止硬编码
- 统一封装 **RouterService** 处理页面跳转
- 路由参数**必须类型化**
- **禁止通过路由传大对象**（传 ID，在目标页加载数据）
- 页面返回链路必须可预测
- 使用 `Navigation` + `NavPathStack` 管理路由栈

---

## 九、日志规范

- 统一使用 **Logger** 封装 HiLog，不要到处直接打日志
- 按 `debug` / `info` / `warn` / `error` **分级记录**
- **禁止打印** token、密码、手机号、身份证等敏感数据
- 用户提示与开发日志**分离**
- 日志要包含足够上下文（模块名、操作、关键参数）

---

## 十、异常规范

- **禁止吞异常**（空 catch 块）
- Repository 层负责**底层异常转译**为业务异常
- UI 层只负责**用户提示**
- `finally` 中**禁止** `return` / `break` / `continue` / `throw`
- 异步操作必须有异常处理

---

## 十一、存储规范

- 存储 key **集中管理**在常量文件中
- 页面**不得直接操作存储**（通过 Repository / Service）
- 敏感数据**不得明文保存**

---

## 十二、性能规范

- **最小化状态影响范围** — 避免高频变化状态导致整页刷新
- 长列表 item **组件化** + `LazyForEach`
- 高频更新做**节流 / 防抖**
- **渲染前完成**排序、过滤、映射
- 避免在 `aboutToAppear()` 中做长时间同步操作

---

## 十三、Git 工作流

### 分支命名

```
feature/order-detail
fix/login-timeout
refactor/user-repository
chore/update-lint-rules
```

### Commit 规范（Conventional Commits）

```
feat: 新增订单详情页
fix: 修复登录态过期后页面未跳转问题
refactor: 重构用户信息仓储层
perf: 优化首页列表首屏渲染
style: 统一 ArkTS 格式化
docs: 更新 Harmony 编码规范
test: 补充用户模块单测
chore: 调整构建配置
```

### PR 要求

每个 PR 必须包含：
- 变更目的
- 影响范围
- 风险点
- 截图或录屏（UI 变更）
- 自测结果
- 是否影响路由 / 存储 / 权限 / 日志 / 埋点

---

## 十四、Lint 规则

建议至少启用以下约束：

```text
no-any                    # 禁止 any
no-unused-vars            # 禁止未使用变量
eqeqeq                   # 强制 === / !==
curly                     # 条件/循环必须大括号
max-len: 120              # 行宽限制
no-multiple-empty-lines   # 禁止多余空行
no-console                # 统一替换为 Logger
complexity                # 函数复杂度限制
max-lines-per-function    # 单函数行数限制
max-depth                 # 最大嵌套深度
```

---

## 十五、团队强制规则分级

### P0 必须卡住（阻断合并）

- 禁止 `any`
- 禁止页面直接写完整业务流程
- 禁止 `build()` 内做重计算
- 禁止硬编码路由名、存储 key、文案
- 禁止吞异常
- 禁止敏感日志
- 禁止 `finally` 中返回或抛出
- 禁止无类型接口返回

### P1 未达标不得合并

- 必须按 feature 分层
- 页面必须与 ViewModel / Service 分离
- 公共组件必须抽离
- 状态作用域必须清晰
- 公共常量、枚举、资源统一管理

### P2 持续优化

- 单文件长度限制
- 单函数圈复杂度限制
- 页面渲染耗时基线
- 长列表滚动性能基线
- 核心链路单测覆盖率目标

---

## 十六、国际化

- 新增文本**必须检查**当前应用是否支持多语言国际化
- 如果支持，**必须同时完成**多语言国际化适配
- **不要硬编码文本字符串**，使用 `$r('app.string.xxx')` 资源引用

---

## 十七、构建

- 使用 `hvigorw assembleHap` 构建
- **不要使用** `./hvigorw --mode module -p product=default assembleHap`

---

## 示例模板

本 Skill 在 `examples/` 目录下提供以下参考模板：

- `page-template.ets` — 标准页面骨架
- `list-page-template.ets` — 长列表页面
- `viewmodel-template.ets` — ViewModel 标准结构
- `repository-template.ets` — Repository 数据层结构

开发新页面 / 模块时，应参考这些模板保持一致性。

---

## 开发完成后

开发完成后，**必须触发 `harmony-review` Skill 进行代码审查**，确保所有改动符合以上规范。
