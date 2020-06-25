#pragma once

enum gpio_function
{
    GPIO_PIN_FUNC_INPUT = 0,
    GPIO_PIN_FUNC_OUTPUT = 1,
    GPIO_PIN_FUNC_ALT0 = 4,
    GPIO_PIN_FUNC_ALT1 = 5,
    GPIO_PIN_FUNC_ALT2 = 6,
    GPIO_PIN_FUNC_ALT3 = 7,
    GPIO_PIN_FUNC_ALT4 = 3,
    GPIO_PIN_FUNC_ALT5 = 2,
};

/**
 * Set GPIO pin function
 * 
 * Parameters:
 *  pin_number - GPIO Pin (BCM Number) (0-53)
 *  function - Pin Function
 */
void set_gpio_function(int pin_number, enum gpio_function function);

/**
 * Set GPIO pin output value
 * 
 * Note: This will only take effect if the pin's mode is set to OUTPUT.
 * 
 * Parameters:
 *  pin_number - GPIO Pin (BCM Number) (0-53)
 *  value - State of the pin (0 or 1)
 */
void set_gpio_value(int pin_number, int value);