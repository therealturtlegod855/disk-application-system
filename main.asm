; main.asm - Fixed 32-bit Hello World OS

; Multiboot header
MAGIC   equ 0x1BADB002
FLAGS   equ 0
CHECKSUM equ -(MAGIC + FLAGS)

section .text
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

; Stack and entry point
section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .text
global _start
_start:
    mov esp, stack_top
    call kernel_main
    cli
.hang:
    hlt
    jmp .hang

; Only define kernel_main once
kernel_main:
    mov ax, 0x07
    mov es, ax
    mov edi, 0
    mov esi, hello_msg
.print:
    lodsb
    test al, al
    jz .done
    stosw
    jmp .print
.done:
    ret

section .data
hello_msg: db "Hello, World!", 0

times 8192 - ($-$$) db 0   
dw 0xaa5 
