;; kernel.asm
bits 32     ;nasm directive - 32 bit
section .text
  align 4
  dd 0x1BADB002
  dd 0x00
  dd - (0x1BADB002)

global start
global keyboard_handler
global read_port
global write_port
global load_idt

extern kmain    ;kmain is defined in the c file
extern keyboard_handler_main

read_port:
  mov edx, [esp + 4]
  in al, dx
  ret

write_port:
  mov edx, [esp + 4]
  mov al, [esp + 4 + 4]
  out dx, al
  ret

load_idt:
  mov edx, [esp + 4]
  lidt [edx]
  sti
  ret

keyboard_handler:
  call keyboard_handler_main
  iretd

start:
  cli                     ;blank interrupts
  mov esp, stack_space    ;set stack pointer
  call kmain
  hlt                     ;halt the CPU

section .bss
resb 8192       ;8KB for stack
stack_space:
