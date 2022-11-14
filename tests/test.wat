(module
  (export "i64_load" (func $i64_load))
  (func $i64_load (param $p0 i32) (result i64)
    local.get $p0
    i64.load
  )
  (export "i64_store" (func $i64_store))
  (func $i64_store (param $p0 i32) (param $p1 i64)
    local.get $p0
    local.get $p1
    i64.store
  )
  (export "local_get_i32" (func $local_get_i32))
  (func $local_get_i32 (param $p0 i32) (result i32)
    local.get $p0
  )
  (export "local_get_i64" (func $local_get_i64))
  (func $local_get_i64 (param $p0 i64) (result i64)
    local.get $p0
  )
  (export "local_get_f32" (func $local_get_f32))
  (func $local_get_f32 (param $p0 f32) (result f32)
    local.get $p0
  )
  (export "local_get_f64" (func $local_get_f64))
  (func $local_get_f64 (param $p0 f64) (result f64)
    local.get $p0
  )
  (export "i32_const" (func $i32_const))
  (func $i32_const (result i32)
    i32.const 143723548
  )
  (export "i64_const" (func $i64_const))
  (func $i64_const (result i64)
    i64.const 0xFEDCBA9876543210
  )
  (export "f32_const" (func $f32_const))
  (func $f32_const (result f32)
    f32.const 123.5
  )
  (export "f64_const" (func $f64_const))
  (func $f64_const (result f64)
    f64.const 123.564
  )
  (export "i32_add_param" (func $i32_add_param))
  (func $i32_add_param (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    local.get $p1
    i32.add
  )
  (export "i32_add_const" (func $i32_add_const))
  (func $i32_add_const (result i32)
    i32.const 587179435
    i32.const 3851511409
    i32.add
  )
  (export "global_set" (func $global_set))
  (func $global_set (param $p0 i32)
    local.get $p0
    global.set $global
  )
  (export "global_get" (func $global_get))
  (func $global_get (result i32)
    global.get $global
  )
  (type $call_indirect_target_type (func (result i32)))
  (func $call_indirect_target_0 (type $call_indirect_target_type)
    i32.const 0
  )
  (func $call_indirect_target_1 (type $call_indirect_target_type)
    i32.const 1
  )
  (func $call_indirect_target_2 (type $call_indirect_target_type)
    i32.const 2
  )
  (export "call_indirect_test" (func $call_indirect_test))
  (func $call_indirect_test (param $to_call i32) (result i32)
    local.get $to_call
    call_indirect (type $call_indirect_target_type)
    return
  )
  (memory $memory 1)
  (export "memory" (memory 0))
  (global $global (mut i32) (i32.const 0))
  (export "global" (global $global))
  (table $funcs 3 3 funcref)
  (elem $funcs_init (i32.const 0) $call_indirect_target_0 $call_indirect_target_1 $call_indirect_target_2)
)
