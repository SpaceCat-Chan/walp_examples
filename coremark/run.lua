package.path = "../?.lua;" .. package.path

--[[
    this is the coremark benchmark ported to wasm
    fun
]]

WALP_DEBUG_PARSE_MODULE_FILEPATH = "../walp/debug_parser/target/wasm32-unknown-unknown/release/debug_parser.wasm"

local walp = require("walp.main")

local bit = require("walp.bitops")

local module, err = walp.parse("coremark-minimal.wasm", true)

if module == nil then
    print(err)
    return
end

module.IMPORTS = {
    env = {
        clock_ms = function()
            if module.compile_settings.use_magic_bytecode_jit then
                return bit.to_u64(math.floor(os.clock() * 1000))
            else
                return {h = 0, l = math.floor(os.clock() * 1000)}
            end
        end
    }
}


walp.instantiate(module)

local should_compile = (args or { ... })[1] == "compile"
module.compile_settings.use_magic_bytecode_jit = should_compile

print(module.EXPORTS.run.call())
