.data # Data section
path:
    .asciz "/bin/sh"

;argv:
;     .long path    # argv[0]: pointer to "/bin/sh"
;     .long 0       # argv[1]: NULL pointer (end of list)

.text # Text section
.globl main
main:
    # int execve(const char *pathname, char *const _Nullable argv[],
    #            char *const _Nullable envp[])
    movl $0, %edx # 3rd arg : NULL
    movl $0, %ecx # 2nd arg : argv
    movl $path, %ebx # 1st arg : pathname
    movl $11, %eax # Syscall number execve
    int $0x80 # Syscall

    movl $1, %ebx # 1st argument: exit code
    movl $1, %eax # System call number (sys_exit)
    int $0x80 # Kernel call