extern "C" {
    fn i_take_a_break();
}

fn take_a_break() {
    unsafe {
        i_take_a_break();
    }
}

fn my_custom_panic_hook(info: &std::panic::PanicInfo) {
    let msg = info.to_string();

    walp_println!("{}", &msg);
}

#[no_mangle]
pub extern "C" fn amain() {
    std::panic::set_hook(Box::new(my_custom_panic_hook));
    walp_println!("Hello from Rust!");
    let mut u = Universe::new();
    walp_println!("{}\n", u);
    for _ in 0..100 {
        take_a_break();
        u.tick();
        walp_println!("{}\n", u)
    }
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Cell {
    Dead = 0,
    Alive = 1,
}

pub struct Universe {
    width: u32,
    height: u32,
    cells: Vec<Cell>,
}

impl Universe {
    fn get_index(&self, row: u32, col: u32) -> usize {
        (row * self.width + col) as usize
    }

    fn index(&self, row: u32, col: u32) -> Cell {
        self.cells[self.get_index(row, col)]
    }

    fn live_neighbor_count(&self, row: u32, col: u32) -> u8 {
        let mut count = 0;
        for drow in [self.height - 1, 0, 1].iter() {
            for dcol in [self.width - 1, 0, 1].iter() {
                if (*drow, *dcol) == (0, 0) {
                    continue;
                }

                let neighbor_row = (row + drow) % self.height;
                let neighbor_col = (col + dcol) % self.width;
                count += self.index(neighbor_row, neighbor_col) as u8;
            }
        }
        count
    }
}

impl Universe {
    pub fn new() -> Self {
        let width = 16;
        let height = 16;

        let cells = (0..width * height)
            .map(|_| {
                if math_random() < 0.5 {
                    Cell::Alive
                } else {
                    Cell::Dead
                }
            })
            .collect();

        Self {
            width,
            height,
            cells,
        }
    }

    pub fn width(&self) -> u32 {
        self.width
    }

    pub fn height(&self) -> u32 {
        self.height
    }

    pub fn cells(&self) -> *const Cell {
        self.cells.as_ptr()
    }

    pub fn tick(&mut self) {
        let mut next = self.cells.clone();
        for row in 0..self.width {
            for col in 0..self.height {
                let idx = self.get_index(row, col);
                let cell = self.cells[idx];
                let neighbors = self.live_neighbor_count(row, col);

                let next_cell = match (cell, neighbors) {
                    (Cell::Alive, 2 | 3) => Cell::Alive,
                    (Cell::Alive, _) => Cell::Dead,
                    (Cell::Dead, 3) => Cell::Alive,
                    (Cell::Dead, _) => Cell::Dead,
                };

                next[idx] = next_cell;
            }
        }
        self.cells = next;
    }
}

use std::fmt;

use walp_rs::{math_random, walp_println};

impl fmt::Display for Universe {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for line in self.cells.as_slice().chunks(self.width as usize) {
            for &cell in line {
                let symbol = match cell {
                    Cell::Alive => '◼',
                    Cell::Dead => '◻',
                };
                write!(f, "{}", symbol)?;
            }
            write!(f, "\n")?;
        }
        Ok(())
    }
}
