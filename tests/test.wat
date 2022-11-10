(module
  (func $i64_load (param $p0 i32) (result i64)
    local.get $p0
    i64.load
  )
  (func $i64_store (param $p0 i32) (param $p1 i64)
    local.get $p0
    local.get $p1
    i64.store
  )
  (func $local_get (param $p0 i32) (result i32)
    local.get $p0
  )
  (func $i32_const (result i32)
    i32.const 143723548
  )
  (func $i32_add_param (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    local.get $p1
    i32.add
  )
  (func $i32_add_const (result i32)
    i32.const 587179435
    i32.const 3851511409
    i32.add
  )
  (func $global_set (param $p0 i32)
    local.get $p0
    global.set $global
  )
  (func $global_get (result i32)
    global.get $global
  )
  (func $i64_const (result i64)
    i64.const 0xFEDCBA9876543210
  )
  (export "i64_load" (func $i64_load))
  (export "i64_store" (func $i64_store))
  (export "local_get" (func $local_get))
  (export "i32_const" (func $i32_const))
  (export "i32_add_param" (func $i32_add_param))
  (export "i32_add_const" (func $i32_add_const))
  (export "global_set" (func $global_set))
  (export "global_get" (func $global_get))
  (export "i64_const" (func $i64_const))
  (memory $memory 1)
  (export "memory" (memory 0))
  (global $global (mut i32) (i32.const 0))
  (export "global" (global $global))
)
