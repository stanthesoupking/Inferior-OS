.section .init
.globl _start

_start:
	mov sp,#0x8000

	@ Enable UART
	bl EnableUART

	@ Enable GPIO pin output
	mov r0,#16
	mov r1,#1
	bl SetGPIOFunction

main_loop$:
	@ Turn on LED
	mov r0,#16
	mov r1,#1
	bl SetGPIOValue

	mov r2,#0x3F0000
delay$:
	sub r2,#1
	cmp r2,#0
	bne delay$

	@ Turn off LED
	mov r0,#16
	mov r1,#0
	bl SetGPIOValue

	mov r2,#0x3F0000
delay2$:
	sub r2,#1
	cmp r2,#0
	bne delay2$

	b main_loop$ 

	@ Infinite loop
loop$:
	b loop$
