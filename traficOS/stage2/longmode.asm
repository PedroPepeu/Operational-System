BITS 16

Is_longmode_supported:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .not_supported

    mov eax, 0x80000001
    cpuid
    test edx, (1 << 29)

    jz .not_supported
    ret

    .not_supported:
        xor eax, eax
        ret

Enter_long_mode:
    mov edi, PAGING_DATA; Point edi at the PAGING_DATA.
    mov eax, 10100000b  ; Set the PAE and PGE bit.
    mov cr4, eax
    mov edx, edi        ; Point CR3 at the PML4.
    mov cr3, edx
    mov ecx, 0xC0000080 ; Read from the EFER MSR. 
    rdmsr    
    or eax, 0x00000100  ; Set the LME bit.
    wrmsr
    mov ebx, cr0        ; Activate long mode
    or ebx,0x80000001   ; by enabling paging and protection simultaneously.
    mov cr0, ebx                    
    lgdt [GDT.Pointer]  ; Load GDT.Pointer.
    jmp CODE_SEG:Kernel ; Load CS with 64 bit segment and flush the instruction cache.
