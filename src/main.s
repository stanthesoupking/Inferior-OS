.section .init

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

	@ Execute test C function
	bl test

	b main_loop$ 

.section .data
msg: .ascii "Hello from assembly!\n\r"
msg_len:
