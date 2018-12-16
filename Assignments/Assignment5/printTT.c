// PRANAV KEDIA - IMT2015518
#include "TM4C123GH6PM.h"
#include<stdio.h>
void printTT(const int  a)
{
static char  Msg[100];
static  int16_t i;	
int j;	
j=0;	
char *ptr;	
  Msg[0] = 1 ;
	Msg[1] = 0 ;
	Msg[2] = 0 ;
	Msg[3] =(char)((a>>3)&1); 
  Msg[4] = 1 ; 
  Msg[5] = 0 ; 
  Msg[6] = 1 ; 
	Msg[7]=(char)((a>>2)&1);
	Msg[8] = 1 ; 
	Msg[9] = 1 ;
  Msg[10]= 0 ;
	Msg[11]=(char)((a>>1)&1);
  Msg[12]= 1 ;
  Msg[13]= 1 ;
  Msg[14]= 1 ; 		
	Msg[15]=(char)(a&1);
	ptr=Msg;
   while(j<=15){
      ITM_SendChar(*ptr);
      ++ptr;
		 ++j;
   }
}