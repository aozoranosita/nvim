-- ==============================================================================
-- 1. 環境（OS）の判定
-- ==============================================================================
local is_mac = vim.fn.has('macunix') == 1
local is_wsl = vim.fn.has('wsl') == 1
local is_win = vim.fn.has('win32') == 1

-- 環境ごとの設定をテーブルで定義（if文の反復を排除）
local os_settings = {
    shell = is_mac and 'fish' or (is_wsl and 'fish' or 'powershell'),
    compiler = is_mac and 'clang' or 'gcc',
    latex_viewer = is_mac and 'open -a Skim' or 'SumatraPDF'
}

-- ==============================================================================
-- 2. General Settings
-- ==============================================================================
vim.bo.fileencoding = 'utf-8'
-- vim.o.fileencodings = 'sjis', 'utf-4'
vim.o.backup = false
vim.bo.swapfile = false
vim.o.autoread = true
vim.o.showcmd = true
vim.cmd('filetype plugin indent on')
vim.o.updatetime = 300
vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.o.laststatus = 2
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.showmode = true
vim.wo.cursorline = true
vim.bo.syntax = 'ON'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.bo.smartindent = true
vim.bo.autoindent = true
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.o.completeopt = 'menuone,noinsert' -- 修正: 文字列で連結
vim.o.mousemoveevent = true

-- OSごとの設定を反映
vim.o.shell = os_settings.shell
vim.opt.makeprg = os_settings.compiler

-- WSL クリップボード連携 (win32yank.exe を使用)
if is_wsl then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 0,
    }
end

-- ==============================================================================
-- 3. Keymaps (Basic)
-- ==============================================================================
vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ==============================================================================
-- 4. VSCode / Neovide / GUI Fonts
-- ==============================================================================
if vim.g.vscode then
    vim.g.vscode_style = 'dark'
    vim.g.vscode_transparent = true
    vim.g.vscode_italic_comment = true
    vim.g.vscode_italic_keywords = true
    vim.g.vscode_italic_functions = true
    vim.g.vscode_italic_variables = true
    vim.g.vscode_italic_booleans = true
    vim.g.vscode_italic_numbers = true
    vim.g.vscode_italic_strings = true
    vim.g.vscode_italic_types = true
    -- VSCode向け Lazy setup (省略可能ですが元のコードを維持)
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
    end
    vim.opt.rtp:prepend(lazypath)
else
    -- GUI Font (Windows/WSLでも使える一般的なNerdFontを指定)
    vim.o.guifont = 'Hack NF:h11'

    if vim.g.neovide then
        vim.g.neovide_refresh_rate = 60
        vim.g.neovide_refresh_rate_idle = 5
    end

    -- ==============================================================================
    -- 5. Plugins (Lazy.nvim)
    -- ==============================================================================
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
    end
    vim.opt.rtp:prepend(lazypath)

    local plugins = {
        { 'nvim-treesitter/nvim-treesitter', branch = 'main', build = ':TSUpdate' },
        { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
        { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons', opt = true } },
        { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }
        },
        'tpope/vim-commentary',
        'ryanoasis/vim-devicons',
        {
            'iamcco/markdown-preview.nvim',
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            build = "cd app && yarn install",
            init = function() vim.g.mkdp_filetypes = { "markdown" } end,
            ft = { "markdown" },
        },
        'lewis6991/gitsigns.nvim',
        'kevinhwang91/nvim-hlslens',
        { 'lervag/vimtex', lazy = false },
        'R-nvim/R.nvim',
        { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
            config = function()
                local cmp = require("cmp")

                cmp.setup({
                    snippet = {
                        expand = function(args)
                            -- LSPのsnippet展開に対応。
                            -- 現在は専用snippetエンジンを使っていないため、
                            -- snippet本文をそのまま展開する。
                            vim.snippet.expand(args.body)
                        end,
                    },
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                    }, {
                        { name = "buffer" },
                        { name = "path" },
                    }),
                    mapping = cmp.mapping.preset.insert({
                        ["<CR>"] = cmp.mapping.confirm({ select = false }),
                        ["<Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<C-j>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<C-k>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    }),
                })

            end,
        },
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate",
            opts = {},
        },
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = {
                "williamboman/mason.nvim",
                "neovim/nvim-lspconfig",
            },
            opts = {
                ensure_installed = { "basedpyright", "rust_analyzer" },
            },
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            },
            config = function()
                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                vim.lsp.config("basedpyright", {
                    capabilities = capabilities,
                })

                vim.lsp.config("rust_analyzer", {
                    capabilities = capabilities,
                })

                vim.lsp.enable({ "basedpyright", "rust_analyzer" })

                -- LSPの標準キーマップ。
                -- hoverは自動表示せず、Kで手動表示する。
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(event)
                        local opts = { buffer = event.buf, silent = true }

                        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    end,
                })
            end,
        },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            file_types = {'markdown'},
        },
    },
    {
      "hat0uma/csvview.nvim",
      ---@module "csvview"
      ---@type CsvView.Options
      opts = {
        parser = { comments = { "#", "//" } },
        keymaps = {
          -- Text objects for selecting fields
          textobject_field_inner = { "if", mode = { "o", "x" } },
          textobject_field_outer = { "af", mode = { "o", "x" } },
          -- Excel-like navigation:
          -- Use <Tab> and <S-Tab> to move horizontally between fields.
          -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
          -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
          jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
          jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
          jump_next_row = { "<Enter>", mode = { "n", "v" } },
          jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
        },
      },
      cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },
    }
    require('lazy').setup(plugins)

    -- ==============================================================================
    -- 6. Plugin Configurations
    -- ==============================================================================
    
    -- Colorscheme
    require('tokyonight').setup {}
    vim.cmd[[colorscheme tokyonight-night]]

    -- Neo-tree
    require('neo-tree').setup {
        filesystem = { filtered_items = { hide_dotfiles = false, hide_gitignored = false, hide_hidden = false } }
    }

    -- Bufferline
    require('bufferline').setup{
        options = {
            separator_style = "slant",
            hover = { enabled = true, delay = 0, reveal = { 'close' } },
            offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left", separator = true } },
        },
    }

    -- Lualine
    require('lualine').setup {
        options = { icons_enabled = true, theme = 'tokyonight', globalstatus = true }
    }

    -- Treesitter
    -- Treesitter (main branch API)
    require('nvim-treesitter').setup {}
    require('nvim-treesitter').install({ "python", "rust", "r", "lua", "markdown", "markdown_inline", "yaml", "comment" })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python', 'rust', 'r', 'lua', 'markdown', 'yaml' }, -- latexは除外
        callback = function()
            vim.treesitter.start()
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })
    require('gitsigns').setup()
    require('hlslens').setup()

    -- Vimtex (OSごとの設定を適用)
    vim.g.vimtex_view_general_viewer = os_settings.latex_viewer
    vim.g.vimtex_compiler_latexmk_engines = { _ = '-lualatex' }
    vim.g.vimtex_compiler_latexmk = {
        options = { '-shell-escape', '-synctex=1', '-interaction=nonstopmode' }
    }
    
    -- WSL特有のVimtex設定 (WSLからWindowsのSumatraPDFを呼ぶための調整)
    if is_wsl then
        vim.g.vimtex_view_general_viewer = 'SumatraPDF.exe'
        -- WSLパスからWindowsパスへの変換オプション
        vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
    end

    -- Fzf-lua
    require'fzf-lua'.setup({
        'fzf-native',
        winopts = { height = 0.85, width = 0.80, row = 0.35, col = 0.50, border = 'rounded', fullscreen = false },
    })

    vim.cmd [[
        highlight FzfLuaNormal guibg=#383850
        highlight FzfLuaBorder guibg=#383850
    ]]
    vim.opt.winblend = 5


    -- ==============================================================================
    -- 8. Auto Commands
    -- ==============================================================================
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.expandtab = true
        end
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "r",
        callback = function()
            vim.keymap.set('i', '<C-,>', ' <- ', { buffer = true })
            vim.keymap.set('i', '<C-.>', ' |> ', { buffer = true })
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true
        end
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "csv",
        callback = function()
            vim.cmd('CsvViewEnable')
        end,
    })

    -- ==============================================================================
    -- 9. Keymaps (Normal / Visual)
    -- ==============================================================================
    local normal_maps = {
        { ']b', ':bnext<CR>' },
        { '[b', ':bprev<CR>' },
        { 'M-v', '<C-v>' },
        { '<C-s>', ':MarkdownPreview<CR>' },
        { '<M-s>', ':MarkdownPreviewStop<CR>' },
        { '<C-p>', ':MarkdownPreviewToggle<CR>' },
        { '<leader>v', '"+p' },
        { '<space>e', ':Neotree<CR>' },
        { '<F5>', ':!uv run python %<CR>' },
        { '<leader>f', "<cmd>lua require('fzf-lua').files()<CR>" },
        { '<leader>g', "<cmd>lua require('fzf-lua').git_status()<CR>" },
        { '<leader>b', "<cmd>lua require('fzf-lua').git_branches()<CR>" },
        { '<leader>p', "<cmd>lua require('fzf-lua').grep()<CR>" },
        { '<leader>/', "<cmd>lua require('fzf-lua').blines()<CR>" },
        { '<leader>e', "<cmd>lua vim.diagnostic.open_float()<CR>" },
        { '<C-h>', ':vertical resize +5<CR>' },
        { '<C-j>', ':resize +5<CR>' },
        { 'n', "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>" },
        { 'N', "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>" },
        { '*', "*<Cmd>lua require('hlslens').start()<CR>" },
        { '#', "#<Cmd>lua require('hlslens').start()<CR>" },
        { 'g*', "g*<Cmd>lua require('hlslens').start()<CR>" },
        { 'g#', "g#<Cmd>lua require('hlslens').start()<CR>" },
    }

    for _, map in ipairs(normal_maps) do
        vim.keymap.set('n', map[1], map[2], { silent = true })
    end

    local visual_maps = {
        { '<leader>c', '"+y' },
        { '<leader>v', '"+p' },
    }

    for _, map in ipairs(visual_maps) do
        vim.keymap.set('v', map[1], map[2], { silent = true })
    end
end

