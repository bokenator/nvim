# Minimalistic Neovim Configuration

A clean, efficient Neovim setup with LSP support, modern UI, and thoughtful keybindings.

## Key Features

- **LSP Support**: Pre-configured for Rust, TypeScript/JavaScript, Python, JSON, and TOML
- **Smart Completion**: nvim-cmp with multiple sources and snippet support
- **File Explorer**: nvim-tree with git integration and custom navigation
- **Syntax Highlighting**: TreeSitter-based with smart text objects
- **Buffer Management**: Reorderable buffers displayed in winbar
- **Plugin Management**: Git subtree (no plugin manager needed)

## Installation

1. Clone this configuration to `~/.config/nvim/`
2. Run `./install_lsp.sh` to install LSP servers
3. Open Neovim - plugins are already included via git subtree

To update plugins: `./update.sh`

## Key Bindings

**Leader key: `Space`**

### Navigation
- `Alt-h/j/k/l` - Navigate between windows
- `Alt-n/p` - Next/previous buffer
- `Alt-s` - Alternate buffer
- `Alt-N/P` - Move buffer left/right in tabline
- `Alt-1..9` - Jump to buffer 1-9
- `Left/Right` - Horizontal scroll

### File Explorer
- `<Leader>t` - Toggle file tree
- `<Leader>n` - Find current file in tree
- In tree: `h/l` - Close/open directories

### Code Navigation (LSP)
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `gl` - Show diagnostics

### Editing
- `<Leader>c` - Copy entire file to clipboard
- `Alt-c` (visual) - Copy selection to clipboard
- `gcc` - Toggle line comment
- `gc{motion}` - Comment with motion
- `Alt-q` - Smart quit (preserves layout)

### TreeSitter Text Objects
- `vaf` - Select around function
- `vif` - Select inside function
- `vac` - Select around class
- `vic` - Select inside class
- `]m/[m` - Jump to next/previous function

## Features

### Auto-formatting
Automatically formats on save:
- Rust files (via rust-analyzer)
- TypeScript/JavaScript (via typescript-language-server)
- JSON files
- TOML files (via taplo)

### Smart Buffer Management
- Buffers shown in winbar with icons
- Modified buffers marked with `●`
- Reorderable with `Alt-N/P`
- Smart quit preserves window layout

### UI Enhancements
- VSCode color scheme
- Rounded borders on all floating windows
- Indent guides
- Scrollbar with diagnostic indicators
- Highlighted yank

## Configuration Structure

```
nvim/
├── init.lua              # Entry point
├── lua/config/
│   ├── keymaps.lua      # Key mappings
│   ├── lspconfig.lua    # LSP settings
│   ├── cmp.lua          # Completion
│   ├── tree.lua         # File explorer
│   └── ...              # Other modules
└── pack/plugins/start/   # Plugins (git subtree)
```

## Customization

- Leader key: Change in `lua/config/keymaps.lua`
- LSP servers: Modify `lua/config/lspconfig.lua`
- Color scheme: Edit `lua/config/colorscheme.lua`
- Editor settings: Adjust `lua/config/editor.lua`

## Tips

- Use `<Leader>` instead of reaching for `Ctrl`
- TreeSitter text objects make code navigation intuitive
- The config auto-reloads external file changes
- Project-specific settings: Create `.nvimrc` in project root