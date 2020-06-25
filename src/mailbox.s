.section .text

/**
 * Get mailbox address
 *
 * Returns:
 *  r0 - Mailbox address
 */
.globl get_mailbox_address
get_mailbox_address:
    ldr r0,=0x2000B880 @ Mailbox address (taken from https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/screen01.html)
    mov pc,lr

/**
 * Writes a message to the mailbox
 * source: https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/screen01.html
 *
 * Parameters:
 *  r0 - Message to write
 *  r1 - Which mailbox to write to (0-15)
 */
.globl mailbox_write
mailbox_write:
    tst r0,#0b1111 @ Low bits must be set to zero
    movne pc,lr

    cmp r1,#15
    movhi pc,lr

    channel .req r1
    value .req r2
    mov value,r0
    
    push {lr}
    bl get_mailbox_address
    mailboxAddr .req r0

    wait1$:
        status .req r3
        ldr status,[mailboxAddr,#0x18]

        @ Top bit of status must be 0
        tst status,#0x80000000
        .unreq status
        bne wait1$
    
    @ Combine channel and value
    add value,channel

    @ Write to mailbox
    str value,[mailboxAddr,#0x20]

    .unreq value
    .unreq channel
    .unreq mailboxAddr
    pop {pc}

/**
 * Reads a message from the mailbox
 * source: https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/screen01.html
 *
 * Parameters:
 *  r0 - Which mailbox to read from (0-15)
 */
.globl mailbox_read
mailbox_read:
    cmp r0,#15
    movhi pc,lr

    channel .req r1
    mov channel,r0

    push {lr}
    bl get_mailbox_address
    mailboxAddr .req r0

    rightmail$:
    wait2$:
        status .req r2
        ldr status,[mailboxAddr,#0x18]

        @ 30th bit of status must be 0
        tst status,#0x40000000
        .unreq status
        bne wait2$
    
    @ Get mail
    mail .req r2
    ldr mail,[mailboxAddr,#0]

    @ Get mail channel
    inChannel .req r3
    and inChannel,mail,#0b1111
    teq inChannel,channel
    .unreq inChannel

    @ Repeat until correct mail is found
    bne rightmail$
    .unreq mailboxAddr
    .unreq channel

    @ Get first 28 bits of mail (message)
    and r0,mail,#0xfffffff0
    .unreq mail

    pop {pc}
