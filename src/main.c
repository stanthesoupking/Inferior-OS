#include "uart.h"
#include "gpio.h"

void main()
{
    // Enable Mini UART for debugging
    enable_mini_uart();
    set_mini_uart_baudrate_reg(3254); // Set baudrate to ~9600 hz

    while (1)
    {
        write_mini_uart_string("Hello from C!\n\r", 16);
    }
}