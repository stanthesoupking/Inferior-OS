#pragma once
#include "gpio.h"
#include "uart.h"
#include "framebuffer.h"

#define DEBUG_MODE

#ifdef DEBUG_MODE
    #define debug_trace(x,y) write_mini_uart_string(x,y);
#else
    #define debug_trace(x,y) // Do nothing
#endif

#define KERNEL_VERSION "0.1.0 Alpha"