# x86 assembly basics (AT&T syntax)

Compile with `gcc -Wall -Wextra -m64 -g -o asm asm.s`

Use -m32 for 32 bit

## Registers and Suffixes

- **Registers**: `%rax` is for 64-bit. Use `%eax` for 32-bit.
    - 64-bit: `%rax`, `%rbx`, `%rcx`, `%rdi`, etc.
    - 32-bit: `%eax`, `%ebx`, `%ecx`, `%edi`, etc.
- **Suffixes**: `q` stands for **quadword** (64-bit).
    - `q` is 64-bit only (e.g., `movq`, `cmpq`).
    - Use `l` (long) for 32-bit (e.g., `movl` instead of `movq`).

## Compilation flags

- `-nostdlib`: Do not use the standard system startup files or libraries.
    - **Why it runs**: The OS kernel loads the binary and jumps to the entry point. It does not strictly require the C library to execute machine code.
    - **Effects**:
        - **Linker Warning**: Defaults to `_start`. If you use `main`, the linker warns "cannot find entry symbol".
        - **Segfault on Return**: `ret` crashes because there is no return address on the stack (the kernel *jumps* to the entry point, it doesn't *call* it). You must use the `exit` syscall.
        - **Smaller Binary**: Removes C runtime overhead.

## GDB commands

n is for source code lines, ni for assembly instructions

- `ni` (nexti)
- `si` (stepi)
- `disas` (disassemble)
- `i r` (info registers)
- `p $rax` (print $rax)