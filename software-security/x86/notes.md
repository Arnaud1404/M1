# x86 assembly basics (AT&T syntax)

Compile with `gcc -Wall -Wextra -m64 -g -o asm asm.s`

Use -m32 for 32 bit

## Registers and Suffixes

- **Registers**: `%rax` is for 64-bit. Use `%eax` for 32-bit.
    - 64-bit: `%rax`, `%rbx`, `%rcx`, `%rdi`, etc.
    - 32-bit: `%eax`, `%ebx`, `%ecx`, `%edi`, etc.
    - **Extended Registers (64-bit only)**: `%r8` through `%r15`.
        - These do not exist in legacy 32-bit mode.
        - To access the 32-bit portion in 64-bit mode, use the `d` suffix (e.g., `%r9d`, `%r12d`).
- **Suffixes**: `q` stands for **quadword** (64-bit).
    - `q` is 64-bit only (e.g., `movq`, `cmpq`).
    - Use `l` (long) for 32-bit (e.g., `movl` instead of `movq`).
    - `w` is for **word** (16-bit).
    - `b` is for **byte** (8-bit).

## Caller-saved Registers (Volatile)

You can overwrite these registers without saving/restoring them. However, if you call another function, that function is allowed to overwrite them too.

### 64-bit Mode 
- `%rax`, `%rcx`, `%rdx`, `%rsi`, `%rdi`, `%r8`, `%r9`, `%r10`, `%r11`

### 32-bit Mode (Legacy)
- `%eax`, `%ecx`, `%edx`

## Callee-saved Registers (Non-Volatile)

### 64-bit Mode
- `%rbx`, `%rbp`, `%r12`, `%r13`, `%r14`, `%r15`
- **Note**: `%rsp` is the stack pointer and should not be used as a general purpose register.

## Saving and Restoring Registers (Stack)

If you use a **callee-saved** register (like `%esi` in 32-bit), you must save its state on the stack before using it and restore it before returning.

```asm
# 32-bit example for %esi
pushl %esi      # Push %esi onto the stack
# ... code using %esi ...
popl %esi       # Pop %esi off the stack (restore)
```

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

## String Comparison (repe cmps)

To compare two memory blocks, use `repe cmps` with a size suffix.

- **`cmpsb`**: Compare Bytes (1 byte). Pointers increment by 1. (Best for ASCII strings).
- **`cmpsw`**: Compare Words (2 bytes). Pointers increment by 2.
- **`cmpsl`**: Compare Longs (4 bytes). Pointers increment by 4.
- **`cmpsq`**: Compare Quadwords (8 bytes). Pointers increment by 8.

1.  **`%rsi`**: Address of string 1.
2.  **`%rdi`**: Address of string 2.
3.  **`%rcx`**: Count (number of items).
4.  **`cld`**: Clear Direction Flag (increment forward).
5.  **`repe cmpsb`**: Execute comparison (example for bytes).

**Result**:
- Check `ZF` (Zero Flag) immediately after.
- `je` (Jump Equal) means strings matched.
- `jne` (Jump Not Equal) means they differed.

### Example Snippet

```asm
.section .data
str1: .asciz "Hello"
str2: .asciz "Hello"

.section .text
leaq str1, %rsi    # Source
leaq str2, %rdi    # Destination
movq $5, %rcx      # Length
cld                # Direction: Forward
repe cmpsb         # Compare
je equal           # Jump if match
```