package.path = "../?.lua;" .. package.path

--[[
    try and test as many different u64 things to make sure walp handles them correctly
]]

WALP_DEBUG_PARSE_MODULE_FILEPATH = "../walp/debug_parser/target/wasm32-unknown-unknown/release/debug_parser.wasm"

local walp = require("walp.main")
local bindings = require("walp.common_bindings.lua_impl")

local module = walp.parse("target/wasm32-unknown-unknown/debug/u64_stress_test.wasm", true)

math.randomseed(os.time())

module.IMPORTS = {
    env = {
        print_u64 = function(n)
            print(n.l, n.h, n.l + n.h * 0x100000000)
        end,
        passthrough = function(x) return x end,
    }
}

bindings(module)

walp.instantiate(module)

module.EXPORTS.test.call()
