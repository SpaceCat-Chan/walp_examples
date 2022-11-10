package.path = "../?.lua;" .. package.path

WALP_DEBUG_PARSE_MODULE_FILEPATH = "../walp/debug_parser/target/wasm32-unknown-unknown/release/debug_parser.wasm"

local walp = require("walp.main")

local module, err = walp.parse("test.wasm", true)

if module == nil then
    print(err)
    return
end

module.IMPORTS = {
    env = {
    }
}


walp.instantiate(module)

module.EXPORTS.memory.write64(1, { l = 0x08040201, h = 0x80402010 })
local loaded = module.EXPORTS.i64_load.call(true, 1)
print(string.format("loaded: 0x%X", loaded))
assert(loaded == 0x8040201008040201ULL, "i64_load failed")
print("i64_load succeded")

-- i64.load can now be trusted

module.EXPORTS.i64_store.call(true, 1, 0xFF7F3F1F0F070301ULL)
local stored = module.EXPORTS.i64_load.call(true, 1)
print(string.format("stored: 0x%X", stored))
assert(stored == 0xFF7F3F1F0F070301ULL, "i64_store failed")
print("i64_store succeded")
