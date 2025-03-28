-- General
vim.bo.fileencoding = 'utf-8'
-- vim.o.fileencodings = 'sjis', 'utf-8'
vim.o.backup = false
vim.bo.swapfile = false
vim.o.autoread = true
vim.o.showcmd = true
vim.cmd 'filetype plugin indent on'
vim.o.updatetime = 300
vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.laststatus = 2
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.showmode = false
vim.wo.cursorline = true
vim.bo.syntax = 'ON'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.bo.smartindent = true
vim.bo.autoindent = true
vim.bo.tabstop = 8
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false
vim.o.completeopt = 'menuone', 'noinsert'
vim.o.mousemoveevent = true

vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.shell = '/bin/fish'

-- gui
vim.o.guifont = 'PlemolJP Console NF:h13'
if vim.g.neovide then
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_refresh_rate_idle = 5
end

--
-- plugins
--

-- Lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
    	'nvim-lualine/lualine.nvim',
    	dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
    {
	'neoclide/coc.nvim', branch = 'release',
	dependencies = {
	    'pappasam/coc-jedi',
	}
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
        }
    },
    'tpope/vim-commentary',
    'ryanoasis/vim-devicons',
    {
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    'lewis6991/gitsigns.nvim',
    'kevinhwang91/nvim-hlslens',
    'cdelledonne/vim-cmake',
    'github/copilot.vim',
    {
	'lervag/vimtex',
	lazy = false,
    },
    {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
	},
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {},
    },
    'R-nvim/R.nvim',
    'R-nvim/cmp-r',
    {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {}
    },
    {
	"hrsh7th/nvim-cmp",
	config = function()
	  local cmp = require("cmp")
	  cmp.setup({
	    sources = {{ name = "cmp_r" }},
	    mapping = cmp.mapping.preset.insert({
	      ['<CR>'] = cmp.mapping.confirm({ select = false }),
	      ['<Tab>'] = cmp.mapping(function(fallback)
		  if cmp.visible() then
		    cmp.select_next_item()
		  else
		    fallback()
		  end
		end, { 'i', 's' }),

		['<S-Tab>'] = cmp.mapping(function(fallback)
		  if cmp.visible() then
		    cmp.select_prev_item()
		  else
		    fallback()
		  end
		end, { 'i', 's' }),
	    }),
	  })
	  require("cmp_r").setup({ })
	end,
    },
}

require('lazy').setup(plugins)

-- colorscheme
require('tokyonight').setup {}
vim.cmd[[colorscheme tokyonight-night]]
require('neo-tree').setup {
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
        }
    },
}

require('bufferline').setup{
    options = {
        separator_style = "slant",
        hover = {
            enabled = true,
            delay = 0,
            reveal = { 'close' },
        },
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
                separator = true,
            }
        },
    },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    globalstatus = true,
  }
}

-- vim-cmake
vim.api.nvim_command('command! CCMakeGenerate execute "!cmake -DCMAKE_BUILD_TYPE=Debug -G Ninja -B build" | execute "!cp ./build/compile_commands.json ./"')
vim.api.nvim_command('command! CCMakeBuild execute "!cmake --build build"')
vim.cmd "autocmd FileType c,cpp nnoremap <silent> <F7> :CCMakeBuild<CR>"

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
    },
}

require('gitsigns').setup()

-- hlsearch
require('hlslens').setup()

-- vimtex (Mac 用にビューアを変更)
vim.g.vimtex_view_general_viewer = 'open -a Skim'
vim.g.vimtex_compiler_latexmk_engines = { _ = '-lualatex' }
vim.g.vimtex_compiler_latexmk = {
    options = {
        '-shell-escape',
        '-synctex=1',
        '-interaction=nonstopmode',
    }
}

local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- C/C++ (Mac 用の設定例：clang を使用)
if vim.fn.has('macunix') == 1 then
    vim.cmd('set makeprg=clang')
end

--
-- Coc
-- 
local keyset = vim.keymap.set
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : "<Tab>"', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

vim.cmd("command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument")

--
-- Key Maps
--
vim.api.nvim_set_keymap('i', '<CR>', '<C-y>', { noremap = true })
vim.cmd 'inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\\<CR>"'
vim.cmd [[inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>" ]]
vim.api.nvim_set_keymap('n', ']b', ':bnext<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '[b', ':bprev<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'M-v', '<C-v>', { noremap = true })
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-s>', ':MarkdownPreview<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<M-s>', ':MarkdownPreviewStop<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':MarkdownPreviewToggle<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { silent = true, noremap = true }) 
vim.api.nvim_set_keymap('n', '<leader>v', '"+p', { silent = true, noremap = true }) 
vim.api.nvim_set_keymap('v', '<leader>v', '"+p', { silent = true, noremap = true }) 
vim.api.nvim_set_keymap('n', '<space>e', ':Neotree<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<F5>', ':!uv run python %<CR>', { silent = false, noremap = true })

---
--- Modify tab settings for LaTeX
---
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
    end
})

-- fzf-lua setup
require'fzf-lua'.setup({
  'fzf-native',
  winopts = {
    height     = 0.85,
    width      = 0.80,
    row        = 0.35,
    col        = 0.50,
    border     = 'rounded',
    fullscreen = false,
  },
})

vim.cmd [[
highlight FzfLuaNormal guibg=#383850
highlight FzfLuaBorder guibg=#383850
]]

vim.opt.winblend = 5

vim.keymap.set('n', '<leader>e', "<cmd>lua require('fzf-lua').files()<CR>")
vim.keymap.set('n', '<leader>g', "<cmd>lua require('fzf-lua').git_status()<CR>")
vim.keymap.set('n', '<leader>b', "<cmd>lua require('fzf-lua').git_branches()<CR>")
vim.keymap.set('n', '<leader>p', "<cmd>lua require('fzf-lua').grep()<CR>")
vim.keymap.set('n', '<leader>/', "<cmd>lua require('fzf-lua').blines()<CR>")

