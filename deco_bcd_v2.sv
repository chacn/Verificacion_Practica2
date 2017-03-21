 module deco_bcd_v2
#(parameter input_lenght = 8, parameter nDisplays = 3)
(
	// Input Ports
	input [input_lenght-1:0]binary_in,
	//input [Word_Length-1:0] Data_Input,

	// Output Ports
	output [3:0] out [nDisplays-1:0]
);

logic [input_lenght + (nDisplays*4) -1 : 0] registro_corrimiento;		//Se crea un wire (no es registro) para realizar los corrimientos y sumas en un solo bus

integer i,j;

always_comb
	begin
		
//		for(j=nDisplays-1;j>=0;j=j-1)
//			out[j][3:0]= 4'b0;
//		
//		
//		for(i=input_lenght-1;i>=0;i=i-1)
//		begin
//		
//			for(j=nDisplays-1;j>=0;j=j-1)
//			begin
//				if(out[j][3:0]>=5)
//					out[j][3:0]=out[j][3:0]+3;
//					
//				out[j][3:0]=out[j][3:0]<<1;
//				if(j>0)
//					out[j][0]=out[j-1][3];
//				else
//					out[j][0]=binary_in[i];
//			end
//		end
		
		
		registro_corrimiento = 0;    //Se inicializa con valores 0
		registro_corrimiento[input_lenght-1:0] = binary_in;    //Se copia el valor de los bits de entrada a la parte baja del bus
		
		for(i=input_lenght-1;i>=0;i=i-1)    //Para generar de forma paralela nbits corrimientos que requiere el algoritmo
		begin
		
			for(j=nDisplays-1;j>=0;j=j-1)    //Para generar la lógica de comparación de cada dígito que se va a tener como salida
			begin
				if(registro_corrimiento[input_lenght + j*4 +: 4]>=5)
					registro_corrimiento[input_lenght + j*4 +: 4]=registro_corrimiento[input_lenght + j*4 +: 4]+3;
			end
			registro_corrimiento=registro_corrimiento<<1;    //El corrimiento que debe hacerse por cada bit que se tiene a la entrada
		end
		
		for(j=nDisplays-1;j>=0;j=j-1)
			out[j][3:0] = registro_corrimiento[input_lenght + j*4 +: 4];	//Conectar el resultado a la salida del módulo
		
		
	end
	
endmodule
