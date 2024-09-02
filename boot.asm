ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0 :step2

step2:
    cli                     ; Clear Interrupt Flag

    mov ax, 0x00          ; Set up data segment
    mov ds, ax
    mov es, ax

    xor ax, ax              ; Set up stack
    mov ss, ax
    mov sp, 0x7C00

    sti           ; Print the message
    
    
    jmp $  
.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; GDT
gdt_start:

gdt_null:
    dd 0x00
    dd 0x00

; offset 0x8
gdt_code: ; Code Segment should be point to this
    dw 0xffff; Segment Limit 0-15 bits
    dw 0; Base first 0-15 bits 
    dw 0; Base 16-23 bits
    db 0x9a; Access Byte
    db 11001111b; High 4 bit flag and the low 4 bit flags
    db 0; Base 24-31 bits

; offset 0x10
gdt_data: ; DS, SS, ES, FS, GS
    dw 0xffff
    dw 0
    dw 0
    db 0x92
    db 11001111b
    db 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start


[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    mov ebp, 0x00200000
    mov esp, ebp

    jmp $

times 510-($-$$) db 0
dw 0xAA55


buffer:




