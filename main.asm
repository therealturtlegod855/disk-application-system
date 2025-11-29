bits 16
org 0x7c00

start:
    call clear_screen

    ; Print welcome message at top (row 0)
    mov dh, 0
    call set_cursor
    mov si, welcome_msg
    call print_string

    ; Print drives starting at middle (row 12)
    mov dh, 12
    call set_cursor
    mov si, detect_msg
    call print_string
    call print_newline

    mov dl, 0x80
.check_drive:
    mov ah, 0x08      ; Get drive parameters
    int 0x13
    jc .not_found

    push dx
    call print_newline
    mov al, ' '
    call print_char
    mov al, 'D'
    call print_char
    mov al, 'r'
    call print_char
    mov al, 'i'
    call print_char
    mov al, 'v'
    call print_char
    mov al, 'e'
    call print_char
    mov al, ' '
    call print_char
    mov al, dl
    call print_hex
    call print_newline
    pop dx

.not_found:
    inc dl
    cmp dl, 0x8F
    jle .check_drive

    ; Print no warranty at bottom (row 24)
    mov dh, 24
    call set_cursor
    mov si, warranty_msg
    call print_string

    jmp $

; Print AL as two hex digits
print_hex:
    push ax
    mov ah, al
    shr al, 4
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

set_cursor:
    xor bx, bx
    mov ah, 0x02
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

print_char:
    mov ah, 0x0e
    int 0x10
    ret

print_newline:
    mov al, 0x0d
    call print_char
    mov al, 0x0a
    call print_char
    ret

welcome_msg:   db "Welcome to DAS", 0
detect_msg:    db "Detecting storage devices...", 0
warranty_msg:  db "NO WARRANTY - USE AT YOUR OWN RISK", 0

times 510 - ($ - $$) db 0
dw 0xaa55   
