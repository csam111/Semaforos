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