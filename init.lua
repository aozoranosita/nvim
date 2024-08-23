--
-- General
--
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
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 8
vim.bo.expandtab = true
vim.o.completeopt = 'menuone', 'noinsert'
vim.o.mousemoveevent = true

-- gui
vim.o.guifont = 'PlemolJP Console NF:h9'
if vim.g.neovide then
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_refresh_rate_idle = 5
end

-- clipboard
if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = {
        name = 'win32yank_wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = true,
    }
end

-- terminal on Windows
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.o.shell = "pwsh.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
	vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
	vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

-- python, ruby, perl
if vim.fn.has('wsl') == 1 then
    vim.g.python3_host_prog ="python3"
    vim.cmd 'let g:loaded_perl_provider = 0'
end
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.g.python3_host_prog ="python.exe"
    vim.cmd 'let g:loaded_ruby_provider = 0'
    vim.cmd 'let g:loaded_perl_provider = 0'
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
    { 'neoclide/coc.nvim', branch = 'release' },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
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
    -- 'LuaLS/lua-language-server',
    'cdelledonne/vim-cmake',
    'pappasam/coc-jedi',
}
if (vim.fn.has('wsl') == 1) then
    table.insert(plugins, {
        'lervag/vimtex',
        'github/copilot.vim',
    })
end
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    table.insert(plugins, {
    })
end

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
vim.cmd "autocmd FileType c,cpp nnoremap <silent> <F7> :CMakeBuild<CR>"
vim.cmd "autocmd FileType c,cpp nnoremap <silent> <leader>cq :CMakeClose<CR>"

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    sync_install = false,
    auto_install = true,
    ignore_install = {  },
    highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
    },
}

require('gitsigns').setup()

-- hlsearch
require('hlslens').setup()

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

-- vim.api.nvim_set_keymap('n', '<Leader>nh', '<Cmd>noh<CR>', kopts)

--
-- Coc
-- 
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : "<Tab>"', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- Make <CR> to accept selected completion item or notify coc.nvim to format
keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

-- coc-prettier
vim.cmd("command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument")

-- VimTeX
if vim.fn.has('wsl') == 1 then
    vim.g.vimtex_view_general_viewer = 'SumatraPDF.exe'
    vim.g.vimtex_compiler_latexmk_engines = { _ = '-lualatex' }
    -- Cited from https://qiita.com/sff1019/items/cb8cae96a1f7026656fc
    vim.g.vimtex_compiler_latexmk = {
        options = {
            '-shell-escape'
        }
    }
end


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
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { silent=true, noremap=true }) 
vim.api.nvim_set_keymap('n', '<leader>v', '"+p', { silent=true, noremap=true }) 
vim.api.nvim_set_keymap('v', '<leader>v', '"+p', { silent=true, noremap=true }) 
vim.api.nvim_set_keymap('n', '<space>e', ':Neotree<CR>', { silent=true, noremap=true })

