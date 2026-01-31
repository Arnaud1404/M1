.globl main
main:
    movq $0, %rax
    movq $8, %rbx
    cmpq %rax, %rbx
    jle L0
    incq %rbx
    ret
L0:
    decq %rbx
    ret
