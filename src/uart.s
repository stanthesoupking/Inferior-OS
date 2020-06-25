.section .text

/**
 * Get the auxillary peripheral address
 *
 * Returns
 *  r0 - Auxillary Peripheral Address
 */
.globl GetAuxillaryPeripheralAddress
GetAuxillaryAddress:
    ldr r0,=#0x20215000
    mov pc,lr

/**
 * Enable Mini UART
 */
.globl EnableUART
EnableUART:
    push {lr}

    @ Setup GPIO pins
    mov r0,#14 @ TXD
    mov r1,#2 @ ALT5 TXD1 (Mini UART)
    bl SetGPIOFunction

    mov r0,#15 @ RXD
    mov r1,#2 @ ALT5 RXD1 (Mini UART)
    bl SetGPIOFunction

    bl GetAuxillaryAddress
    auxAddr .req r0

    @ Read current value of AUX_ENABLES
    auxEnables .req r2
    ldr auxEnables,[auxAddr,#4] @ AUX_ENABLES offset
    orr auxEnables,#1 @ Set Mini UART enable = 1
    str auxEnables,[auxAddr,#4]

    .unreq auxAddr
    .unreq auxEnables
    pop {pc}

/**
 * Disable Mini UART
 */
.globl DisableUART
DisableUART:
    push {lr}

    bl GetAuxillaryAddress
    auxAddr .req r0
    add auxAddr, #4 @ Add AUX_ENABLES offset

    @ Read current value of AUX_ENABLES
    auxEnables .req r2
    ldr auxEnables,[auxAddr]
    and auxEnables,#6 @ Set Mini UART enable = 0 (without modifying SPI enable bits)
    str auxEnables,[auxAddr]

    .unreq auxAddr
    .unreq auxEnables
    pop {pc}

/**
 * Sets the baudrate register to alter UART baudrate
 * 
 * Parameters:
 *  r0 - Baudrate (0-65535)
 */
.globl SetUARTBaudrateReg
SetUARTBaudrateReg:
    @ Check if baudrate is valid
    ldr r1,=#0xFFFF @ Max baudrate value
    cmp r0,r1
    movhi pc,lr

    push {lr}

    mov r1,r0
    baudrate .req r1

    bl GetAuxillaryAddress
    auxAddr .req r0

    @ Update AUX_MU_BAUD_REG
    str baudrate,[auxAddr,#0x68]

    .unreq baudrate 
    .unreq auxAddr
    pop {pc}

/**
 * Transmits a character using UART
 * 
 * Parameters:
 *  r0 - Character (0 - 255)
 */
.globl WriteUARTChar
WriteUARTChar:
    cmp r0,#255
    movhi pc,lr

    mov r1,r0
    char .req r1

    push {lr}

    bl GetAuxillaryAddress
    auxAddr .req r0

    @ Write character to AUX_MU_IO_REG
    str char,[auxAddr,#0x40]
    
    .unreq char
    .unreq auxAddr
    pop {pc}

/**
 * Transmits a string using UART
 * 
 * Parameters:
 *  r0 - String
 *  r1 - String Length
 */
.globl WriteUARTString
WriteUARTString:
    mov r2,r0
    string .req r2

    mov r3,r1
    len .req r3

    push {lr}

    bl GetAuxillaryAddress
    auxAddr .req r0

    @ Write characters to AUX_MU_IO_REG
    char .req r4
    index .req r5
    mov index,#0
    write_loop$:
        ldr char,[string]

        @ Wait until transmit buffer has enough space for a character
        buffer_space_loop$:
            ldr r6,[auxAddr,#0x54] @ AUX_MU_LSR_REG
            and r6,r6,#32 @ Transmitter empty (can accept at least 1 byte)
            cmp r6,#32
            bne buffer_space_loop$

        str char,[auxAddr,#0x40]
        add string,string,#1
        add index,index,#1

        cmp len,index
        bne write_loop$
    
    .unreq char
    .unreq index
    .unreq len
    .unreq auxAddr
    pop {pc}
