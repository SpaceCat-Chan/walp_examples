(module
  (type $t0 (func (param i32) (result i64)))
  (func $i64_load (type $t0) (param $p0 i32) (result i64)
    local.get $p0
    i64.load
  )
  (type $t1 (func (param i32) (param i64)))
  (func $i64_store (type $t1) (param $p0 i32) (param $p1 i64)
    local.get $p0
    local.get $p1
    i64.store
  )
  (export "i64_load" (func $i64_load))
  (export "i64_store" (func $i64_store))
  (memory $memory 1)
  (export "memory" (memory 0))
)