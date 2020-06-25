.section .data
.align 4
.globl frame_buffer_info
frame_buffer_info:
.int 1024   @ #0 Physical Width
.int 768    @ #4 Physical Height
.int 1024   @ #8 Virtual Width
.int 768    @ #12 Virtual Height
.int 0      @ #16 GPU - Pitch
.int 16     @ #20 Bit Depth
.int 0      @ #24 X
.int 0      @ #28 Y
.int 0      @ #32 GPU - Pointer
.int 0      @ #36 GPU - Size

.section .text

/**
 * Intialise the frame buffer with the given properties.
 * source: https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/screen01.html
 *
 * Parameters:
 *  r0 - Frame Buffer Width (1-4096)
 *  r1 - Frame Buffer Height (1-4096)
 *  r2 - Frame Buffer Bit Depth (1-32)
 */
.globl initialise_frame_buffer
initialise_frame_buffer:
    width .req r0
    height .req r1
    bitDepth .req r2
    result .req r0

    @ Validate inputs
    cmp width,#4096
    movhi result,#0
    movhi pc,lr

    cmp height,#4096
    movhi result,#0
    movhi pc,lr

    cmp bitDepth,#32
    movhi result,#0
    movhi pc,lr

    @ Store values in frame buffer info memory
    fbInfoAddr .req r3
    push {lr}
    ldr fbInfoAddr,=frame_buffer_info
    str width,[fbInfoAddr,#0]
    str height,[fbInfoAddr,#4]
    str width,[fbInfoAddr,#8]
    str height,[fbInfoAddr,#12]
    str bitDepth,[fbInfoAddr,#20]
    .unreq width
    .unreq height
    .unreq bitDepth

    @ Send to GPU via mailbox
    mov r0,fbInfoAddr
    @ Tell GPU to not cache fb info; store directly in fb info memory
    add r0,#0x40000000
    mov r1,#1 @ GPU channel
    bl mailbox_write

    @ Check response from GPU
    mov r0,#1
    bl mailbox_read

    teq result,#0
    movne result,#0
    popne {pc}

    mov result,fbInfoAddr
    pop {pc}
    .unreq result
    .unreq fbInfoAddr

.globl test_render
test_render:
    push {lr}

    fbInfoAddr .req r6
    ldr fbInfoAddr,=frame_buffer_info

    fbAddr .req r3
    ldr fbAddr,[fbInfoAddr,#32]

    colour .req r0
    y .req r1
    mov y,#480
    drawRow$:
        x .req r2
        mov x,#800
        drawPixel$:
            strh colour,[fbAddr]
            add fbAddr,#2
            sub x,#1
            teq x,#0
            bne drawPixel$
        sub y,#1
        add colour,#1
        teq y,#0
        bne drawRow$

    .unreq fbAddr
    .unreq fbInfoAddr
    pop {pc}
