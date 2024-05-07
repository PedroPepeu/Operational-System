BITS 16

%define PAGE_PRESENT    (1 << 0)
%define PAGE_WRITE      (1 << 1)
%define CODE_SEG        0x0008
%define PAGING_DATA     0x9000

GDT:
    .Null:
        dq 0x0000000000000000
    .Code:
        dq 0x00209A0000000000
        dq 0x0000920000000000
    ALIGN 4
        dw 0
    .Pointer:
        dw $ - GDT - 1
        dd GDT

Prepare_paging:
    mov edi, PAGING_DATA

    push di
    mov ecx, 0x1000
    xor eax, eax
    cld
    rep stosd
    pop di

    lea eax, [es:di + 0x1000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di], eax

    lea eax, [es:di + 0x2000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di + 0x1000], eax

    lea eax, [es:di + 0x3000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di + 0x2000], eax
    
    push di
    lea di, [di + 0x3000]
    mov eax, PAGE_PRESENT | PAGE_WRITE

    .LoopPageTable:
        mov [es:di], eax
        add eax, 0x1000
        add di, 8
        cmp eax, 0x200000
        jb .LoopPageTable

    pop di
    ret
