org 0x7c00

start:
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    mov si, hello
    call print

    jmp $

print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp print
.done:
    ret

hello: db "Hello, World!", 0

times 510 - ($ - $$) db 0
dw 0xaa55   
