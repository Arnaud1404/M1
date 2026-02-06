.data # Data section
msg:
    .asciz "0" # Temporary string
    len = . - msg

.text # Text section
.globl main

main: # echo one character
#ssize_t read(int fd, void buf[.count], size_t count);
    movl $len, %edx # 3rd arg - string length
    movl $msg, %ecx # 2nd arg - string pointer
    movl $0, %ebx # 1st arg - file descriptor stdout
    movl $3, %eax # Syscall number (sys_read)
    int $0x80 # Syscall

    # Now write it back to stdout
    movl $len, %edx # 3rd arg - string length
    movl $msg, %ecx # 2nd arg - string pointer
    movl $1, %ebx # 1st arg - file descriptor stdout
    movl $4, %eax # Syscall number (sys_write)
    int $0x80 # Syscall

    # Exit
    movl $0, %ebx # 1st argument: exit code
    movl $1, %eax # System call number (sys_exit)
    int $0x80 # Kernel call