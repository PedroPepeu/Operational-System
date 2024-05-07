BITS 16

PIC1_COMMAND    equ 0x20
PIC1_DATA       equ 0x21
PIC2_COMMAND    equ 0xA0
PIC2_DATA       equ 0xA1
PIC_EOI         equ 0x20

ICW1_ICW4       equ 0x01 ; Initialization Command Word 4 is needed
ICW1_SINGLE     equ 0x02 ; Single mode (0: Cascade mode)
ICW1_INTERVAL4  equ 0x04 ; Call address interval: 4 (0: 8)
ICW1_LEVEL      equ 0x08 ; Level triggered mode (0: Edge mode)
ICW1_INIT       equ 0x10 ; Initialization - required!

ICW4_8086       equ 0x01 ; 8086/88 mode (0: MCS-80/85 mode)
ICW4_AUTO_EOI   equ 0x02 ; Auto End Of Interrupt (0: Normal EOI)
ICW4_BUF_SLAVE  equ 0x08 ; Buffered mode/slave
ICW4_BUF_MASTER equ 0x0C ; Buffered mode/master
ICW4_SFNM       equ 0x10 ; Special Fully Nested Mode

Remap_PIC:
    push ax

    mov al, 0xFF
    out PIC1_DATA, al
    out PIC2_DATA, al
    nop
    nop

    mov al, ICW1_INIT | ICW1_ICW4 ; ICW1: Send initialization command (= 0x11) to both PICs 
    out PIC1_COMMAND, al    
    out PIC2_COMMAND, al     
    mov al, 0x20       ; ICW2: Set vector offset of 1st PIC to 0x20 (i.e. IRQ0 => INT 32) 
    out PIC1_DATA, al
    mov al, 0x28       ; ICW2: Set vector offset of 2nd PIC to 0x28 (i.e. IRQ8 => INT 40)    
    out PIC2_DATA, al
    mov al, 4          ; ICW3: tell 1st PIC that there is a 2nd PIC at IRQ2 (= 00000100)
    out PIC1_DATA, al       
    mov al, 2          ; ICW3: tell 2nd PIC its "cascade" identity (= 00000010) 
    out PIC2_DATA, al        
    mov al, ICW4_8086  ; ICW4: Set mode to 8086/88 mode
    out PIC1_DATA, al
    out PIC2_DATA, al

    mov al, 0xFF       ; OCW1: We mask all interrupts (until we set a proper IDT in Kernel)
    out PIC1_DATA, al
    out PIC2_DATA, al

    pop ax
    ret
