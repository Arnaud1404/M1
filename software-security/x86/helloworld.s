.data # Data section
msg:
    .asciz "Hello World!\n"
    len = . - msg # Current address - msg label

.text # Text section
.globl main

main: # Write string to stdout
    # write(int fd, const void buf[.count], size_t count);
    movl $len, %edx # 3rd arg - string length
    movl $msg, %ecx # 2nd arg - string pointer
    movl $1, %ebx # 1st arg - file descriptor stdout
    movl $4, %eax # Syscall number (sys_write)
    int $0x80 # Syscall

    movl $0, %ebx # 1st argument: exit code
    movl $1, %eax # System call number (sys_exit)
    int $0x80 # Kernel call

