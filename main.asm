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
.done:
    ret

hello_msg: db "Hello, World!", 0

times 510 - ($ - $$) db 0
dw 0xaa55   
