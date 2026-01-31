.globl main
main:
    movl $1, %ecx   # Initialize counter n = 1
    movl $1, %eax   # Initialize factorial result to 1
factorial_loop:
    cmpl $8, %ecx   # Compare counter with 8
    jg end_factorial # If counter > 8, end loop
    imull %ecx, %eax # Multiply result by counter
    incl %ecx       # Increment counter
    jmp factorial_loop # Repeat loop
end_factorial:
    ret
    