const ADD_TEST: [(u32, u32, u32); 3] = [
    (2, 2, 4),
    (0xF453EBA2, 0x55123FDA, 1231432572),
    (10, 20, 30),
];
const SUB_TEST: [(u32, u32, u32); 3] = [
    (2, 2, 0),
    (0xF453EBA2, 0x55123FDA, 2671881160),
    (10, 20, 4294967286),
];
const AND_TEST: [(u32, u32, u32); 3] =
    [(2, 2, 2), (0xF453EBA2, 0x55123FDA, 1410476930), (10, 20, 0)];
const OR_TEST: [(u32, u32, u32); 3] = [
    (2, 2, 2),
    (0xF453EBA2, 0x55123FDA, 4115922938),
    (10, 20, 30),
];
const XOR_TEST: [(u32, u32, u32); 3] = [
    (2, 2, 0),
    (0xF453EBA2, 0x55123FDA, 2705446008),
    (10, 20, 30),
];
const COMPARISON_TEST: [(u32, u32, bool, bool, bool); 3] = [
    (2, 2, false, true, false),
    (0xF453EBA2, 0x55123FDA, false, false, true),
    (10, 20, true, false, false),
];

extern "C" {
    fn test_n(a: u32, b: u32, res: u32, n: u32, fail: bool);
}

fn test(a: u32, b: u32, res: u32, n: u32, fail: bool) {
    unsafe { test_n(a, b, res, n, fail) }
}

#[no_mangle]
pub extern "C" fn amain() {
    walp_rs::print("add tests:\n");
    for (n, (a, b, res)) in ADD_TEST.iter().cloned().enumerate() {
        test(a, b, res, n as _, a.wrapping_add(b) != res);
    }
    walp_rs::print("\nsub tests:\n");
    for (n, (a, b, res)) in SUB_TEST.iter().cloned().enumerate() {
        test(a, b, res, n as _, a.wrapping_sub(b) != res);
    }
    walp_rs::print("\nand tests:\n");
    for (n, (a, b, res)) in AND_TEST.iter().cloned().enumerate() {
        test(a, b, res, n as _, a & b != res);
    }
    walp_rs::print("\nor tests:\n");
    for (n, (a, b, res)) in OR_TEST.iter().cloned().enumerate() {
        test(a, b, res, n as _, a | b != res);
    }
    walp_rs::print("\nxor tests:\n");
    for (n, (a, b, res)) in XOR_TEST.iter().cloned().enumerate() {
        test(a, b, res, n as _, a ^ b != res);
    }
    walp_rs::print("\nless than tests:\n");
    for (n, (a, b, lt, _eq, _gt)) in COMPARISON_TEST.iter().cloned().enumerate() {
        test(a, b, lt as _, n as _, (a < b) != lt);
    }
    walp_rs::print("\nequal tests:\n");
    for (n, (a, b, _lt, eq, _gt)) in COMPARISON_TEST.iter().cloned().enumerate() {
        test(a, b, eq as _, n as _, (a == b) != eq);
    }
    walp_rs::print("\ngreater than tests:\n");
    for (n, (a, b, _lt, _eq, gt)) in COMPARISON_TEST.iter().cloned().enumerate() {
        test(a, b, gt as _, n as _, (a > b) != gt);
    }
    walp_rs::print("\nless equal tests:\n");
    for (n, (a, b, lt, eq, _gt)) in COMPARISON_TEST.iter().cloned().enumerate() {
        test(a, b, (lt || eq) as _, n as _, (a <= b) != (lt || eq));
    }
    walp_rs::print("\ngreater equal tests:\n");
    for (n, (a, b, _lt, eq, gt)) in COMPARISON_TEST.iter().cloned().enumerate() {
        test(a, b, (gt || eq) as _, n as _, (a >= b) != (gt || eq));
    }
}

#[cfg(not(target_family = "wasm"))]
mod defs {
    use walp_rs::walp_println;

    /*
    test_n = function(a, b, res, n, fail)
            if fail ~= 1 then
                io.write("test ", n, " succeded\n")
            else
                io.write("test ", n, " failed with a: ", a, " b: ", b, " res: ", res, "\n")
            end
        end
     */
    #[no_mangle]
    extern "C" fn test_n(a: u32, b: u32, res: u32, n: u32, fail: bool) {
        if fail {
            walp_println!("test {} failed with a: {} b: {} res: {}", n, a, b, res)
        } else {
            walp_println!("test {} succeded", n)
        }
    }
}
