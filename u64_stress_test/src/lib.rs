use walp_rs::walp_println;

extern "C" {
    fn print_u64(n: i64);
    fn passthrough(n: i64) -> i64;
}

fn pass(n: i64) -> i64 {
    unsafe { passthrough(n) }
}

fn print(n: i64) {
    unsafe { print_u64(n) };
}

fn my_custom_panic_hook(info: &std::panic::PanicInfo) {
    let msg = info.to_string();

    walp_println!("{}", &msg);
}

const CASES: [(i64, i64, bool, bool, bool); 4] = [
    (-100, 100, true, false, false),
    (0x100000000, 4, false, true, false),
    (1234567891011, 1234567891011, false, false, true),
    (0x1200000000, -1, false, true, false),
];

#[no_mangle]
extern "C" fn test() {
    std::panic::set_hook(Box::new(my_custom_panic_hook));
    walp_println!("Hello from Rust!");

    for case in CASES {
        if (pass(case.0) < pass(case.1)) != case.2 {
            walp_println!("failed lt test for:");
            print(case.0);
            print(case.1);
        }
        if (pass(case.0) > pass(case.1)) != case.3 {
            walp_println!("failed gt test for:");
            print(case.0);
            print(case.1);
        }
        if (pass(case.0) == pass(case.1)) != case.4 {
            walp_println!("failed eq test for:");
            print(case.0);
            print(case.1);
        }
        if (pass(case.0) <= pass(case.1)) != (case.2 || case.4) {
            walp_println!("failed le test for:");
            print(case.0);
            print(case.1);
        }
        if (pass(case.0) >= pass(case.1)) != (case.3 || case.4) {
            walp_println!("failed ge test for:");
            print(case.0);
            print(case.1);
        }
    }
    walp_println!("done.");
}
