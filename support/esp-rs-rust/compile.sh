#!/bin/sh

cd rust-project
(
  cat build/main.rs > examples/ledc-simple.rs &&
  cargo +esp build --example ledc-simple --release --target xtensa-esp32-espidf &&
  python3 -m esptool --chip esp32 elf2image --flash_size 4MB target/xtensa-esp32-espidf/release/examples/ledc-simple -o build/project.bin
) > build/output_stdout.txt 2> build/output_stderr.txt
