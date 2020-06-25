#pragma once

/**
 * Enable mini UART
 * 
 * Note 1: This will alter the functions of GPIO pins (14 and 15) to be TXD1 and RXD1.
 * Note 2: The output bit differs between Raspberry models: Zero = 8 Bit, 1B = 7 bit
 */
void enable_mini_uart();

/**
 * Disable mini UART
 */
void disable_mini_uart();

/**
 * Set baudrate of mini UART my manipulating the baudrate register.
 * 
 * The value given does not translate into baudrate (hz), it affects baudrate
 *  using the following formula:
 * 
 * baudrate = system_clock / (8 * (baudrate_reg + 1))
 * 
 * Parameters:
 *  value - baudrate register value (0-65535)
 */
void set_mini_uart_baudrate_reg(int value);

/**
 * Write a character using mini UART
 * 
 * Parameters:
 *  c - character to write
 */
void write_mini_uart_char(char c);

/**
 * Write a string using mini UART
 * 
 * Parameters:
 *  string - string to write
 *  length - length of the string
 */
void write_mini_uart_string(const char * string, int length);