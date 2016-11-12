module Sensor(input clk,input sensor,output reg [7:0] JA,output reg [6:0] led);
reg [1:0] filtro;
reg [31:0] CR,CG,CB,CC,A,Az,R,V,N,B;
reg [0:0] final,final2;

reg [31:0] suma;

/*
S0 = JA1 - B13
S1 = JA7 - G13
S2 = JA3 - D17
S3 = JA9 - D18
*/

function [31:0] abs;
	input [31:0] a,b;
	begin
	if(a<b)
		abs=b-a;
	else
		abs=a-b;
	end
endfunction

function [0:0] menor;
	input [31:0] a,b,c,d,e,f;
	begin
	if((a<b)&(a<c)&(a<d)&(a<e)&(a<f))
		menor=1;
	else
		menor=0;
	end
endfunction

initial
	begin
	suma=0;
	A=0;
	Az=0;
	R=0;
	V=0;
	N=0;
	B=0;
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


always @ (posedge final)
	begin
	//amarillo,azul,rojo,verde,naranja,blanco.
	suma= CR+CG+CB+CC;
	A=abs(suma,32'd43056);
	Az=abs(suma,32'd55897);
	R=abs(suma,32'd49209);
	V=abs(suma,32'd42677);
	N=abs(suma,32'd36782);
	B=abs(suma,32'd25976);

	if (32'd10500<CR && CR<32'd12500 && 32'd12300<CB && CB<32'd14500 && 32'd3700<CC && CC<32'd5700 && 32'd12300<CG && CG<32'd14300)
		led=7'b0000001;//Amarillo
	if (32'd11500<CR && CR<32'd23500 && 32'd10500<CB && CB<32'd12500 && 32'd5200<CC && CC<32'd7000 && 32'd19300<CG && CG<32'd22700)
		led=7'b0000011;//Azul
	if (32'd13700<CR && CR<32'd15800 && 32'd13500<CB && CB<32'd15000 && 32'd4700<CC && CC<32'd6700 && 32'd19300<CG && CG<32'd21300)
		led=7'b0000111;//Rojo
	if (32'd19000<CR && CR<32'd21300 && 32'd14300<CB && CB<32'd16300 && 32'd5200<CC && CC<32'd7200 && 32'd17800<CG && CG<32'd18800)
		led=7'b0001111;//Verde
	if (32'd7000<CR && CR<32'd10000 && 32'd9000<CB && CB<32'd12000 && 32'd3000<CC && CC<32'd5000 && 32'd12000<CG && CG<32'd14500)
		led=7'b0011111;//Naranja
	if (32'd6000<CR && CR<32'd8500 && 32'd5000<CB && CB<32'd8000 && 32'd1000<CC && CC<32'd5000 && 32'd8000<CG && CG<32'd11000)
		led=7'b0111111;//Blanco
	end
	
endmodule
