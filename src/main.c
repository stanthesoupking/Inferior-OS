#include "uart.h"

void main()
{
    EnableUART();
    SetUARTBaudrateReg(3254); // ~9600 hz

    while (1)
    {
        WriteUARTString("Hello from C!\n\r", 16);
    }
}