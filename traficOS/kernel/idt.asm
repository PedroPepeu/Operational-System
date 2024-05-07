BASE_OF_SECTION equ 0x8000

%macro .idtentry 3
dw ((BASE_OF_SECTION + %1 - $$) & 0xFFFF) - 1024
dw %2
db 0
db %3
dw ((BASE_OF_SECTION + %1 - $$) >> 16) & 0xFFFF
dd ((BASE_OF_SECTION + %1 - $$) >> 32) & 0xFFFFFFFF
dd 0
%endmacro

IDT_START:
    .idtentry ISR_Division_by_Zero, CODE_SEG, 0x8F  ;0 (Divide by zero)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;1 (Debug Exception)     
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;2 (NMI, Non-Maskable Interrupt)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;3 (Breakpoint Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;4 (INTO Overflow)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;5 (Out of Bounds)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;6 (Invalid Opcode)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;7 (Device Not Available)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;8 (Double Fault) 
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;9 (Deprecated)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;10 (Invalid TSS) 
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;11 (Segment Not Present)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;12 (Stack-Segment Fault)
  .idtentry ISR_GPF             , CODE_SEG, 0x8F  ;13 (General Protection Fault)
  .idtentry ISR_Page_Fault      , CODE_SEG, 0x8F  ;14 (Page Fault)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;15 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;16 (x87 Floating-Point Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;17 (Alignment Check Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;18 (Machine Check Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;19 (SIMD Floating-Point Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;20 (Virtualization Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;21 (Control Protection Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;22 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;23 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;24 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;25 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;26 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;27 (Reserved)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;28 (Hypervisor Injection Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;29 (VMM Communication Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;30 (Security Exception)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;31 (Reserved)
  .idtentry ISR_systimer        , CODE_SEG, 0x8F  ;32 (IRQ0: Programmable Interrupt Timer)
  .idtentry ISR_keyboard        , CODE_SEG, 0x8E  ;33 (IRQ1: Keyboard)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;34 (IRQ2: PIC Cascade, used internally)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;35 (IRQ3: COM2, if enabled)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;36 (IRQ4: COM1, if enabled)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;37 (IRQ5: LPT2, if enabled)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;38 (IRQ6: Floppy Disk)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;39 (IRQ7: LPT1)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;40 (IRQ8: CMOS real-time clock)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;41 (IRQ9: Free)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;42 (IRQ10: Free)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;43 (IRQ11: Free)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;44 (IRQ12: PS2 Mouse)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;45 (IRQ13: Coprocessor)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;46 (IRQ14: Primary ATA Hard Disk)
  .idtentry ISR_dummy           , CODE_SEG, 0x8F  ;47 (IRQ15: Secondary ATA Hard Disk)
; ...
; Although the IDT can contain less than 256 entries, any entries that are not present
; will generate a General Protection Fault when an attempt to access them is made.
IDT_END:

ALIGN 4
IDTR:
    .Length dw IDT_END-IDT_START-1
    .Base   dd IDT_START
