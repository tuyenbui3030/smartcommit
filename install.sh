#!/usr/bin/env bash

# ============================================================
# smartcommit installer
# https://github.com/tuyenbui3030/smartcommit
# ============================================================

set -e

VERSION="1.0.1"
REPO_URL="https://raw.githubusercontent.com/tuyenbui3030/smartcommit/main"
INSTALL_PATH="/usr/local/bin/git-ai"
CONFIG_DIR="$HOME/.config/git-ai"
CONFIG_FILE="$CONFIG_DIR/config"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 smartcommit installer v$VERSION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# -------- check requirements --------
if ! command -v jq &> /dev/null; then
  echo "📦 jq not found, attempting to install..."
  
  # Detect OS and install jq
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - try apt-get first (Debian/Ubuntu)
    if command -v apt-get &> /dev/null; then
      sudo apt-get update && sudo apt-get install -y jq
    elif command -v yum &> /dev/null; then
      sudo yum install -y jq
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y jq
    elif command -v pacman &> /dev/null; then
      sudo pacman -S --noconfirm jq
    else
      echo "❌ Could not detect package manager. Please install jq manually."
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
      brew install jq
    else
      echo "❌ Homebrew not found. Install jq: brew install jq (after installing Homebrew)"
      exit 1
    fi
  else
    echo "❌ Unsupported OS. Please install jq manually."
    exit 1
  fi
  
  # Verify installation
  if ! command -v jq &> /dev/null; then
    echo "❌ jq installation failed. Please install manually."
    exit 1
  fi
  echo "✅ jq installed successfully!"
fi

if ! command -v curl &> /dev/null; then
  echo "❌ curl is required."
  exit 1
fi

# -------- download git-ai --------
echo "📥 Downloading git-ai..."
TMP_FILE=$(mktemp)
trap "rm -f $TMP_FILE" EXIT

HTTP_STATUS=$(curl -s -w "%{http_code}" -o "$TMP_FILE" "$REPO_URL/git-ai")

if [ "$HTTP_STATUS" != "200" ]; then
  echo "❌ Failed to download git-ai (HTTP $HTTP_STATUS)"
  exit 1
fi

# -------- get user input --------
echo ""
read -r -p "API Host (e.g., https://api.openai.com): " AI_HOST < /dev/tty
AI_HOST=${AI_HOST%/}

read -r -p "API Key: " AI_KEY < /dev/tty

read -r -p "Model (default: gpt-4): " AI_MODEL < /dev/tty
AI_MODEL=${AI_MODEL:-gpt-4}

echo ""

# -------- validate input --------
if [ -z "$AI_HOST" ]; then
  echo "❌ API Host is required"
  exit 1
fi

if [ -z "$AI_KEY" ]; then
  echo "❌ API Key is required"
  exit 1
fi

# -------- install git-ai --------
echo "📦 Installing git-ai to $INSTALL_PATH..."
sudo cp "$TMP_FILE" "$INSTALL_PATH"
sudo chmod 755 "$INSTALL_PATH"

# -------- save config --------
echo "📝 Saving config to $CONFIG_FILE..."

mkdir -p "$CONFIG_DIR"
cat > "$CONFIG_FILE" << EOF
GIT_AI_URL="$AI_HOST/v1/chat/completions"
GIT_AI_KEY="$AI_KEY"
GIT_AI_MODEL="$AI_MODEL"
EOF
chmod 600 "$CONFIG_FILE"

# -------- done --------
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Binary:  $INSTALL_PATH"
echo "📍 Config:  $CONFIG_FILE"
echo ""
echo "🔧 Configuration:"
echo "   URL   = $AI_HOST/v1/chat/completions"
echo "   KEY   = ${AI_KEY:0:10}..."
echo "   MODEL = $AI_MODEL"
echo ""
echo "🚀 Usage:"
echo "   git add ."
echo "   git ai"
echo ""
echo "📖 Options:"
echo "   git ai --help     Show help"
echo "   git ai --setup    Reconfigure"
echo "   git ai -y         Skip confirmation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
