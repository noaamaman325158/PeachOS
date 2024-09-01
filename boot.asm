ORG 0
BITS 16

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7C0:step2

step2:
    cli                     ; Clear Interrupt Flag

    mov ax, 0x7C0           ; Set up data segment
    mov ds, ax
    mov es, ax

    xor ax, ax              ; Set up stack
    mov ss, ax
    mov sp, 0x7C00

    sti           ; Print the message
    
    
    jmp $  

disk_error:
    mov si, error_message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb 
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret
    

error_message db 'Failed to load sector', 0

times 510-($-$$) db 0
dw 0xAA55


buffer:




