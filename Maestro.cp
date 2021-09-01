#line 1 "D:/Proyectos/Semaforos/Maestro/Maestro.c"
#line 1 "d:/proyectos/semaforos/maestro/confreloj.h"
void Escribir_Hora(unsigned char direccion_esclavo,unsigned char direccion_memoria, unsigned char dato){

 I2C1_Start();
 I2C1_Wr(direccion_esclavo);
 I2C1_Wr(direccion_memoria);
 I2C1_Wr(dato);
 I2C1_Stop();
}

int Leer_Hora(unsigned char direccion_esclavo,unsigned char direccion_memoria){

 int valor;
 I2C1_Start();
 I2C1_Wr(direccion_esclavo);
 I2C1_Wr(direccion_memoria);
 I2C1_Repeated_Start();
 I2C1_Wr(direccion_esclavo+1);
 valor=I2C1_Rd(0);
 I2C1_Stop();
 return valor;
}
#line 9 "D:/Proyectos/Semaforos/Maestro/Maestro.c"
int x1=0;
int y=1;
int AltoTrafico=0;
int AltoTrafico2=0;
int Horas, Minutos, Segundos;
char trama[30];

void tiempo(){

Segundos = Bcd2Dec(Leer_Hora(0xD0,0));
Minutos = Bcd2Dec(Leer_Hora(0xD0,1));


}

void main() {

UART1_Init(9600);
I2C1_Init(100000);

OSCCON.B6=1;
OSCCON.B5=1;
OSCCON.B4=0;
ADCON1=15;

Escribir_Hora(0xD0,0,Dec2Bcd(55));
Escribir_Hora(0xD0,1,Dec2Bcd(35));
Escribir_Hora(0xD0,2,(Dec2Bcd(21)));

TRISA=0b11111111;

while(1){


if ( RA0_bit ==0 ||  RA2_bit ==0 ){
 AltoTrafico2=1;
 AltoTrafico=0;
 x1=0;
}

if ( RA1_bit ==0 ||  RA3_bit ==0){
 AltoTrafico2=0;
 AltoTrafico=1;
 x1=0;
}
#line 83 "D:/Proyectos/Semaforos/Maestro/Maestro.c"
if(AltoTrafico==1){

UART1_Write_Text("pare*");


}

if(AltoTrafico2==1){

UART1_Write_Text("siga*");


}
}
}
