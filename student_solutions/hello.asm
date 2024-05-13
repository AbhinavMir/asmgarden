section .data
    msg db 'Hello, World!', 0x0A  ; Message and a newline

section .text
    global _start               ; Needed to link the entry point

_start:
    mov edx, 13                 ; Length of the message
    mov ecx, msg                ; Message to print
    mov ebx, 1                  ; File descriptor (stdout)
    mov eax, 4                  ; System call number (sys_write)
    int 0x80                    ; Call kernel

    mov eax, 1                  ; System call number (sys_exit)
    xor ebx, ebx                ; Exit code 0
    int 0x80                    ; Call kernel

