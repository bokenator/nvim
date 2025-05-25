#!/bin/bash

# Install LSP servers for Neovim
# Based on the servers configured in lspconfig.lua

set -e  # Exit on error

echo "Installing LSP servers..."

# Create a directory for LSP binaries if it doesn't exist
LSP_DIR="$HOME/.local/bin"
mkdir -p "$LSP_DIR"

# Ensure the directory is in PATH
if [[ ":$PATH:" != *":$LSP_DIR:"* ]]; then
    echo "export PATH=\"\$PATH:$LSP_DIR\"" >> ~/.bashrc
    export PATH="$PATH:$LSP_DIR"
fi

# 1. rust-analyzer (for Rust)
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

# 2. vscode-json-language-server (jsonls)
echo "Installing JSON language server..."
if command -v npm &> /dev/null; then
    npm install -g vscode-langservers-extracted
    echo "✓ JSON language server installed via npm"
else
    echo "⚠ npm not found. Please install Node.js and npm, then run:"
    echo "  npm install -g vscode-langservers-extracted"
fi

# 3. typescript-language-server (ts_ls)
echo "Installing TypeScript language server..."
if command -v npm &> /dev/null; then
    npm install -g typescript typescript-language-server
    echo "✓ TypeScript language server installed via npm"
else
    echo "⚠ npm not found. Please install Node.js and npm, then run:"
    echo "  npm install -g typescript typescript-language-server"
fi

# 4. lua-language-server (if you decide to add Lua support)
# Uncomment the following if you want to add lua_ls support
# echo "Installing Lua language server..."
# LUA_LS_VERSION="3.7.4"
# curl -L "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz" | tar xz -C "$LSP_DIR" --strip-components=1
# echo "✓ Lua language server installed to $LSP_DIR"

echo ""
echo "Installation complete!"
echo ""
echo "Installed LSP servers:"
command -v rust-analyzer &> /dev/null && echo "✓ rust-analyzer: $(rust-analyzer --version)"
command -v vscode-json-language-server &> /dev/null && echo "✓ JSON LS: installed (vscode-json-language-server)"
command -v typescript-language-server &> /dev/null && echo "✓ TypeScript LS: $(typescript-language-server --version 2>&1 | head -n1)"

echo ""
echo "Note: If any installations failed, make sure you have the required dependencies:"
echo "  - Node.js and npm (for TypeScript and JSON language servers)"
echo "  - Rust toolchain (for rust-analyzer via rustup)"