section .data
output db "%d", 10, 0    ; Format string for printf, including newline

section .text
global _start            ; Declare _start as global for the linker
extern printf

_start:
    mov rax, 40          ; Load 40 into RAX
    add rax, 2           ; Add 2 to RAX
    push rax             ; Push result on stack as argument for printf

    mov rdi, output      ; Move the address of the format string to RDI (first argument)
    mov rax, 0           ; Clear RAX to indicate no floating-point arguments
    call printf          ; Call printf to print the result

    add rsp, 8           ; Clean up the stack (1 argument * 8 bytes)

    ; Exit the program using a system call
    mov rax, 60          ; System call number for exit
    xor rdi, rdi         ; Exit code 0
    syscall              ; Invoke the kernel