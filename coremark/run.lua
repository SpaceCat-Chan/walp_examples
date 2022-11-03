package.path = "../?.lua;" .. package.path

--[[
    this is the coremark benchmark ported to wasm
    fun
]]

WALP_DEBUG_PARSE_MODULE_FILEPATH = "../walp/debug_parser/target/wasm32-unknown-unknown/release/debug_parser.wasm"

local walp = require("walp.main")

local module, err = walp.parse("coremark-minimal.wasm", true)

if module == nil then
    print(err)
    return
end

module.IMPORTS = {
    env = {
        clock_ms = function()
            return math.floor(os.clock() * 1000)
        end
    }
}


walp.instantiate(module)

module.EXPORTS.run.call()
