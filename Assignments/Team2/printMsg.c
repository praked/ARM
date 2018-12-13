#include "stm32f4xx.h"
#include<stdio.h>
void printMsg(const char *a)
{
	 int Msg=0;
const	char *ptr;
	 ptr = a ;
   while(Msg<100){
      ITM_SendChar(*ptr);
      ++ptr;
		 Msg++;
   }
}

