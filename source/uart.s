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
    add auxAddr, #4 @ Add AUX_ENABLES offset

    @ Read current value of AUX_ENABLES
    auxEnables .req r2
    ldr auxEnables,[auxAddr]
    orr auxEnables,#1 @ Set Mini UART enable = 1
    str auxEnables,[auxAddr]

    .unreq auxAddr
    .unreq auxEnables
    pop {pc}

/**
 * Enable Mini UART
 */
.globl EnableUART
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

    mov r0,r1
    char .req r1

    push {lr}

    bl GetAuxillaryAddress
    auxAddr .req r0

    @ Write character to AUX_MU_IO_REG
    str char,[auxAddr,#0x40]

    @ @ Enable transmit
    @ flags .req r1

    @ ldr flags,[auxAddr,#0x60]
    @ orr flags,flags,#2
    @ str flags,[auxAddr,#0x60]
    
    .unreq char
    @ .unreq flags
    .unreq auxAddr
    pop {pc}
