.section .init

@ .globl _start
@ _start:
@ 	b main

.globl main
main:
	mov sp,#0x8000

	@ Enable UART
	bl EnableUART
	
	@ Set baudrate regulator to 3254; ~9600hz
	ldr r0,=#3254
	bl SetUARTBaudrateReg

	@ Enable GPIO pin output
	mov r0,#16
	mov r1,#1
	bl SetGPIOFunction

main_loop$:
	@ Write to UART
	ldr r0,=msg
	ldr r1,=msg_len
	sub r1,r1,r0
	bl WriteUARTString

	bl test

@ 	@ Turn on LED
@ 	mov r0,#16
@ 	mov r1,#1
@ 	bl SetGPIOValue

@ 	mov r2,#0x3F0000
@ delay$:
@ 	sub r2,#1
@ 	cmp r2,#0
@ 	bne delay$

@ 	@ Turn off LED
@ 	mov r0,#16
@ 	mov r1,#0
@ 	bl SetGPIOValue

@ 	mov r2,#0x3F0000
@ delay2$:
@ 	sub r2,#1
@ 	cmp r2,#0
@ 	bne delay2$

	b main_loop$ 

.globl exit
exit:
	nop

.section .data
msg: .ascii "Hello from assembly!\n\r"
msg_len:
