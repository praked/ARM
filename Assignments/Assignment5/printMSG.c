// PRANAV KEDIA - IMT2015518
#include "TM4C123GH6PM.h"
#include<stdio.h>
void printMSG(const int a)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}