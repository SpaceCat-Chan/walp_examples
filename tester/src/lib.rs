const ADD_TEST: [(u32, u32, u32); 1] = [(2, 2, 4)];
const SUB_TEST: [(u32, u32, u32); 1] = [(2, 2, 0)];
const AND_TEST: [(u32, u32, u32); 1] = [(2, 2, 2)];
const OR_TEST: [(u32, u32, u32); 1] = [(2, 2, 2)];
const XOR_TEST: [(u32, u32, u32); 1] = [(2, 2, 0)];

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
        test(a, b, res, n as _, a + b != res);
    }
    walp_rs::print("\nsub tests:\n");
    for (n, (a, b, res)) in SUB_TEST.iter().cloned().enumerate() {
        test(a, b, res, n as _, a - b != res);
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
