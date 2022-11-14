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

local function run_tests(tests)
    local passed_tests = {}
    local passed_test_count = 0
    local failed_tests = {}
    local ignored_test_count = 0
    for _, test in ipairs(tests) do
        local should_do_test = true
        if test.relies_on then
            for _, must_pass in pairs(test.relies_on) do
                should_do_test = should_do_test and passed_tests[must_pass] ~= nil
            end
        end
        if should_do_test then
            if test.meta_test then
                passed_tests[test.name] = true
            else
                local success, message = test.run()
                if success then
                    passed_tests[test.name] = true
                    passed_test_count = passed_test_count + 1
                else
                    table.insert(failed_tests, { test = test, message = message })
                end
            end
        else
            if not test.meta_test then
                ignored_test_count = ignored_test_count + 1
            end
        end
    end
    if ignored_test_count == 1 then
        print("skipped 1 test")
    else
        print(string.format("skipped %i tests", ignored_test_count))
    end
    if passed_test_count == 1 then
        print("passed 1 test")
    else
        print(string.format("passed %i tests", passed_test_count))
    end
    if #failed_tests == 1 then
        print("failed 1 test")
    else
        print(string.format("failed %i tests", #failed_tests))
    end
    for _, test in pairs(failed_tests) do
        print(("failed test %s: %s"):format(test.test.name, test.message))
    end
end

local tests = {
    {
        name = "local.get i32",
        run = function()
            local res = module.EXPORTS.local_get_i32.call(true, 123456)
            return res == 123456, ("got: %i, expected: 123456"):format(res)
        end
    },
    {
        name = "local.get i64",
        run = function()
            local res = module.EXPORTS.local_get_i64.call(true, 0x21000B3A7396492EULL)
            return res == 0x21000B3A7396492EULL, ("got: %i, expected: 0x21000B3A7396492E"):format(res)
        end
    },
    {
        name = "local.get f32",
        run = function()
            local res = module.EXPORTS.local_get_f32.call(true, 123.55)
            return res == 123.55, ("got: %f, expected: 123.55"):format(res)
        end
    },
    {
        name = "local.get f64",
        run = function()
            local res = module.EXPORTS.local_get_f64.call(true, 123.55)
            return res == 123.55, ("got: %f, expected: 123.55"):format(res)
        end
    },
    {
        name = "local.get",
        meta_test = true,
        relies_on = { "local.get i32", "local.get i64", "local.get f32", "local.get f64" }
    },
    {
        name = "i32.const",
        run = function()
            local res = module.EXPORTS.i32_const.call(true)
            return res == 143723548, ("got: %i, expected: 143723548"):format(res)
        end
    },
    {
        name = "i64.const",
        run = function()
            local val = module.EXPORTS.i64_const.call(true)
            return val == 0xFEDCBA9876543210ULL, ("got 0x%X, expected 0xFEDCBA9876543210"):format(val)
        end
    },
    {
        name = "f32.const",
        run = function()
            local res = module.EXPORTS.f32_const.call(true)
            return res == 123.5, ("got: %f, expected: 123.5"):format(res)
        end
    },
    {
        name = "f64.const",
        run = function()
            local res = module.EXPORTS.f64_const.call(true)
            return res == 123.564, ("got: %f, expected: 123.564"):format(res)
        end
    },
    {
        name = "const",
        meta_test = true,
        relies_on = { "i32.const", "i64.const", "f32.const", "f64.const" }
    },
    {
        name = "i64.load",
        relies_on = { "local.get" },
        run = function()
            module.EXPORTS.memory.write64(1, { l = 0x08040201, h = 0x80402010 })
            local loaded = module.EXPORTS.i64_load.call(true, 1)
            return loaded == 0x8040201008040201ULL,
                string.format("loaded: 0x%X, expected: 0x8040201008040201", loaded)
        end
    },
    {
        name = "i64.store",
        relies_on = { "i64.load" },
        run = function()
            module.EXPORTS.i64_store.call(true, 1, 0xFF7F3F1F0F070301ULL)
            local stored = module.EXPORTS.i64_load.call(true, 1)
            return stored == 0xFF7F3F1F0F070301ULL, string.format("stored: 0x%X, expected: 0xFF7F3F1F0F070301", stored)
        end
    },
    {
        name = "i32.add param",
        relies_on = { "local.get" },
        run = function()
            local added = module.EXPORTS.i32_add_param.call(true, 654321, 77775)
            return added == 654321 + 77775, string.format("got: %i, expected: 732096", added)
        end
    },
    {
        name = "i32.add const",
        relies_on = { "const" },
        run = function()
            local added = module.EXPORTS.i32_add_const.call(true)
            return added == 143723548, string.format("got: %i, expected: 143723548", added)
        end
    },
    {
        name = "global.set",
        relies_on = { "local.get" },
        run = function()
            module.EXPORTS.global_set.call(true, 74368345)
            local val = module.EXPORTS.global.get()
            return val == 74368345, ("global was set to %i, expected 74368345"):format(val)
        end
    },
    {
        name = "global.get",
        relies_on = { "global.set" },
        run = function()
            module.EXPORTS.global_set.call(true, 65258)
            local val = module.EXPORTS.global_get.call(true)
            return val == 65258, ("got %i, expected 65258"):format(val)
        end
    },
    {
        name = "call_indirect",
        relies_on = { "const" },
        run = function()
            local val = module.EXPORTS.call_indirect_test.call(true, 0)
            if val ~= 0 then
                return false, ("tried to call 0, ended up calling %i instead"):format(val)
            end
            local val = module.EXPORTS.call_indirect_test.call(true, 1)
            if val ~= 1 then
                return false, ("tried to call 1, ended up calling %i instead"):format(val)
            end
            local val = module.EXPORTS.call_indirect_test.call(true, 2)
            if val ~= 2 then
                return false, ("tried to call 2, ended up calling %i instead"):format(val)
            end
            return true
        end
    }
}

run_tests(tests)
