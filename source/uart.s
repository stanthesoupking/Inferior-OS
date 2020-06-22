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

    @ TODO: Possibly set GPIO pin functions first?

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
