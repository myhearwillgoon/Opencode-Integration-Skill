# OpenCode Integration Skill for OpenClaw

🤖 Integrate OpenCode AI coding assistant into your OpenClaw workflow.

[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://github.com/openclaw/openclaw)
[![OpenCode](https://img.shields.io/badge/OpenCode-CLI-green)](https://opencode.ai)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🎯 Features

- **Multi-Model Support**: Access OpenCode's model catalog (MiniMax, GPT-5, etc.)
- **Seamless Integration**: Call OpenCode directly from OpenClaw sessions
- **Background Tasks**: Run long coding tasks in background with progress tracking
- **PTY Support**: Full terminal interaction for interactive CLI sessions
- **Workdir Control**: Execute in any project directory
- **Process Management**: Monitor, control, and interact with running OpenCode sessions

## 🚀 Quick Start

### Prerequisites

```bash
# Install OpenCode CLI
npm install -g @opencode/cli

# Authenticate
opencode auth login

# Verify installation
opencode --version
opencode models
```

### Installation

```bash
# Via OpenClaw CLI (recommended)
openclaw skills install opencode-integration

# Or clone manually
git clone https://github.com/myhearwillgoon/Opencode-Integration-Skill.git
```

## 💡 Usage Examples

### Basic Code Generation

```bash
# Simple prompt
opencode run "Create a Python function to sort a list"

# With specific model
opencode run --model opencode/gpt-5-nano "Refactor this React component"

# In a specific directory
cd /path/to/project && opencode run "Generate unit tests"
```

### In OpenClaw Session

```typescript
// Simple exec call
exec(pty: true, command: 'opencode run --model opencode/minimax-m2.5-free "Create REST API"')

// Background task with workdir
exec(
  pty: true, 
  background: true, 
  workdir: "~/my-project", 
  command: 'opencode run "Analyze codebase structure"'
)

// Monitor background task
process(action: "log", sessionId: "xxx")

// Submit input to running session
process(action: "submit", sessionId: "xxx", data: "Continue with refactoring")
```

### Project Analysis

```bash
# Full project analysis
cd /path/to/project && opencode run "Generate architecture diagram and suggest improvements"

# Code review
opencode run --model opencode/big-pickle "Review this codebase for security issues"
```

### Interactive Sessions

```bash
# Start interactive session (PTY mode)
exec(pty: true, command: 'opencode session')

# Send commands to session
process(action: "send-keys", sessionId: "xxx", keys: ["Enter"])
```

## ⚙️ Configuration

### Supported Models

| Model | Description | Use Case | Cost |
|-------|-------------|----------|------|
| `opencode/minimax-m2.5-free` | MiniMax M2.5 | Quick tasks, testing | Free |
| `opencode/gpt-5-nano` | GPT-5 Nano | Production code | Paid |
| `opencode/big-pickle` | Large model | Complex analysis | Paid |
| `opencode/glm-4.7` | GLM-4.7 | Chinese language | Paid |
| `opencode/qwen3-coder-plus` | Qwen3 Coder | Code generation | Paid |

### Environment Variables

```bash
# Required
export OPENCODE_API_KEY="your-api-key"

# Optional
export OPENCODE_MODEL="opencode/minimax-m2.5-free"  # Default model
export OPENCODE_WORKDIR="/path/to/project"          # Default workdir
```

### OpenClaw Config Integration

Add to your `openclaw.json`:

```json
{
  "skills": {
    "load": {
      "extraDirs": [
        "/path/to/opencode-integration"
      ]
    }
  }
}
```

## 📚 Documentation

### Skill Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill documentation |
| `install.sh` | Installation script |
| `test_installation.sh` | Test script |
| `config_templates/` | Configuration templates |
| `examples/` | Usage examples |

### External Resources

- [OpenCode CLI Docs](https://docs.opencode.ai)
- [OpenClaw Integration Guide](https://docs.openclaw.ai)
- [OpenCode Models](https://opencode.ai/models)

## 🛠️ Development

### Testing

```bash
# Test installation
bash test_installation.sh

# Run examples
cd examples && bash quick_start.md

# Verify OpenCode connection
opencode run --model opencode/minimax-m2.5-free "Hello, World"
```

### Debugging

```bash
# Enable verbose output
export DEBUG=opencode:*
opencode run "Your prompt"

# Check OpenCode logs
opencode logs --follow
```

## 🤝 Contributing

Contributions welcome! Here's how to help:

1. **Fork** the repo
2. **Create** a feature branch (`git checkout -b feat/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feat/amazing-feature`)
5. **Open** a Pull Request

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) first.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Built for the [OpenClaw](https://github.com/openclaw/openclaw) community
- Powered by [OpenCode AI](https://opencode.ai)
- Inspired by the agent coding revolution

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/myhearwillgoon/Opencode-Integration-Skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/myhearwillgoon/Opencode-Integration-Skill/discussions)
- **OpenClaw Community**: [Discord](https://discord.com/invite/clawd)

---

**Author**: OpenClaw User  
**Version**: 1.0.0  
**Last Updated**: 2026-04-14  
**Repository**: https://github.com/myhearwillgoon/Opencode-Integration-Skill
