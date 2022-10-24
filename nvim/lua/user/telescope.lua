local telescope_found, telescope = pcall(require, "telescope")
if not telescope_found then
  return
end

local actions = require "telescope.actions"


--telescope.load_extension('media_files')

telescope.setup {
}

