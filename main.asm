; main.asm - Working 16-bit Hello World Bootloader
bits 16
org 0x7c00

start:
    mov si, hello_msg
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp print_string
clear_screen:
    pusha
    mov ax, 0x0003  ; AH=0 (set video mode), AL=3 (80x25 text mode)
    int 0x10
    popa
    ret   
.done:
    ret

hello_msg: db "Hello, World!", 0
call clear_screen

times 510 - ($ - $$) db 0
dw 0xaa55   
