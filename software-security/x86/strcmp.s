.data # Data section
str1:
    .asciz "Hello" # String with \0
    len1 = . - str1 # String length

str2:
    .asciz "Hello" # String with \0
    len2 = . - str2 # String length

.text # Text section
.globl main

main:
    movl $len1, %ecx # 3rd arg: string length
    movl $str2, %edi # 2nd arg: string 2
    movl $str1, %esi # 1st arg: string 1
    cld # Comparison direction: forward
    repe cmpsb # compare esi and edi
    je equal # Check ZF
    movl $0, %eax # 0 if different
    jmp exit
equal:
    movl $1, %eax # 1 if identical
exit:
    movl $0, %ebx   # status: 0
    movl $1, %eax   # syscall: exit (32-bit)
    int $0x80 # Kernel call
