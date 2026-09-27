-- Basic
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.clipboard:append("unnamed")
opt.number = true
opt.hlsearch = true
opt.smartindent = true
opt.wildmenu = true
opt.ruler = true

opt.tabstop = 2
opt.shiftwidth = 2

opt.cursorline = true
opt.title = true
opt.helplang = "ja"
opt.shell = "zsh"
opt.ambiwidth = "double"

opt.termguicolors = true

-- Blade filetype detection
vim.filetype.add({
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
})

-- Treesitter非対応ファイルなどのフォールバック
vim.cmd("syntax enable")

-- Leader / command

-- :s と入力したとき %s///g を展開
vim.cmd([[
  cnoreabbrev <expr> s
        \ (getcmdtype() ==# ':' && getcmdline() ==# 's')
        \ ? '%s///g<Left><Left>'
        \ : 's'
]])

-- Keymaps

local map = vim.keymap.set
local silent = { silent = true }

-- Alt + j/k で行を上下移動
map("n", "<A-j>", ":m .+1<CR>==", silent)
map("n", "<A-k>", ":m .-2<CR>==", silent)

map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", silent)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", silent)

map("x", "<A-j>", ":m '>+1<CR>gv=gv", silent)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", silent)

-- ウィンドウ移動
map("n", "sj", "<C-w>j")
map("n", "sk", "<C-w>k")
map("n", "sl", "<C-w>l")
map("n", "sh", "<C-w>h")

-- 分割
map("n", "ss", "<cmd>split<CR><C-w>j")
map("n", "sv", "<cmd>vsplit<CR><C-w>l")

-- x を切り取りではなく削除にする
map("n", "x", '"_x')
map("x", "x", '"_x')

-- バッファ移動
map("n", "<C-p>", "<cmd>bprevious<CR>", silent)
map("n", "<C-n>", "<cmd>bnext<CR>", silent)

-- ターミナルモードを抜ける
map("t", "<C-c>", "<C-\\><C-n>")

-- Terminal commands

vim.cmd([[
  command! -nargs=* Term split | terminal <args>
  command! -nargs=* Termv vsplit | terminal <args>
]])

-- Coc

vim.g.coc_global_extensions = {
  "coc-eslint",
  "coc-tsserver",
  "coc-prettier",
  "coc-git",
  "coc-html",
  "coc-css",
  "coc-phpls",
  "coc-blade",
  "@yaegassy/coc-volar",
  "@yaegassy/coc-tailwindcss3",
}

-- nvim-tree preparation

-- nvim-treeを使うので標準netrwを無効化
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("lazy.nvim のインストールに失敗しました:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Plugins

require("lazy").setup({

  -- Colorscheme

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,

    config = function()
      vim.g.gruvbox_material_cursor = "orange"
      vim.g.gruvbox_material_foreground = "soft"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_menu_selection_background = "green"
      vim.g.gruvbox_material_transparent_background = 1

      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -- Coc

  {
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false,
  },

  -- Treesitter

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
		build = ":TSUpdate",
  },

	-- Markdown rendering

	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = false,

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},

		init = function()
			vim.g.render_markdown_config = {
				sign = {
					enabled = false,
				},
			}
		end,
	},

	-- Indent / code chunk highlight

	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			require("hlchunk").setup({
				indent = {
					enable = true,
				},

				chunk = {
					enable = true,
				},
			})
		end,
	},

	-- ウィンドウサイズ調整

	{
		"simeji/winresizer",
	},

	-- File tree

	{
		"nvim-tree/nvim-tree.lua",

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		keys = {
			{
				"<C-f>",
				"<cmd>NvimTreeToggle<CR>",
				desc = "File Tree",
			},
			{
				"<leader>b",
				"<cmd>NvimTreeToggle<CR>",
				desc = "File Tree",
			},
		},

		opts = {
			view = {
				width = 32,
			},

			renderer = {
				group_empty = true,
			},

			filters = {
				dotfiles = false,
			},

			update_focused_file = {
				enable = true,
				update_root = false,
			},
		},
	},

	-- Statusline / Buffer line

	{
		"nvim-lualine/lualine.nvim",
		lazy = false,

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = true,
					always_show_tabline = true,
				},

				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },

					lualine_x = {
						"g:coc_status",
						"encoding",
						"fileformat",
						"filetype",
					},

					lualine_y = { "progress" },
					lualine_z = { "location" },
				},

				tabline = {
					lualine_a = {
						{
							"buffers",
							mode = 2,
							show_filename_only = true,
							show_modified_status = true,

							symbols = {
								modified = " ●",
								alternate_file = "",
								directory = "",
							},
						},
					},

					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},

				extensions = {
					"nvim-tree",
					"fzf",
				},
			})

			-- 以前の Airline の Space + 1〜9 を再現

			for i = 1, 9 do
				local index = i

				map(
					"n",
					"<leader>" .. index,
					"<cmd>LualineBuffersJump " .. index .. "<CR>",
					{ silent = true, desc = "Buffer " .. index }
				)
			end
		end,
	},

	-- FZF

	{
		"junegunn/fzf",
	},

	{
		"junegunn/fzf.vim",

		dependencies = {
			"junegunn/fzf",
		},

		cmd = {
			"Files",
			"GFiles",
			"Rg",
			"Buffers",
		},

		keys = {
			{
				"<leader>f",
				"<cmd>Files<CR>",
				desc = "Find File",
			},

			{
				"<leader>w",
				"<cmd>Rg<CR>",
				desc = "Find Word",
			},
		},
	},

	-- Japanese help

	{
		"vim-jp/vimdoc-ja",
		lazy = false,
	},

})

-- Treesitter

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",

	callback = function()
		local ok = pcall(vim.treesitter.start)

		if ok then
			vim.bo.indentexpr =
			"v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
