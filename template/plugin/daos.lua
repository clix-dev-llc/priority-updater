-- capture original plugin name, and new priority from filename
local this_module_name = ({...})[1]
local plugin_name, priority = this_module_name:match("^kong%.plugins%.([^%.]-)_(%d+)%.daos$")
if not plugin_name or not priority then
  error("Plugin file must be named '..../kong/plugins/<name>_<priority>/daos.lua', got: " .. tostring(({...})[1]))
end

local module_name = "kong.plugins." .. plugin_name .. ".daos"

if package.loaded[module_name] then
  -- the daos file should be loaded only once, so error out as if the module wasn't found
  -- error must match exactly, since the loader validates it
  return error("module '" .. this_module_name .. "' not found")
end

-- if this fails because it doesn't exist, it is identical to the original
-- failing, so the error indicates it's not there
local daos = require("kong.plugins." .. plugin_name .. ".daos")

-- what if the original plugin is loaded after this one?
package.loaded[module_name] = {}   -- make it empty! no new daos will be added, by anyone after us

return daos
