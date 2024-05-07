BITS 16    ; on the x86, the BIOS (and consequently the bootloader) runs in 16-bit Real Mode
ORG 0x7C00 ; We are loaded/booted by BIOS into this memory address

Stage1_entrypoint: ; Where BIOS leaves us
    jmp 0x0000:.setup_segments
    .setup_segments:

        ; all setted to zero
        xor ax, ax
        mov ss, ax
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax

        mov sp, Stage1_entrypoint
        cld

    mov [disk], dl

    mov ax, (stage2_start-stage1_start)/512 ; ax: start sector
    mov cx, (kernel_end-stage2_start)/512   ; cx: number of sectors (512 bytes) to read
    mov bx, stage2_start
    xor dx, dx
    call Real_mode_read_disk

    mov si, stage1_message
    call Real_mode_println

    ; jmp stage 2
    jmp Stage2_entrypoint

    .halt: hlt
    jmp .halt

%include "stage1/disk.asm"
%include "stage1/print.asm"

times 510-($-$$) db 0 ; Padding
dw 0xAA55
