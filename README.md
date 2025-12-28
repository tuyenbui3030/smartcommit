# 🤖 smartcommit

AI-powered git commit message generator. Automatically creates meaningful commit messages based on your staged changes.

## ✨ Features

- 🎯 Auto-detect commit type from branch name (`feat/`, `fix/`, `chore/`, etc.)
- 🎫 Auto-extract ticket number from branch name
- 🤖 AI-generated commit message body from diff
- ✅ Review before commit
- 🔧 Works with any OpenAI-compatible API

## 📦 Installation

### One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/tuyenbui3030/smartcommit/main/install.sh | bash
```

### Manual install

```bash
git clone https://github.com/tuyenbui3030/smartcommit.git
cd smartcommit
sudo cp git-ai /usr/local/bin/
sudo chmod +x /usr/local/bin/git-ai
git ai --setup
```

## 🚀 Usage

```bash
# Stage your changes
git add .

# Generate commit message with AI
git ai
```

### Output

```
🤖 Generating commit message...

📝 feat: #123 add user authentication

Commit? [Y/n/e(dit)] 
```

| Input | Action |
|-------|--------|
| `Y` or Enter | Commit |
| `e` | Edit message in editor |
| `n` | Cancel |

## 📖 Options

```bash
git ai --help      # Show help
git ai --version   # Show version
git ai --setup     # Configure API settings
git ai -y          # Skip confirmation, commit directly
```

## 🌿 Branch Naming Convention

The commit type is auto-detected from your branch name:

| Branch | Commit |
|--------|--------|
| `feat/123-add-login` | `feat: #123 <message>` |
| `fix/JIRA-456-null-bug` | `fix: #JIRA-456 <message>` |
| `vfa/feat/789-oauth` | `feat: #789 <message>` |
| `team/fix/999-crash` | `fix: #999 <message>` |

### Supported prefixes

| Prefix | Type |
|--------|------|
| `feat/`, `feature/` | feat |
| `fix/`, `bugfix/`, `hotfix/` | fix |
| `chore/` | chore |
| `docs/` | docs |
| `refactor/` | refactor |
| `test/`, `tests/` | test |
| `style/` | style |
| `perf/` | perf |
| `ci/` | ci |

## ⚙️ Configuration

Config is stored in `~/.config/git-ai/config`:

```bash
GIT_AI_URL="https://api.openai.com/v1/chat/completions"
GIT_AI_KEY="sk-xxx"
GIT_AI_MODEL="gpt-4"
```

### Reconfigure

```bash
git ai --setup
```

### Supported providers

| Provider | URL | Model |
|----------|-----|-------|
| OpenAI | `https://api.openai.com/v1/chat/completions` | `gpt-4`, `gpt-3.5-turbo` |
| Anthropic (via proxy) | Your proxy URL | `claude-3-opus`, etc. |
| Google (via proxy) | Your proxy URL | `gemini-pro`, etc. |
| Any OpenAI-compatible API | Your API URL | Your model |

## 📋 Requirements

- `bash` 4.0+
- `curl`
- `jq` - Install: `brew install jq` (macOS) or `apt install jq` (Linux)

## 🔒 Security

- API key is stored locally in `~/.config/git-ai/config`
- Config file permissions are set to `600` (owner read/write only)
- Key is never logged or transmitted except to your configured API

## 📄 License

MIT
