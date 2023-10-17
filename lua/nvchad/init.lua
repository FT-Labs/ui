local new_cmd = vim.api.nvim_create_user_command
local config = require("core.utils").load_config().ui

vim.opt.statusline = "%!v:lua.require('nvchad.statusline." .. config.statusline.theme .. "').run()"

if config.tabufline.enabled then
  require "nvchad.tabufline.lazyload"
end


-- redraw dashboard on VimResized event
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    if vim.bo.filetype == "nvdash" then
      vim.opt_local.modifiable = true
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
      require("nvchad.nvdash").open()
    elseif vim.bo.filetype == "nvcheatsheet" then
      vim.opt_local.modifiable = true
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
      require("nvchad.cheatsheet." .. config.cheatsheet.theme)()
    end
  end,
})

-- redraw statusline on LspProgressUpdate event & fixes #145
vim.api.nvim_create_autocmd("User", {
  pattern = "LspProgressUpdate",
  callback = function()
    vim.cmd "redrawstatus"
  end,
})
