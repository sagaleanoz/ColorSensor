module Sensor(input clk,input sensor, input leer,input ACK,output reg [7:0] JA,output reg [6:0] led, output reg [2:0] JC, output reg DONE);
reg [1:0] filtro;
reg [31:0] CR,CG,CB,CC,TIMER;
reg [0:0] final,final2;



/*
S0 = JA1 - B13
S1 = JA7 - G13
S2 = JA3 - D17
S3 = JA9 - D18
*/

initial
	begin
	
	TIMER=0;
	DONE=1'b0;
	JC=3'b000;
	led=6'd0;
	final=1'b0;
	final2=1'b0;
	filtro = 2'b00;
	CR =0;
	CG =0;
	CB =0;
	CC =0;
	end
always @ (posedge clk)
	if(final==1'b1 && final2==1'b0)
	begin
		CR =0;
		CG =0;
		CB =0;
		CC =0;
		final2=1'b1;
		
	end
	else
	
	if(final==1'b0 && final2==1'b1)
		begin
		final2=1'b0;
		end
	else
		begin
		case(filtro)
		2'b00:
			begin
			JA= 8'b00010001;
			CR = CR +1'b1;			
			end
		2'b01:
			begin
			JA= 8'b01010001;//Filtro Azul
			CB = CB +1'b1;
			end
		2'b10:
			begin
			JA= 8'b00010101; //Sin Filtro.
			CC = CC +1'b1; 
			end
		2'b11:
			begin
			JA= 8'b01010101; //Filtro Verde.
			CG = CG +1'b1;
			end
	endcase
		end
		
	

always @(posedge sensor)
        if(leer==1)
	begin
	if(filtro < 2'b11)
		begin
		final=1'b0;
		filtro =filtro + 2'b01;
		end
	else
		begin
		filtro=2'b00;
		final=1'b1;
		end
	end



always @ (posedge final)
	begin
	//amarillo,azul,rojo,verde,naranja,blanco.
	
	if (32'd10500<CR && CR<32'd12500 && 32'd12300<CB && CB<32'd14500 && 32'd3700<CC && CC<32'd5700 && 32'd12300<CG && CG<32'd14300)
		begin
		led=7'b0000001;//Amarillo
		JC=3'b001;
		end
	if (32'd11500<CR && CR<32'd23500 && 32'd10500<CB && CB<32'd12500 && 32'd5200<CC && CC<32'd7000 && 32'd19300<CG && CG<32'd22700)
		begin
		led=7'b0000011;//Azul
		JC=3'b010;
		end
	if (32'd13700<CR && CR<32'd15800 && 32'd13500<CB && CB<32'd15000 && 32'd4700<CC && CC<32'd6700 && 32'd19300<CG && CG<32'd21300)
		begin 
		led=7'b0000111;//Rojo
		JC=3'b011;
		end
	if (32'd19000<CR && CR<32'd21300 && 32'd14300<CB && CB<32'd16300 && 32'd5200<CC && CC<32'd7200 && 32'd17800<CG && CG<32'd18800)
		begin
		led=7'b0001111;//Verde
		JC=3'b100;
		end
	if (32'd7000<CR && CR<32'd10000 && 32'd9000<CB && CB<32'd12000 && 32'd3000<CC && CC<32'd5000 && 32'd12000<CG && CG<32'd14500)
		begin
		led=7'b0011111;//Naranja
		JC=3'b101;
		end
	if (32'd6000<CR && CR<32'd8500 && 32'd5000<CB && CB<32'd8000 && 32'd1000<CC && CC<32'd5000 && 32'd8000<CG && CG<32'd11000)
		begin
		led=7'b0111111;//Blanco
		JC=3'b110;
		end
	
	end
always @(posedge clk)
	if (leer==1)
begin
	if (TIMER>32'd50000000 	 )
	begin
		DONE=1'b1;
if(ACK==1)
begin		
TIMER=0;
DONE=0;
end
	end 
	else 
	TIMER = TIMER +1'b1;
end


endmodule
