.globl _start
# Loops from 0 to 9 
_start: 
    mov $0, %rcx   # Initialize counter to 0
L0:
    cmp $10, %ecx   # Compare counter with 10
    je L1           # If counter == 10, exit loop
    inc %ecx
    jmp L0
L1:
    # Exit program without standard library
    mov $60, %eax      # Syscall number for exit
    mov $0, %edi       # Exit code 0
    syscall
