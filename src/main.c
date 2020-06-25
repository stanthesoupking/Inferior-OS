#include "kernel.h"
#include "string.h"

void main()
{
#ifdef DEBUG_MODE
    // Enable Mini UART for debugging
    enable_mini_uart();
    set_mini_uart_baudrate_reg(3254); // Set baudrate to ~9600 hz
#endif

    // Write kernel version
    debug_trace("Inferior OS Version ", 20);
    debug_trace(KERNEL_VERSION, strlen(KERNEL_VERSION));
    debug_trace("\n\r", 2);

    debug_trace("Creating frame buffer.\n\r", 24);
    struct frame_buffer_info_type *fb_info = initialise_frame_buffer(800, 480, 16);

    if (!fb_info)
    {
        debug_trace("Frame buffer creation failed.\n\r", 31);
        return;
    }

    debug_trace("Frame buffer creation was successful.\n\r", 40);

    // Do test render
    test_render();
    debug_trace("Finished test render.\n\r", 23);
}