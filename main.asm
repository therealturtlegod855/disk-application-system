BITS 16
ORG 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    cld

    call clear_screen

    mov dh, 0
    call set_cursor
    mov si, welcome_msg
    call print_string

    mov dh, 12
    call set_cursor
    mov si, menu_msg
    call print_string

    xor bp, bp
    mov byte [drive_sel], 0x80

.scan_drives:
    mov dl, [drive_sel]
    mov ah, 0x08
    int 0x13
    jc .next

    push bp
    mov al, 14
    mov bl, bp
    add al, bl
    mov dh, al
    call set_cursor
    mov si, space
    call print_string
    mov al, dl
    call print_hex
    pop bp
    inc bp

.next:
    inc byte [drive_sel]
    cmp byte [drive_sel], 0x8F
    jle .scan_drives

    ; Fix: use bl (8-bit) to match num_drives size
    mov byte [num_drives], bl
    xor bp, bp

.wait_input:
    mov al, 14
    mov bl, bp
    add al, bl
    mov dh, al
    call set_cursor
    mov si, arrow
    call print_string

    mov ah, 0
    int 0x16

    cmp al, 13
    je .launch

    cmp ah, 48
    je .up
    cmp ah, 50
    je .down
    jmp .wait_input

.up:
    test bp, bp
    jz .wait_input
    dec bp
    jmp .wait_input

.down:
    cmp bp, [num_drives]
    jnc .wait_input
    inc bp
    jmp .wait_input

.launch:
    mov dl, 0x80
    add dl, bp
    mov [0x8000], dl

    mov ax, 0x8000
    mov es, ax
    xor bx, bx
    mov ax, 0x0201
    mov ch, 0
    mov cl, 2
    mov dh, 0
    int 0x13
    jc .launch

    jmp 0x8000:0

print_hex:
    push ax
    mov cl, 4
    mov ah, al
    shr ah, cl
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
    mov ah, 0x0E
    xor bh, bh
    int 0x10
    ret

welcome_msg: db "Welcome to DAS", 0
menu_msg:    db "Choose an app to launch:", 0
arrow:       db ">", 0
space:       db " ", 0
drive_sel:   db 0
num_drives:  db 0

times 510 - ($ - $$) db 0
dw 0xAA55   
