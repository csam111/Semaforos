
_Escribir_Hora:

;confreloj.h,1 :: 		void Escribir_Hora(unsigned char direccion_esclavo,unsigned char direccion_memoria, unsigned char dato){
;confreloj.h,3 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;confreloj.h,4 :: 		I2C1_Wr(direccion_esclavo);
	MOVF        FARG_Escribir_Hora_direccion_esclavo+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;confreloj.h,5 :: 		I2C1_Wr(direccion_memoria);
	MOVF        FARG_Escribir_Hora_direccion_memoria+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;confreloj.h,6 :: 		I2C1_Wr(dato);
	MOVF        FARG_Escribir_Hora_dato+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;confreloj.h,7 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;confreloj.h,8 :: 		}
L_end_Escribir_Hora:
	RETURN      0
; end of _Escribir_Hora

_Leer_Hora:

;confreloj.h,10 :: 		int Leer_Hora(unsigned char direccion_esclavo,unsigned char direccion_memoria){
;confreloj.h,13 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;confreloj.h,14 :: 		I2C1_Wr(direccion_esclavo);
	MOVF        FARG_Leer_Hora_direccion_esclavo+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;confreloj.h,15 :: 		I2C1_Wr(direccion_memoria);
	MOVF        FARG_Leer_Hora_direccion_memoria+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;confreloj.h,16 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;confreloj.h,17 :: 		I2C1_Wr(direccion_esclavo+1);
	MOVF        FARG_Leer_Hora_direccion_esclavo+0, 0 
	ADDLW       1
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;confreloj.h,18 :: 		valor=I2C1_Rd(0);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Leer_Hora_valor_L0+0 
	MOVLW       0
	MOVWF       Leer_Hora_valor_L0+1 
;confreloj.h,19 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;confreloj.h,20 :: 		return valor;
	MOVF        Leer_Hora_valor_L0+0, 0 
	MOVWF       R0 
	MOVF        Leer_Hora_valor_L0+1, 0 
	MOVWF       R1 
;confreloj.h,21 :: 		}
L_end_Leer_Hora:
	RETURN      0
; end of _Leer_Hora

_tiempo:

;Maestro.c,16 :: 		void tiempo(){
;Maestro.c,18 :: 		Segundos  = Bcd2Dec(Leer_Hora(0xD0,0));
	MOVLW       208
	MOVWF       FARG_Leer_Hora_direccion_esclavo+0 
	CLRF        FARG_Leer_Hora_direccion_memoria+0 
	CALL        _Leer_Hora+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _Segundos+0 
	MOVLW       0
	MOVWF       _Segundos+1 
;Maestro.c,19 :: 		Minutos  = Bcd2Dec(Leer_Hora(0xD0,1));
	MOVLW       208
	MOVWF       FARG_Leer_Hora_direccion_esclavo+0 
	MOVLW       1
	MOVWF       FARG_Leer_Hora_direccion_memoria+0 
	CALL        _Leer_Hora+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _Minutos+0 
	MOVLW       0
	MOVWF       _Minutos+1 
;Maestro.c,22 :: 		}
L_end_tiempo:
	RETURN      0
; end of _tiempo

_main:

;Maestro.c,24 :: 		void main() {
;Maestro.c,26 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Maestro.c,27 :: 		I2C1_Init(100000);
	MOVLW       10
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;Maestro.c,29 :: 		OSCCON.B6=1;
	BSF         OSCCON+0, 6 
;Maestro.c,30 :: 		OSCCON.B5=1; //Oscilador interno a 4MHZ
	BSF         OSCCON+0, 5 
;Maestro.c,31 :: 		OSCCON.B4=0;
	BCF         OSCCON+0, 4 
;Maestro.c,32 :: 		ADCON1=15;  //Convertidor analogo digital apagado
	MOVLW       15
	MOVWF       ADCON1+0 
;Maestro.c,34 :: 		Escribir_Hora(0xD0,0,Dec2Bcd(55)); //Segundos
	MOVLW       55
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Escribir_Hora_dato+0 
	MOVLW       208
	MOVWF       FARG_Escribir_Hora_direccion_esclavo+0 
	CLRF        FARG_Escribir_Hora_direccion_memoria+0 
	CALL        _Escribir_Hora+0, 0
;Maestro.c,35 :: 		Escribir_Hora(0xD0,1,Dec2Bcd(35)); //Minutos
	MOVLW       35
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Escribir_Hora_dato+0 
	MOVLW       208
	MOVWF       FARG_Escribir_Hora_direccion_esclavo+0 
	MOVLW       1
	MOVWF       FARG_Escribir_Hora_direccion_memoria+0 
	CALL        _Escribir_Hora+0, 0
;Maestro.c,36 :: 		Escribir_Hora(0xD0,2,(Dec2Bcd(21))); //Hora
	MOVLW       21
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Escribir_Hora_dato+0 
	MOVLW       208
	MOVWF       FARG_Escribir_Hora_direccion_esclavo+0 
	MOVLW       2
	MOVWF       FARG_Escribir_Hora_direccion_memoria+0 
	CALL        _Escribir_Hora+0, 0
;Maestro.c,38 :: 		TRISA=0b11111111;
	MOVLW       255
	MOVWF       TRISA+0 
;Maestro.c,40 :: 		while(1){
L_main0:
;Maestro.c,43 :: 		if (SS1_1==0 || SS3_1==0 ){
	BTFSS       RA0_bit+0, BitPos(RA0_bit+0) 
	GOTO        L__main11
	BTFSS       RA2_bit+0, BitPos(RA2_bit+0) 
	GOTO        L__main11
	GOTO        L_main4
L__main11:
;Maestro.c,44 :: 		AltoTrafico2=1;
	MOVLW       1
	MOVWF       _AltoTrafico2+0 
	MOVLW       0
	MOVWF       _AltoTrafico2+1 
;Maestro.c,45 :: 		AltoTrafico=0;
	CLRF        _AltoTrafico+0 
	CLRF        _AltoTrafico+1 
;Maestro.c,46 :: 		x1=0;
	CLRF        _x1+0 
	CLRF        _x1+1 
;Maestro.c,47 :: 		}
L_main4:
;Maestro.c,49 :: 		if (SS2_1==0 || SS4_1==0){
	BTFSS       RA1_bit+0, BitPos(RA1_bit+0) 
	GOTO        L__main10
	BTFSS       RA3_bit+0, BitPos(RA3_bit+0) 
	GOTO        L__main10
	GOTO        L_main7
L__main10:
;Maestro.c,50 :: 		AltoTrafico2=0;
	CLRF        _AltoTrafico2+0 
	CLRF        _AltoTrafico2+1 
;Maestro.c,51 :: 		AltoTrafico=1;
	MOVLW       1
	MOVWF       _AltoTrafico+0 
	MOVLW       0
	MOVWF       _AltoTrafico+1 
;Maestro.c,52 :: 		x1=0;
	CLRF        _x1+0 
	CLRF        _x1+1 
;Maestro.c,53 :: 		}
L_main7:
;Maestro.c,83 :: 		if(AltoTrafico==1){
	MOVLW       0
	XORWF       _AltoTrafico+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main16
	MOVLW       1
	XORWF       _AltoTrafico+0, 0 
L__main16:
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
;Maestro.c,85 :: 		UART1_Write_Text("pare*");
	MOVLW       ?lstr1_Maestro+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_Maestro+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Maestro.c,88 :: 		}
L_main8:
;Maestro.c,90 :: 		if(AltoTrafico2==1){
	MOVLW       0
	XORWF       _AltoTrafico2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main17
	MOVLW       1
	XORWF       _AltoTrafico2+0, 0 
L__main17:
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;Maestro.c,92 :: 		UART1_Write_Text("siga*");
	MOVLW       ?lstr2_Maestro+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_Maestro+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Maestro.c,95 :: 		}
L_main9:
;Maestro.c,96 :: 		}
	GOTO        L_main0
;Maestro.c,97 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
