-- ================================== defaults ====================================
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
    enabled = true,
    pattern = "*.lua",
    timeout = 1000,
}

lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- =================================== 基本设置 ===================================
-- 颜色方案
-- wave | dragon | lotus
lvim.colorscheme = "kanagawa-wave"

-- 基于treesitter语法折叠
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- 打开文件默认不折叠代码
vim.opt.foldenable = false

-- =================================== 基本映射 ===================================
-- visual_mode使用jk退出会导致visual_mode模式j或者k连续选取时卡顿多处一行
lvim.keys.visual_mode["q"] = "<Esc>"
lvim.keys.insert_mode["jk"] = "<Esc>"

-- lvim.keys.insert_mode["<C-h>"] = "<Left>"
lvim.keys.insert_mode["<C-j>"] = "<Down>"
lvim.keys.insert_mode["<C-k>"] = "<Up>"
lvim.keys.insert_mode["<C-l>"] = "<Right>"

-- 左右切换buffer
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- 开启寄存器显示
lvim.builtin.which_key.setup.plugins.registers = true

-- ======================== toggleterm and telescope ==============================
-- 修改toggleterm显示位置，默认浮动float，这里改为屏幕正下方
lvim.builtin.terminal.direction = "horizontal"

-- telescope 弹窗鼠标移动
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
    -- insert mode
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<CR>"] = function()
            vim.cmd [[:stopinsert]]
            vim.cmd [[call feedkeys("\<CR>")]]
        end
    },
    -- normal mode
    n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
    },
}

-- terminal 键位映射，主要解决命令行无法退出insert mode问题
function _G.set_terminal_keymaps()
    vim.keymap.set('t', '<C-q>', [[<C-\><C-n>]], { buffer = 0 })
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- 只在toggleterm中生效
vim.cmd('autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()')

-- =================================== plugins =====================================
-- Additional Plugins
lvim.plugins = {
    -- colorscheme
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup {
                colors = {
                    palette = {
                        -- change all usages of these colors
                        waveBlue1 = "#2D4F67"
                    }
                }
            }
        end
    },
    -- translator
    { "voldikss/vim-translator" },
    -- colorizer
    { "norcalli/nvim-colorizer.lua" },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- 右下角lsp加载视图
    {
        "j-hui/fidget.nvim",
        tag = 'legacy',
        event = "LspAttach",
        opts = {},
    },
    -- rust-analyzer
    "simrat39/rust-tools.nvim",
    -- jdtls
    "mfussenegger/nvim-jdtls",
    {
        "saecki/crates.nvim",
        version = "v0.3.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup {
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            }
        end,
    },
    -- tmux
    { 'christoomey/vim-tmux-navigator' }
}

-- ===================================== rust ======================================
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

-- codellde codelldb调试适配器
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
local codelldb_adapter = {
    type = "server",
    port = "${port}",
    executable = {
        command = mason_path .. "bin/codelldb",
        args = { "--port", "${port}" },
        -- On windows you may have to uncomment this:
        -- detached = false,
    },
}

pcall(function()
    require("rust-tools").setup {
        tools = {
            executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
            reload_workspace_from_cargo_toml = true,
            runnables = {
                use_telescope = true,
            },
            inlay_hints = {
                auto = true,
                only_current_line = false,
                show_parameter_hints = false,
                parameter_hints_prefix = "<-",
                other_hints_prefix = "=>",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
            },
            hover_actions = {
                border = "rounded",
            },
            on_initialized = function()
                vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                    pattern = { "*.rs" },
                    callback = function()
                        local _, _ = pcall(vim.lsp.codelens.refresh)
                    end,
                })
            end,
        },
        dap = {
            adapter = codelldb_adapter,
        },
        server = {
            on_attach = function(client, bufnr)
                require("lvim.lsp").common_on_attach(client, bufnr)
                local rt = require "rust-tools"
                vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            end,

            capabilities = require("lvim.lsp").common_capabilities(),
            settings = {
                ["rust-analyzer"] = {
                    lens = {
                        enable = true,
                    },
                    checkOnSave = {
                        enable = true,
                        command = "clippy",
                    },
                },
            },
        },
    }
end)

-- rust debug配置
lvim.builtin.dap.on_config_done = function(dap)
    dap.adapters.codelldb = codelldb_adapter
    dap.configurations.rust = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                ---@diagnostic disable-next-line: redundant-parameter, param-type-mismatch
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = { "Cargo.lock" },
        },
    }
end

vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })

lvim.builtin.which_key.mappings["r"] = {
    name = "Rust",
    R = { "<cmd>RustRunnables<Cr>", "Runnables" },
    t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
    m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
    c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
    p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
    d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
    v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
    r = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "Reload Workspace",
    },
    o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
}

-- 开启.toml文件代码提示
require("lspconfig").taplo.setup {}

-- ==================================== java =======================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })


-- =================================== autocmd =====================================
-- comment.nvim : json => jsonc
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        vim.opt.filetype = "jsonc"
    end,
})
-- 复制时自动粘贴到windows剪切板
if vim.fn.has('wsl') then
    vim.cmd [[
  augroup Yank
  autocmd!
  autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
  augroup END
  ]]
end

-- ================================= translateW ===================================
vim.g['translator_proxy_url'] = 'socks5://127.0.0.1:1080'
lvim.builtin.which_key.mappings["t"] = {
    name = "vim-translator",
    c = { "<cmd>Translate<cr>", "translate in cmdline" },
    t = { "<cmd>TranslateW<cr>", "translate in popup" },
    r = { "<cmd>TranslateR<cr>", "Replace the text with translation" },
    x = { "<cmd>TranslateX<cr>", "translate in clipboard" },
}
lvim.keys.visual_mode["<leader>c"] = "<Plug>TranslateV<CR>"
lvim.keys.visual_mode["<leader>t"] = "<Plug>TranslateWV<CR>"
lvim.keys.visual_mode["<leader>r"] = "<Plug>TranslateRV<CR>"

-- ===================================== bug ======================================
-- nvimtree 修复打开文件对半分bug
lvim.builtin.nvimtree.setup.actions.open_file.resize_window = true

-- bug fix for colorizer
require('colorizer').setup()

-- lemminx cache location
require('lspconfig').lemminx.setup({
    settings = {
        xml = {
            server = {
                workDir = "~/.cache/lemminx",
            }
        }
    }
})
