void i2c_iniciar(){
     TRISB.RB1=1;
     TRISB.RB0=1;
     SSPSTAT=0b10000000; //Velocidad estantar bus I2C
     SSPCON=0b00101000; //Habilitado en modo maestro
     SSPCON2=0b00000000; //Comunicacion I2C no iniciada.
     SSPADD=9;

}

void I2C_ESPERAR(){

 while((SSPCON2 & 0b00011111) || (SSPSTAT & 0b00011111));

}