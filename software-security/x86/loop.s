.globl _start
# Loops from 0 to 9 
_start: 
    movl $0, %ecx   # Initialize counter to 0
L0:
    cmpl $10, %ecx  # Compare counter with 10
    je L1           # If counter == 10, exit loop
    incl %ecx
    jmp L0
L1:
    # Exit program without standard library
    movl $60, %eax     # Syscall number for exit
    movl $0, %edi      # Exit code 0
    syscall
