BITS 16

a20_enabled_message dw 15
db 'A20 is enabled.'
a20_disabled_message dw 16
db 'A20 is disabled.'
a20_trying_bios dw 34
db 'Trying to enable A20 using BIOS...'
a20_trying_keyb dw 49
db 'Trying to enable A20 using keyboard controller...'
a20_trying_io92 dw 40
db 'Trying to enable A20 using IO port 92...'

Enable_A20:
    call Check_A20
    test ax, ax
    jnz .end

    mov si, a20_trying_bios
    call Real_mode_println
    call Enable_A20_using_BIOS

    call Check_A20
    test ax, ax
    jnz .end

    mov si, a20_trying_keyb
    call Real_mode_println
    call Enable_A20_using_Keyboard_Controller

    call Check_A20
    test ax, ax
    jnz .end

    mov si, a20_trying_io92
    call Real_mode_println
    call Enable_A20_using_Keyboard_Controller

    call Check_A20
    test ax, ax
    jnz .end
    .halt: hlt
    jmp .halt
    .end:
    ret

Check_A20:
    call Real_mode_check_A20
    test ax, ax
    jnz .a20_enabled
        mov si, a20_disabled_message
        call Real_mode_println
        ret
    .a20_enabled:
        mov si, a20_enabled_message
        call Real_mode_println
        ret

Real_mode_check_A20:
    pushf
    push ds
    push es
    push di
    push si
    cli ; clear interrupts

    xor ax, ax ; ax = 0
    mov es, ax
    not ax     ; ax = 0xFFFF
    mov ds, ax
    mov di, 0x0500
    mov si, 0x0510

    mov dl, byte [es:di]
    push dx
    mov dl, byte [ds:si]
    push dx

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
    cmp byte [es:di], 0xFF

    mov ax, 0
    je .a20_disabled
    mov ax, 1
    .a20_disabled:

    pop dx
    mov byte [ds:si], dl
    pop dx
    mov byte [es:di], dl

    pop si
    pop di
    pop es
    pop ds
    popf
    sti ; Enable interrupts
    ret

Enable_A20_using_BIOS:
    mov ax, 2403h
    int 15h
    jb .failure
    cmp ah, 0
    jnz .failure
    mov ax, 2402h
    int 15h
    jb .failure
    cmp ah, 0
    jnz .failure
    cmp al, 1
    jz .success
    mov ax, 2401h
    int 15h
    jb .failure
    cmp ah, 0
    jnz .failure
    .success:
        mov ax, 1
        ret
    .failure:
        mov ax, 0
        ret

Disable_A20_using_BIOS:
    mov ax, 2400h
    int 15h
    ret

Enable_A20_using_Keyboard_Controller:
    cli
    call a20wait
    mov al, 0xAD
    out 0x64, al
    call a20wait
    mov al, 0xD0
    out 0x64, al
    call a20wait2
    in al, 0x60
    push eax
    call a20wait
    mov al, 0xD1
    out 0x64, al
    call a20wait
    pop eax
    or al, 2
    out 0x60, al
    call a20wait
    mov al, 0xAE
    out 0x64, al
    call a20wait
    sti
    ret

a20wait:
    in      al, 0x64
    test    al, 2
    jnz     a20wait
    ret

a20wait2:
    in      al, 0x64
    test    al, 1
    jz      a20wait2
    ret

Enable_A20_using_IO_port_92:
    in al, 0x92
    test al, 2
    jnz .end
    or al, 2
    and al, 2
    jnz .end
    or al, 2
    and al, 0xFE
    out 0x92, al
    .end:
    ret
