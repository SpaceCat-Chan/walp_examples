-- simulate that we are outside the walp folder
-- i certainly hope the walp folder is named "walp"
package.path = "../?.lua;" .. package.path

--[[
    this program runs 100 iterations of The Game of Life on a 16x16 looping grid
]]

WALP_DEBUG_PARSE_MODULE_FILEPATH = "../walp/debug_parser/target/wasm32-unknown-unknown/release/debug_parser.wasm"

local walp = require("walp.main")
local bindings = require("walp.common_bindings.lua_impl")

local module = walp.parse("target/wasm32-unknown-unknown/release/wasm_gol_lua.wasm", true)

math.randomseed(os.time())

module.IMPORTS = {
    env = {
        print_u64 = function(n)
            print(n.l, n.h, n.l + n.h * 0x100000000)
        end,
        passthrough = function(x) return x end,
        i_take_a_break = function()
            -- do nothing on 5.2, coroutine.yield on CC
            if _G._HOST then
                coroutine.yield()
            end
        end
    }
}

bindings(module)

walp.instantiate(module)

module.EXPORTS.amain.call()
