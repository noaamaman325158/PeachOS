ORG 0
BITS 16

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7C0:step2

handle_zero:
    mov ah, oeh
    mov al, 'A'
    xor bx, bx
    int 0x10
    iret

handle_one:
    mov ah, 0eh
    mov al, 'V'
    xor bx, bx
    int 0x10
    iret
    

step2:
    cli                     ; Clear Interrupt Flag

    mov ax, 0x7C0           ; Set up data segment
    mov ds, ax
    mov es, ax

    xor ax, ax              ; Set up stack
    mov ss, ax
    mov sp, 0x7C00

    sti  
    
    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7C0

    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7C0
    
    int 0  
    
    int 1                ; Enable Interrupt Flag

    mov si, message         ; Load message address
    call print              ; Print the message
    
    jmp $                   ; Infinite loop

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
    
message: db 'Hello, World!', 0


times 510-($-$$) db 0
dw 0xAA55


