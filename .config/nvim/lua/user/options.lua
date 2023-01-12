local options = {

  fileencoding = "utf-8",
  backup = false,                          -- creates a backup file
  writebackup = false,                     -- make a backup before overwriting a file
  swapfile = false,                        -- creates a swapfile
  undofile = true,                         -- enable persistent undo
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  showtabline = 2,                         -- always show tabs
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                             -- display lines as one long line
  linebreak = true,                        -- companion to wrap, don't split words
  whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next line

  number = true,
  relativenumber = true,
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  
  shiftwidth = 4,                          -- the number of spaces inserted for each indentation
  tabstop = 4,                             -- insert 2 spaces for a tab
  expandtab = true,                        -- convert tabs to spaces
  smartindent = true,                      -- make indenting smarter again

  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  smartcase = true,                        -- smart case

  scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window

  pumheight = 10,                          -- pop up menu height
  timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 300,                        -- faster completion (4000ms default)
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp

  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  conceallevel = 0,                        -- so that `` is visible in markdown files
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.

