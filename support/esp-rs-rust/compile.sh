#!/bin/sh

cd rust-project
(
  cargo build --features "native" --release &&
  python3 -m esptool --chip esp32 elf2image --flash_size 4MB target/xtensa-esp32-espidf/release/rust-project -o src/project.bin
) > src/output_stdout.txt 2> src/output_stderr.txt
