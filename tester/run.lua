-- simulate that we are outside the walp folder
-- i certainly hope the walp folder is named "walp"
package.path = "../?.lua;" .. package.path

--[[
    this program just tests a bunch of random things that should always work
]]

WALP_DEBUG_PARSE_MODULE_FILEPATH = "../walp/debug_parser/target/wasm32-unknown-unknown/release/debug_parser.wasm"

local walp = require("walp.main")
local bindings = require("walp.common_bindings.lua_impl")

local module, err = walp.parse("target/wasm32-unknown-unknown/debug/tester.wasm", true)

if module == nil then
    print(err)
    return
end

module.IMPORTS = {
    env = {
        test_n = function(a, b, res, n, fail)
            if fail ~= 1 then
                io.write("test ", n, " succeded\n")
            else
                io.write("test ", n, " failed with a: ", a, " b: ", b, " res: ", res, "\n")
            end
        end
    }
}

bindings(module)

walp.instantiate(module)

module.EXPORTS.amain.call(true)
