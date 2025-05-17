#!/bin/bash
set -e

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install hub tool if not already installed
install_hub() {
  if ! command_exists hub; then
    echo "Installing hub..."
    
    # Check the OS and install appropriately
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS - use Homebrew if available
      if command_exists brew; then
        brew install hub
      else
        echo "Homebrew not found. Please install Homebrew first or install hub manually."
      fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux - try using apt or your preferred package manager
      if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y hub
      elif command_exists yum; then
        sudo yum install -y hub
      else
        echo "Could not detect package manager. Please install hub manually."
      fi
    else
      echo "Unsupported OS. Please install hub manually."
    fi
  else
    echo "hub is already installed"
  fi
}

# Check if Node.js is installed and version is 18+
check_nodejs() {
  if command_exists node; then
    NODE_VERSION=$(node -v | cut -d 'v' -f 2 | cut -d '.' -f 1)
    if [ "$NODE_VERSION" -ge 18 ]; then
      echo "Node.js v$(node -v | cut -d 'v' -f 2) is already installed"
      return 0
    else
      echo "Node.js v$(node -v | cut -d 'v' -f 2) is installed but version 18+ is required"
      return 1
    fi
  else
    echo "Node.js is not installed"
    return 1
  fi
}

# Install Node.js if not already installed or version is less than 18
install_nodejs() {
  if ! check_nodejs; then
    echo "Installing Node.js 18+..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS - use Homebrew if available
      if command_exists brew; then
        brew install node@18
        # Add to PATH if needed
        if ! command_exists node || [ "$(node -v | cut -d 'v' -f 2 | cut -d '.' -f 1)" -lt 18 ]; then
          echo 'export PATH="/usr/local/opt/node@18/bin:$PATH"' >> ~/.zshrc
          export PATH="/usr/local/opt/node@18/bin:$PATH"
        fi
      else
        echo "Homebrew not found. Please install Homebrew first or install Node.js manually."
      fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux - use nvm for easier version management
      if ! command_exists nvm; then
        echo "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        
        # Load nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      fi
      
      # Install and use Node.js 18
      nvm install 18
      nvm use 18
    else
      echo "Unsupported OS. Please install Node.js manually."
    fi
  fi
}

# Install Claude Code CLI
install_claude_code() {
  if ! command_exists claude; then
    echo "Installing Claude Code CLI..."
    
    if command_exists npm; then
      npm install -g @anthropic-ai/claude-code
      echo "Claude Code installed successfully"
    else
      echo "npm not found. Please install Node.js first."
    fi
  else
    echo "Claude Code is already installed"
  fi
}

# Install uv and uvx
install_uv_uvx() {
  # Install uv if not already installed
  if ! command_exists uv; then
    echo "Installing uv..."
    
    if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | sh
    else
      echo "Unsupported OS. Please install uv manually."
    fi
  else
    echo "uv is already installed"
  fi
  
  # Install uvx if not already installed
  if ! command_exists uvx; then
    echo "Installing uvx..."
    
    if command_exists uv; then
      uv install uvx
    else
      echo "uv not found. Cannot install uvx."
    fi
  else
    echo "uvx is already installed"
  fi
}

# Install direnv if not already installed
install_direnv() {
  if ! command_exists direnv; then
    echo "Installing direnv..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS - use Homebrew if available
      if command_exists brew; then
        brew install direnv
      else
        echo "Homebrew not found. Please install Homebrew first or install direnv manually."
      fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux - try using apt or your preferred package manager
      if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y direnv
      elif command_exists yum; then
        sudo yum install -y direnv
      else
        # Fall back to direct download and installation
        echo "Installing direnv from GitHub releases..."
        DIRENV_VERSION=$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest | grep 'tag_name' | cut -d\" -f4)
        DIRENV_ARCH=$(uname -m)
        DIRENV_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        curl -sfLo direnv "https://github.com/direnv/direnv/releases/download/${DIRENV_VERSION}/direnv.${DIRENV_OS}-${DIRENV_ARCH}"
        chmod +x direnv
        sudo mv direnv /usr/local/bin/
      fi
    else
      echo "Unsupported OS. Please install direnv manually from https://direnv.net/docs/installation.html"
    fi
    
    # Configure shell integration if not already configured
    if [[ -f "$HOME/.zshrc" ]]; then
      if ! grep -q "direnv hook" "$HOME/.zshrc"; then
        echo 'eval "$(direnv hook zsh)"' >> "$HOME/.zshrc"
        echo "Added direnv hook to .zshrc"
      fi
    elif [[ -f "$HOME/.bashrc" ]]; then
      if ! grep -q "direnv hook" "$HOME/.bashrc"; then
        echo 'eval "$(direnv hook bash)"' >> "$HOME/.bashrc"
        echo "Added direnv hook to .bashrc"
      fi
    fi
  else
    echo "direnv is already installed"
  fi
}

# Install hub
install_hub

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh is already installed"
fi

# Add source line to .zshrc if it doesn't already exist
DOTFILES_SOURCE_LINE="source \$HOME/dotfiles/zshrc"
if ! grep -q "$DOTFILES_SOURCE_LINE" "$HOME/.zshrc"; then
  echo "Adding dotfiles/zshrc to .zshrc"
  echo "" >> "$HOME/.zshrc"
  echo "# Source custom dotfiles" >> "$HOME/.zshrc"
  echo "$DOTFILES_SOURCE_LINE" >> "$HOME/.zshrc"
  echo "Added dotfiles source line to .zshrc"
else
  echo "Dotfiles source line already exists in .zshrc"
fi

# Install Node.js 18+ if needed
install_nodejs

# Install Claude Code
install_claude_code

# Install uv and uvx
install_uv_uvx

# Install direnv
install_direnv

echo "Installation complete!"