.section .init

.globl _start
_start:
	mov sp,#0x8000
	bl main

.section .data
msg: .ascii "Hello from assembly!\n\r"
msg_len:
