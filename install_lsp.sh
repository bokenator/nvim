#!/bin/bash

# Install LSP servers for Neovim
# Based on the servers configured in lspconfig.lua

set -e  # Exit on error

# Create a directory for LSP binaries if it doesn't exist
LSP_DIR="$HOME/.local/bin"
mkdir -p "$LSP_DIR"

# Ensure the directory is in PATH
if [[ ":$PATH:" != *":$LSP_DIR:"* ]]; then
    echo "export PATH=\"\$PATH:$LSP_DIR\"" >> ~/.bashrc
    export PATH="$PATH:$LSP_DIR"
fi

# Function to install rust-analyzer
install_rust_analyzer() {
    echo "Installing rust-analyzer..."
    if command -v rustup &> /dev/null; then
        rustup component add rust-analyzer
        echo "✓ rust-analyzer installed via rustup"
    else
        # Fallback: download from GitHub releases
        echo "Downloading rust-analyzer from GitHub releases..."
        curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > "$LSP_DIR/rust-analyzer"
        chmod +x "$LSP_DIR/rust-analyzer"
        echo "✓ rust-analyzer installed to $LSP_DIR"
    fi
}

# Function to install JSON language server
install_json_ls() {
    echo "Installing JSON language server..."
    if command -v npm &> /dev/null; then
        npm install -g vscode-langservers-extracted
        echo "✓ JSON language server installed via npm"
    else
        echo "⚠ npm not found. Please install Node.js and npm, then run:"
        echo "  npm install -g vscode-langservers-extracted"
        return 1
    fi
}

# Function to install TypeScript language server
install_typescript_ls() {
    echo "Installing TypeScript language server..."
    if command -v npm &> /dev/null; then
        npm install -g typescript typescript-language-server
        echo "✓ TypeScript language server installed via npm"
    else
        echo "⚠ npm not found. Please install Node.js and npm, then run:"
        echo "  npm install -g typescript typescript-language-server"
        return 1
    fi
}

# Function to install Pyright (Python language server)
install_pyright() {
    echo "Installing Pyright language server..."
    if command -v npm &> /dev/null; then
        npm install -g pyright
        echo "✓ Pyright language server installed via npm"
    else
        echo "⚠ npm not found. Please install Node.js and npm, then run:"
        echo "  npm install -g pyright"
        return 1
    fi
}

# Function to install Taplo (TOML language server)
install_taplo() {
    echo "Installing Taplo (TOML language server)..."
    if command -v cargo &> /dev/null; then
        cargo install --locked taplo-cli
        echo "✓ Taplo installed via cargo"
    else
        # Fallback: download from GitHub releases
        echo "Downloading Taplo from GitHub releases..."
        curl -L https://github.com/tamasfe/taplo/releases/latest/download/taplo-full-linux-x86_64.gz | gunzip -c - > "$LSP_DIR/taplo"
        chmod +x "$LSP_DIR/taplo"
        echo "✓ Taplo installed to $LSP_DIR"
    fi
}

# Function to install Lua language server (optional)
install_lua_ls() {
    echo "Installing Lua language server..."
    LUA_LS_VERSION="3.7.4"
    curl -L "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz" | tar xz -C "$LSP_DIR" --strip-components=1
    echo "✓ Lua language server installed to $LSP_DIR"
}

# Function to check installed LSP servers
check_installed() {
    echo ""
    echo "Installed LSP servers:"
    command -v rust-analyzer &> /dev/null && echo "✓ rust-analyzer: $(rust-analyzer --version)"
    command -v vscode-json-language-server &> /dev/null && echo "✓ JSON LS: installed (vscode-json-language-server)"
    command -v typescript-language-server &> /dev/null && echo "✓ TypeScript LS: $(typescript-language-server --version 2>&1 | head -n1)"
    command -v pyright &> /dev/null && echo "✓ Pyright: $(pyright --version)"
    command -v taplo &> /dev/null && echo "✓ Taplo (TOML): $(taplo --version)"
    # command -v lua-language-server &> /dev/null && echo "✓ Lua LS: $(lua-language-server --version)"
}

# Main installation
echo "Installing LSP servers..."
echo ""

# Install all LSP servers
install_rust_analyzer
echo ""
install_json_ls
echo ""
install_typescript_ls
echo ""
install_pyright
echo ""
install_taplo
echo ""

# Uncomment to install Lua language server
# install_lua_ls
# echo ""

# Check what's installed
check_installed

echo ""
echo "Installation complete!"
echo ""
echo "Note: If any installations failed, make sure you have the required dependencies:"
echo "  - Node.js and npm (for TypeScript, JSON, and Python language servers)"
echo "  - Rust toolchain (for rust-analyzer via rustup and taplo via cargo)"
