bits 16
org 0x0000

start:
    call clear_screen
    mov si, msg1
    call print_string
    mov al, [0x7c05]  ; Get passed drive
    call print_hex
    mov si, msg2
    call print_string
    jmp $

print_hex:
    push ax
    mov ah, al
    shr ah, 4
    call .nibble
    mov al, ah
    and al, 0x0F
    .nibble:
    cmp al, 10
    sbb al, 0x69
    das
    call print_char
    pop ax
    ret   

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

print_string:
    lodsb
    or al, al
    jz .done
    call print_char
    jmp print_string
.done:
    ret

print_char:  ; Now defined
    mov ah, 0x0e
    int 0x10
    ret

msg1: db "Drive ", 0
msg2: db " selected", 13, 10, 0

times 512 - ($ - $$) db 0   

