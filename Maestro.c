#include "Confreloj.h"

#define SS1_1 RA0_bit       //Sensor 1 Semaforo 1
#define SS2_1 RA1_bit       //Sensor 1 Semaforo 2
#define SS3_1 RA2_bit       //Sensor 1 Semaforo 3
#define SS4_1 RA3_bit       //Sensor 1 Semaforo 4


int x1=0;
int y=1;
int AltoTrafico=0;
int AltoTrafico2=0;
int Horas, Minutos, Segundos;
char trama[30];

void tiempo(){

Segundos  = Bcd2Dec(Leer_Hora(0xD0,0));
Minutos  = Bcd2Dec(Leer_Hora(0xD0,1));


}

void main() {

UART1_Init(9600);
I2C1_Init(100000);

OSCCON.B6=1;
OSCCON.B5=1; //Oscilador interno a 4MHZ
OSCCON.B4=0;
ADCON1=15;  //Convertidor analogo digital apagado

Escribir_Hora(0xD0,0,Dec2Bcd(55)); //Segundos
Escribir_Hora(0xD0,1,Dec2Bcd(35)); //Minutos
Escribir_Hora(0xD0,2,(Dec2Bcd(21))); //Hora

TRISA=0b11111111;

while(1){


if (SS1_1==0 || SS3_1==0 ){
 AltoTrafico2=1;
 AltoTrafico=0;
 x1=0;
}

if (SS2_1==0 || SS4_1==0){
 AltoTrafico2=0;
 AltoTrafico=1;
 x1=0;
}


//Borrar
tiempo();

if (x1==0){
y=Minutos;
x1=1;
}

if(Segundos == 30 ){
UART1_Write_Text("pare*");
x1=0;
}

if(Minutos == (y+1 ) ){

UART1_Write_Text("siga*");

}

if(Minutos != (y+1) ){

UART1_Write_Text("pare*");
AltoTrafico=0;

}

//Hasta aqui

if(AltoTrafico==1){

UART1_Write_Text("pare*");


}

if(AltoTrafico2==1){

UART1_Write_Text("siga*");


}
}
}
