---
name: OpenCode 集成
description: 通过 OpenCode CLI 调用和使用 OpenCode AI 编程助手
metadata:
  clawdbot:
    emoji: "🤖"
    requires:
      bins: ["opencode"]
---

# OpenCode 集成技能

## 概述

OpenCode 集成技能允许 OpenClaw 通过 OpenCode CLI 调用和使用 OpenCode AI 编程助手。OpenCode 是一个强大的 AI 编程工具，支持多种模型和代码生成任务。

## 安装和配置

### 1. 安装 OpenCode CLI
```bash
# 使用 npm 安装
npm install -g @opencode/cli

# 或使用其他包管理器
# yarn global add @opencode/cli
# pnpm add -g @opencode/cli
```

### 2. 认证配置
```bash
# 查看认证状态
opencode auth list

# 登录 OpenCode
opencode auth login

# 选择认证提供商（Google、GitHub 等）
```

### 3. 验证安装
```bash
# 检查版本
opencode --version

# 查看可用模型
opencode models

# 测试连接
opencode run --model opencode/minimax-m2.5-free "测试连接"
```

## 核心功能

### 支持的模型
- `opencode/minimax-m2.5-free` - 免费模型
- `opencode/gpt-5-nano` - GPT-5 Nano
- `opencode/big-pickle` - 大型模型
- 其他 OpenCode 提供的模型

### 基本使用模式
```bash
# 基本语法
opencode run [--model <model>] "<prompt>"

# 指定模型
opencode run --model opencode/gpt-5-nano "你的提示"

# 在特定目录运行
cd /path/to/project && opencode run "分析项目结构"
```

## 在 OpenClaw 中使用

### 通过 exec 工具调用
```bash
# 简单调用
exec(command='opencode run "生成 Python 函数"')

# 使用 PTY 模式（推荐）
exec(pty:true, command='opencode run --model opencode/minimax-m2.5-free "创建 React 组件"')

# 指定工作目录
exec(workdir:"/tmp/project", pty:true, command='opencode run "分析代码"')
```

### 后台任务处理
```bash
# 启动后台任务
exec(pty:true, background:true, workdir:"~/project", 
     command='opencode run --model opencode/gpt-5-nano "重构代码库"')

# 监控进度
process(action:log, sessionId:"XXX")

# 发送输入
process(action:submit, sessionId:"XXX", data:"继续")
```

## 使用示例

### 示例 1: 代码生成
```bash
# 生成 Python 函数
opencode run --model opencode/minimax-m2.5-free """
创建一个 Python 函数，用于计算斐波那契数列。
函数应该接受一个参数 n，返回第 n 个斐波那契数。
包含文档字符串和类型提示。
"""
```

### 示例 2: 代码审查
```bash
# 审查代码
opencode run --model opencode/gpt-5-nano """
请审查以下 Python 代码，提出改进建议：

def process_data(data):
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
    return result
"""
```

### 示例 3: 文档生成
```bash
# 生成 API 文档
opencode run --model opencode/big-pickle """
为以下函数生成完整的 API 文档：

class DataProcessor:
    def __init__(self, config):
        self.config = config
    
    def process(self, data):
        # 处理逻辑
        pass
    
    def validate(self, data):
        # 验证逻辑
        pass
"""
```

## 最佳实践

### 1. 使用 PTY 模式
OpenCode 是交互式终端应用，必须使用 PTY 模式：
```bash
# ✅ 正确
exec(pty:true, command='opencode run "任务"')

# ❌ 错误（可能失败）
exec(command='opencode run "任务"')
```

### 2. 指定工作目录
避免在敏感目录运行 OpenCode：
```bash
# 创建临时目录
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR && git init

# 在临时目录中运行
exec(workdir:$TEMP_DIR, pty:true, command='opencode run "任务"')
```

### 3. 模型选择策略
- 简单任务：`opencode/minimax-m2.5-free`
- 代码生成：`opencode/gpt-5-nano`
- 复杂分析：`opencode/big-pickle`

### 4. 错误处理
```bash
# 检查 OpenCode 状态
exec(command='opencode --version')

# 测试模型可用性
exec(pty:true, command='opencode run --model opencode/minimax-m2.5-free "测试"')

# 处理认证错误
exec(command='opencode auth list')
```

## 故障排除

### 常见问题

#### 1. 认证失败
```bash
# 检查认证状态
opencode auth list

# 重新登录
opencode auth login

# 如果使用 Google 认证失败，尝试其他提供商
```

#### 2. 模型找不到
```bash
# 查看可用模型
opencode models

# 使用正确的模型名称
# 错误：opencode/GLM-4.7
# 正确：opencode/minimax-m2.5-free
```

#### 3. 命令无响应
```bash
# 检查进程
process(action:list)

# 查看日志
process(action:log, sessionId:"XXX")

# 终止卡住的进程
process(action:kill, sessionId:"XXX")
```

#### 4. 网络问题
```bash
# 测试 API 连接
curl -I https://api.opencode.ai

# 检查代理设置
echo $HTTP_PROXY
echo $HTTPS_PROXY
```

---

## 🔁 二次开发与 Revert 工作流程 ⭐ 重要

### ⚠️ 关键概念：是否需要每次 init Git？

**答案**: 
- ❌ **不需要每次都 `git init`** - 只需要在项目第一次
- ✅ **但每次发送指令前应该 commit 基准点** - 这样才能 revert

**原因**:
- `git init` 只需要在项目开始时执行一次
- 但每次 Opencode 修改前，需要有**干净的 commit 点**才能 revert
- 否则 revert 会撤回之前的所有修改，而不仅仅是当前指令的修改

---

### 完整工作流程 (推荐所有 Agent 使用)

#### 场景 A: 新项目 (第一次使用)

```bash
# 1. 初始化项目 (只需一次)
cd /path/to/project
git init
git add .
git commit -m "Initial commit - Before any Opencode work"

# 2. 发送指令前 - 创建基准点
git add .
git commit -m "Before: [任务描述]"

# 3. 使用 Opencode 执行任务
opencode run --model opencode/minimax-m2.5-free "你的任务"

# 4. 检查结果
git diff  # 查看变更

# 5. 如果满意，提交
git add .
git commit -m "After: [任务描述]"

# 6. 如果不满意，Revert 撤回
git revert HEAD --no-edit
# 或
git reset --hard HEAD~1
```

#### 场景 B: 已有项目 (后续使用)

```bash
# 1. 确认 Git 已存在
cd /path/to/project
git status  # 确认是 Git 仓库

# 2. 确保工作目录干净
git status  # 应该显示 "nothing to commit, working tree clean"
# 如果有未提交变更，先提交或暂存
git add . && git commit -m "Before Opencode session"

# 3. 发送指令前 - 创建基准点
git add .
git commit -m "Before: [任务描述]"

# 4. 使用 Opencode 执行任务
opencode run --model opencode/minimax-m2.5-free "你的任务"

# 5. 检查并决定
git diff  # 查看变更
# 满意 → git commit
# 不满意 → git revert
```

---

### 📋 每次发送指令的检查清单 ⭐ 必读

**在发送 Opencode 指令前，确保**:

- [ ] **Git 已初始化** (`git status` 能正常执行)
- [ ] **工作目录干净** (`working tree clean`)
- [ ] **已创建基准 commit** (`git commit -m "Before: ..."`)

**这样可以保证**:
- ✅ 每次指令的修改都是独立的
- ✅ 可以单独 revert 某次指令的修改
- ✅ 不会影响其他指令的成果

---

### 📊 实际测试案例 (2026-04-09 验证通过)

#### 案例 1: 新项目 - 从零开始

```bash
# 1. 初始化 (只需一次)
mkdir /tmp/new-project && cd /tmp/new-project
git init
git commit --allow-empty -m "Initial commit"

# 2. 第一次 Opencode 任务前
git add .
git commit -m "Before: Create calculator"

# 3. 执行任务
opencode run "创建计算器函数"

# 4. 检查结果
git diff  # 查看变更

# 5. 决定
git add . && git commit -m "After: Created calculator"  # 满意
# 或
git revert HEAD  # 不满意
```

#### 案例 2: 已有项目 - 多次迭代

```bash
# 项目已有 Git 历史
cd /tmp/existing-project
git log --oneline -3
# abc123 Initial commit
# def456 Added feature A
# 789xyz Added feature B

# 第一次 Opencode 任务
git add . && git commit -m "Before: Add batch_calculate"
opencode run "添加批量计算函数"
git diff  # 检查
git add . && git commit -m "After: Added batch_calculate"  # 满意

# 第二次 Opencode 任务 (独立)
git add . && git commit -m "Before: Add division by zero handling"
opencode run "添加除零错误处理"
git diff  # 检查
git revert HEAD  # 不满意，撤回第二次任务

# 结果：第一次任务的成果保留，第二次任务撤回
git log --oneline -3
```

#### 案例 3: 在已有代码基础上二次开发
```bash
opencode session list | grep calculator
# ses_28dc550b6ffeaNb36X9uk8X6be  Python 简易计算器函数
```

**Step 2: 初始化 Git**
```bash
cd /tmp/opencode-controller-test
git init
git add .
git commit -m "Before secondary development"
```

**Step 3: 二次开发 - 添加新功能**
```bash
opencode run --model opencode/minimax-m2.5-free \
  "给 calculator.py 添加一个批量计算函数 batch_calculate"
```

**Step 4: 提交开发成果**
```bash
git add .
git commit -m "Added batch_calculate function"
```

**Step 5: Revert 撤回 (如需要)**
```bash
git revert HEAD --no-edit
```

**结果**: ✅ 文件完全恢复到开发前状态

---

### Session 管理命令

```bash
# 查看所有 Session
opencode session list

# 继续上次 Session
opencode --continue

# 指定 Session ID
opencode --session ses_28dc550b6ffeaNb36X9uk8X6be

# Fork Session (创建分支)
opencode --fork --session ses_28dc550b6ffeaNb36X9uk8X6be

# 删除 Session (不恢复文件)
opencode session delete ses_28dc550b6ffeaNb36X9uk8X6be
```

---

### 数据导出/导入

```bash
# 导出 Session 为 JSON
opencode export ses_28dc550b6ffeaNb36X9uk8X6be > backup.json

# 从 JSON 导入 Session
opencode import backup.json
```

---

### 安全最佳实践 ⭐ 所有 Agent 必读

1. **始终使用 Git**:
   ```bash
   # 开始 Opencode 前
   git init && git add . && git commit -m "Before Opencode"
   ```

2. **使用隔离目录测试**:
   ```bash
   mkdir /tmp/opencode-test-$(date +%s)
   cd /tmp/opencode-test-*
   ```

3. **定期备份**:
   ```bash
   # 导出 Session
   opencode export $(opencode session list | tail -1 | awk '{print $1}') > backup.json
   ```

4. **审查变更后再提交**:
   ```bash
   git diff  # 查看变更
   git add . && git commit -m "Review Opencode changes"
   ```

---

## 高级用法

### 批量处理
```bash
# 创建任务列表
TASKS=(
  "生成用户认证模块"
  "创建数据库模型"
  "编写 API 端点"
)

# 批量处理
for task in "${TASKS[@]}"; do
  exec(pty:true, background:true, 
       command:"opencode run --model opencode/gpt-5-nano '$task'")
done
```

### 集成到工作流
```bash
# 1. 初始化项目
exec(command:'git init')

# 2. 使用 OpenCode 生成代码
exec(pty:true, workdir:".", 
     command='opencode run --model opencode/gpt-5-nano "创建项目结构"')

# 3. 审查生成的代码
exec(pty:true, workdir:".", 
     command='opencode run --model opencode/minimax-m2.5-free "代码审查"')

# 4. 运行测试
exec(command:'python -m pytest')
```

## 性能优化

### 1. 缓存认证令牌
确保认证令牌有效，避免重复登录。

### 2. 模型预热
频繁使用的模型可以预先加载。

### 3. 结果缓存
对相同提示的结果进行缓存，提高响应速度。

### 4. 并发控制
合理控制并发任务数量，避免资源耗尽。

## 安全考虑

### 1. 输入验证
- 验证用户输入，防止注入攻击
- 限制提示长度和内容

### 2. 输出过滤
- 审查生成的代码，防止恶意代码
- 过滤敏感信息

### 3. 访问控制
- 限制 OpenCode 的访问权限
- 监控使用情况

### 4. 数据保护
- 不在 OpenCode 中处理敏感数据
- 使用临时目录处理文件

## 更新和维护

### 检查更新
```bash
# 检查 OpenCode 更新
opencode upgrade

# 查看当前版本
opencode --version
```

### 配置备份
```bash
# 备份配置文件
cp ~/.config/opencode/opencode.json ~/.config/opencode/opencode.json.backup
cp ~/.config/opencode/antigravity-accounts.json ~/.config/opencode/antigravity-accounts.json.backup
```

### 问题报告
遇到问题时：
1. 收集错误信息
2. 检查 OpenCode 日志
3. 查看系统日志
4. 联系技术支持

## 示例项目

### 完整的工作流示例
```bash
#!/bin/bash
# opencode-workflow.sh

# 1. 创建项目目录
PROJECT_DIR=$(mktemp -d)
cd $PROJECT_DIR
git init

# 2. 使用 OpenCode 生成项目结构
opencode run --model opencode/gpt-5-nano """
创建一个简单的 Python Web 项目，包含：
- requirements.txt
- app.py (Flask 应用)
- 模板目录
- 静态文件目录
"""

# 3. 审查生成的代码
opencode run --model opencode/minimax-m2.5-free """
请审查生成的代码，提出改进建议。
"""

# 4. 运行应用
python app.py &
APP_PID=$!

# 5. 测试应用
curl http://localhost:5000

# 6. 清理
kill $APP_PID
cd /
rm -rf $PROJECT_DIR
```

---

## 创建信息

- **创建时间**: 2026-03-01 16:51 GMT
- **创建方式**: 基于实际测试经验创建
- **测试状态**: OpenCode 连接已验证
- **已验证模型**: 
  - `opencode/gpt-5-nano` ✓ (成功创建文件)
  - `opencode/minimax-m2.5-free` ✓ (简单测试通过)
  - `opencode/big-pickle` ✓ (复杂分析)

## 备注

此技能文档基于实际的 OpenCode 使用经验创建，包含了已验证可用的配置步骤和命令示例。使用前请确保 OpenCode CLI 已正确安装和配置。

**更新于**: 2026-04-09 23:20  
**更新内容**: 添加二次开发与 Revert 工作流程、Session 管理、安全最佳实践
