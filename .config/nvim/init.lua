-- Basic Vim Settings

-- Encoding
vim.o.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'

-- Display
vim.o.ambiwidth = 'double'
vim.o.number = true
vim.o.cursorline = true
vim.o.list = true
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.showmatch = true
vim.o.title = false
vim.o.wrap = false

-- Indentation
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.softtabstop = 0
vim.o.shiftround = true
vim.o.autoindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.wrapscan = true

-- Edit
vim.o.infercase = true
vim.o.hidden = true
vim.o.backspace = 'indent,eol,start'
vim.o.formatoptions = vim.o.formatoptions:gsub('[ro]', '')

-- File
vim.o.fileformats = 'unix,dos,mac'

-- Window
vim.o.splitright = true

-- Folding
vim.o.foldenable = false

-- Path Settings

local function include_path(path)
  local expanded_path = vim.fn.expand(path)
  if vim.fn.isdirectory(expanded_path) == 1 then
    local delimiter = vim.fn.has('win32') == 1 and ';' or ':'
    local pathlist = vim.split(vim.env.PATH, delimiter)
    local found = false
    for _, p in ipairs(pathlist) do
      if p == expanded_path then
        found = true
        break
      end
    end
    if not found then
      vim.env.PATH = expanded_path .. delimiter .. vim.env.PATH
    end
  end
end

-- Python
include_path('$HOME/.pyenv/shims')
vim.g.python_host_prog = vim.fn.expand('$PYENV_ROOT') .. '/shims/python2'

local pyenv_neovim_env = vim.fn.expand('$HOME/.pyenv/versions/neovim-env')
if vim.fn.isdirectory(pyenv_neovim_env) == 1 then
  vim.g.python3_host_prog = pyenv_neovim_env .. '/bin/python'
else
  vim.g.python3_host_prog = vim.fn.expand('$PYENV_ROOT') .. '/shims/python3'
end

-- Golang
vim.o.runtimepath = vim.o.runtimepath .. ',$HOME/go/src/golang.org/x/lint/misc/vim'

-- Plugin Manager (lazy.nvim)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local choice = vim.fn.confirm(
    'lazy.nvim is not installed. Install it now?',
    '&Yes\n&No',
    1
  )
  if choice == 1 then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
    print('lazy.nvim has been installed!')
  else
    print('lazy.nvim installation cancelled.')
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins

require('lazy').setup({
  -- Fuzzy finder
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Statusline
  {
    'itchyny/lightline.vim',
    config = function()
      vim.g.lightline = {
        colorscheme = 'wombat',
        active = {
          left = {
            { 'mode', 'paste' },
            { 'fugitive', 'gitgutter', 'readonly', 'filename', 'modified', 'anzu' }
          }
        },
        component = {
          readonly = '%{&readonly?"x":""}',
        },
        component_function = {
          anzu = 'anzu#search_status',
          fugitive = 'MyFugitive',
          gitgutter = 'MyGitGutter'
        },
        separator = { left = '\u{2b80}', right = '\u{2b82}' },
        subseparator = { left = '\u{2b81}', right = '\u{2b83}' }
      }
    end,
  },

  -- Search status
  'osyo-manga/vim-anzu',

  -- Colorscheme
  'nanotech/jellybeans.vim',

  -- Easy motion
  'easymotion/vim-easymotion',

  -- Syntax highlighting and indentation
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Install parsers
      require('nvim-treesitter').install({ 'python', 'go', 'lua', 'vim', 'vimdoc', 'markdown', 'json', 'kotlin', 'swift' })
    end,
  },

  -- Go
  {
    'fatih/vim-go',
    ft = 'go',
  },

  -- API Blueprint
  'kylef/apiblueprint.vim',

  -- Markdown
  'plasticboy/vim-markdown',

  -- Color preview
  'chrisbra/Colorizer',

  -- Quick run
  'thinca/vim-quickrun',

  -- Git
  'airblade/vim-gitgutter',
  'tpope/vim-fugitive',

  -- Swift
  {
    'keith/swift.vim',
    ft = 'swift',
  },

  -- Completion
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },
})

-- Plugin Settings

-- vim-anzu
vim.keymap.set('n', 'n', '<Plug>(anzu-n-with-echo)')
vim.keymap.set('n', 'N', '<Plug>(anzu-N-with-echo)')
vim.keymap.set('n', '*', '<Plug>(anzu-star-with-echo)')
vim.keymap.set('n', '#', '<Plug>(anzu-sharp-with-echo)')
vim.keymap.set('n', '<Esc><Esc>', '<Plug>(anzu-clear-search-status)')
vim.o.statusline = '%{anzu#search_status()}'

-- vim-easymotion
vim.keymap.set('n', ';;w', '<Plug>(easymotion-w)', {})
vim.keymap.set('n', ';;b', '<Plug>(easymotion-b)', {})
vim.keymap.set('n', ';;e', '<Plug>(easymotion-e)', {})
vim.keymap.set('n', ';;ge', '<Plug>(easymotion-ge)', {})
vim.keymap.set('n', ';;f', '<Plug>(easymotion-f)', {})
vim.keymap.set('n', ';;F', '<Plug>(easymotion-F)', {})
vim.keymap.set('n', ';;t', '<Plug>(easymotion-t)', {})
vim.keymap.set('n', ';;T', '<Plug>(easymotion-T)', {})
vim.keymap.set('n', ';;s', '<Plug>(easymotion-s)', {})
vim.keymap.set('n', ';;j', '<Plug>(easymotion-j)', {})
vim.keymap.set('n', ';;k', '<Plug>(easymotion-k)', {})

-- fzf-lua
vim.keymap.set('n', '<C-p>', '<cmd>lua require("fzf-lua").files()<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>ff', '<cmd>lua require("fzf-lua").files()<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>lua require("fzf-lua").live_grep()<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>lua require("fzf-lua").buffers()<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>lua require("fzf-lua").help_tags()<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', '<cmd>lua require("fzf-lua").oldfiles()<CR>', { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fc', '<cmd>lua require("fzf-lua").git_commits()<CR>', { desc = 'Git commits' })
vim.keymap.set('n', '<leader>fs', '<cmd>lua require("fzf-lua").git_status()<CR>', { desc = 'Git status' })

-- vim-go
vim.g.go_gocode_unimported_packages = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_structs = 1
vim.g.go_fmt_command = 'goimports'

-- quickrun
-- Build python config with the resolved python3 path
local python_command = vim.g.python3_host_prog or 'python3'

vim.g.quickrun_config = {
  _ = {
    outputter = 'buffer',
    ['outputter/buffer/split'] = ':botright 8sp',
    ['outputter/buffer/close_on_empty'] = 1,
    ['hook/time/enable'] = 1,
  },
  python = {
    command = python_command,
  },
  go = {
    ['outputter/buffer/split'] = 'vertical',
  },
}

vim.keymap.set('n', '<C-c>', function()
  if vim.fn['quickrun#is_running']() then
    return vim.fn['quickrun#sweep_sessions']()
  else
    return '<C-c>'
  end
end, { expr = true, silent = true })
vim.keymap.set('n', '<F5>', ':QuickRun -mode n<CR>', { silent = true })
vim.keymap.set('v', '<F5>', ':QuickRun -mode v<CR>', { silent = true })

-- LSP Configuration

-- Python (pylsp)
-- Install: pip install python-lsp-server python-lsp-server[all]
-- Use the same Python environment as python3_host_prog
local pylsp_cmd = 'pylsp'
local pyenv_neovim_env = vim.fn.expand('$HOME/.pyenv/versions/neovim-env')
if vim.fn.isdirectory(pyenv_neovim_env) == 1 then
  local pylsp_path = pyenv_neovim_env .. '/bin/pylsp'
  if vim.fn.executable(pylsp_path) == 1 then
    pylsp_cmd = pylsp_path
  end
end

vim.lsp.config.pylsp = {
  cmd = { pylsp_cmd },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' },
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
      }
    }
  }
}

-- Go (gopls)
-- Install: go install golang.org/x/tools/gopls@latest
vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- Enable LSP servers
vim.lsp.enable({ 'pylsp', 'gopls' })

-- LSP keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

-- Diagnostic display settings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic signs
local signs = { Error = "✗", Warn = "!", Hint = "➤", Info = "i" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- nvim-treesitter: Enable highlighting and indentation
autocmd('FileType', {
  pattern = { 'python', 'go', 'lua', 'vim', 'markdown', 'json', 'kotlin', 'swift' },
  callback = function()
    -- Only enable treesitter if parser is available
    local ok = pcall(vim.treesitter.start)
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Tera templates
autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.tera',
  command = 'setlocal ft=html',
})

-- Colorscheme

vim.cmd.colorscheme('jellybeans')

-- Custom Functions (for lightline)

function _G.MyFugitive()
  if vim.fn.exists('*fugitive#head') == 1 then
    return vim.fn['fugitive#head']()
  else
    return ''
  end
end

function _G.MyGitGutter()
  if vim.fn.exists('*GitGutterGetHunkSummary') == 1 then
    local summary = vim.fn.GitGutterGetHunkSummary()
    return string.format('+%d ~%d -%d', summary[1], summary[2], summary[3])
  else
    return ''
  end
end
