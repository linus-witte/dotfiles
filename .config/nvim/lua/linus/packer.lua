-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use ({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			vim.cmd('colorscheme catppuccin-mocha')
		end
	})
	use {
		'nvim-treesitter/nvim-treesitter',
		{run = 'TSUpdate'}
	}

	use {
		'folke/todo-comments.nvim',
		as = "todo-comments",
		requires = { { 'nvim/lua/plenary.nvim' } }
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use {
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end
	}
	use 'mbbill/undotree'
	use 'tpope/vim-fugitive' -- Git integration
end)
