.globl _start
_start:
    movl $1, %ecx # Initialize counter n = 1
    movl $0, %edx # F(0) = 0
    movl $1, %eax # F(1) = 1
fibonacci_loop:
    cmpl $24, %ecx # Stop at F(24)
    je fibonacci_end
    movl %eax, %esi # Save F(n-1)
    addl %edx, %eax # F(n) = F(n-1) + F(n-2)
    movl %esi, %edx # F(n-1) update
    incl %ecx # Increment n
    jmp fibonacci_loop
fibonacci_end:
    movl $1, %eax   # syscall: exit (32-bit)
    movl $0, %ebx   # status: 0
    int $0x80
