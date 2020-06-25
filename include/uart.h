#pragma once

void EnableUART();
void DisableUART();

void SetUARTBaudrateReg(int value);

void WriteUARTChar(char c);
void WriteUARTString(const char * string, int length);