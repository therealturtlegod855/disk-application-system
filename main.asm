bits 16
org 0x7c00

start:
    call clear_screen
    mov si, hello_msg
    call print_string

    ; Try to detect drives (0x80 = first HDD, 0x00 = first FDD)
    mov dl, 0x80
    call print_drive_check

    mov dl, 0x00
    call print_drive_check

    jmp $

print_drive_check:
    mov ah, 0x08      ; Get drive parameters
    int 0x13
    jc .not_found     ; If carry flag, drive not present

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
    cmp dl, 0x80
    je .hdd
    jmp .fdd

.hdd:
    mov al, 'H'
    call print_char
    mov al, 'D'
    call print_char
    mov al, 'D'
    call print_char
    jmp .done

.fdd:
    mov al, 'F'
    call print_char
    mov al, 'D'
    call print_char
    mov al, 'D'
    call print_char

.done:
    call print_newline
    ret

.not_found:
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

hello_msg: db "Welcome to DAS!", 0
print_warning: db "Disk Application System provides absolutely no warrenty implied or stated", 0

times 510 - ($ - $$) db 0
dw 0xaa55   
