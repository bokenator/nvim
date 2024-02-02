#!/bin/sh

git subtree pull --prefix pack/plugins/start/autopairs https://github.com/windwp/nvim-autopairs.git master --squash
git subtree pull --prefix pack/plugins/start/bufdelete https://github.com/famiu/bufdelete.nvim.git master --squash
git subtree pull --prefix pack/plugins/start/bufferline https://github.com/akinsho/bufferline.nvim.git main --squash
git subtree pull --prefix pack/plugins/start/cmp https://github.com/hrsh7th/nvim-cmp.git main --squash
git subtree pull --prefix pack/plugins/start/cmp-buffer https://github.com/hrsh7th/cmp-buffer.git main --squash
git subtree pull --prefix pack/plugins/start/cmp-cmdline https://github.com/hrsh7th/cmp-cmdline.git main --squash
git subtree pull --prefix pack/plugins/start/cmp-nvim-lsp https://github.com/hrsh7th/cmp-nvim-lsp.git main --squash
git subtree pull --prefix pack/plugins/start/cmp-path https://github.com/hrsh7th/cmp-path.git main --squash
git subtree pull --prefix pack/plugins/start/cmp-vsnip https://github.com/hrsh7th/cmp-vsnip.git main --squash
git subtree pull --prefix pack/plugins/start/comment https://github.com/numToStr/Comment.nvim.git master --squash
git subtree pull --prefix pack/plugins/start/devicons https://github.com/nvim-tree/nvim-web-devicons.git master --squash
git subtree pull --prefix pack/plugins/start/indentline https://github.com/lukas-reineke/indent-blankline.nvim.git master --squash
git subtree pull --prefix pack/plugins/start/mason https://github.com/williamboman/mason.nvim.git main --squash
git subtree pull --prefix pack/plugins/start/mason-lspconfig https://github.com/williamboman/mason-lspconfig.nvim.git main --squash
git subtree pull --prefix pack/plugins/start/lspconfig https://github.com/neovim/nvim-lspconfig.git master --squash
git subtree pull --prefix pack/plugins/start/plenary https://github.com/nvim-lua/plenary.nvim.git master --squash
git subtree pull --prefix pack/plugins/start/rust https://github.com/rust-lang/rust.vim.git master --squash
git subtree pull --prefix pack/plugins/start/scrollbar https://github.com/petertriho/nvim-scrollbar.git main --squash
git subtree pull --prefix pack/plugins/start/statusline https://github.com/nvim-lualine/lualine.nvim.git master --squash
git subtree pull --prefix pack/plugins/start/telescope https://github.com/nvim-telescope/telescope.nvim.git master --squash
git subtree pull --prefix pack/plugins/start/tree https://github.com/nvim-tree/nvim-tree.lua.git master --squash
git subtree pull --prefix pack/plugins/start/treesitter https://github.com/nvim-treesitter/nvim-treesitter.git master --squash
git subtree pull --prefix pack/plugins/start/treesitter-textobjects https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git master --squash
git subtree pull --prefix pack/plugins/start/vscode https://github.com/Mofiqul/vscode.nvim.git main --squash
git subtree pull --prefix pack/plugins/start/vsnip https://github.com/hrsh7th/vim-vsnip.git master --squash

