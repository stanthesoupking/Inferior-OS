/**
 * Gets the offset of the GPIO address
 *
 * Returns:
 *  r0 - GPIO Address
 */
.globl GetGPIOAddress
GetGPIOAddress:
    ldr r0,=0x20200000 @ GPIO Controller Address
	@ Note: Actual addresses is offset by -0x5E000000 from BCM2835 documentation addresses
	@ ~ Not sure why though...

    mov pc,lr

/**
 * void SetGPIOFunction(u32 pin, u32 function)
 *
 * Sets the function of the given pin number.
 * 
 * Available Functions:
 *  0 - Input
 *  1 - Output
 *  ... Alternate functions (see page 92 of BCM2835 datasheet)
 *
 * Paramaters:
 *  r0 - Pin Number (0-53)
 *  r1 - Function (0-7)
 */
.globl SetGPIOFunction
SetGPIOFunction:
    pinNum .req r4
    function .req r5
    mov pinNum,r0
    mov function,r1

    cmp pinNum,#53 @ Pin number must be between 0-53 (available GPIO pins)
    movhi pc,lr

    cmp function,#7 @ Function must be between 0-7 (available functions)
    movhi pc,lr
    
    @ Preserve lr
    push {lr}

    bl GetGPIOAddress
    gpioAddr .req r0

    @ Get function select offset
    loop$:
        cmp pinNum,#10
        ble loopEnd$

        add gpioAddr,gpioAddr,#4
        sub pinNum,pinNum,#10
        b loop$
    loopEnd$:

    @ Left shift pin
    mov r7,#3
    mul r6,pinNum,r7
    lsl function,r6

    @ Create mask
    mov r7,#7
    lsl r7,r6

    @ Invert mask
    mov r6,#0xFFFFFFFF
    eor r7,r7,r6 

    @ Mask with current value at gpioAddr
    ldr r6,[gpioAddr]
    and r6,r6,r7
    orr function,function,r6

    @ Set pin function
    str function,[gpioAddr]

    .unreq pinNum
    .unreq function
    .unreq gpioAddr
    pop {pc}

/**
 * void SetGPIOValue(u32 pin, u32 value)
 *
 * Sets a GPIO pin to either on or off
 *
 * Parameters:
 *  r0 - Pin Number (0-53)
 *  r1 - Value (0-1)
 */
.globl SetGPIOValue
SetGPIOValue:
    mov r4,r0
    mov r5,r1
    pinNum .req r4
    pinVal .req r5

    cmp pinNum,#53
    movhi pc,lr

    cmp pinVal,#1
    movhi pc,lr

    push {lr}

    bl GetGPIOAddress
    gpioAddr .req r0
    add gpioAddr,gpioAddr,#0x1C @ output set

    @ Add GPIO pin output register offset
    cmp pinVal,#0
    addhi gpioAddr,gpioAddr,#0xC @ output clear
    mov pinVal,#1

    @ Add pin offset
    cmp pinNum,#31
    addhi gpioAddr,gpioAddr,#4
    subhi pinNum,pinNum,#31

    @ Calculate left shift from pin number
    lshift .req r8
    mov lshift,#32
    sub lshift,lshift,pinNum
    
    @ Left shift value
    lsl pinVal,lshift

    @ Apply value
    str pinVal,[gpioAddr]

    .unreq pinNum
    .unreq pinVal
    .unreq gpioAddr
    .unreq lshift
    pop {pc}
