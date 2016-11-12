// sensor.v
`timescale 1ns/1ps
`define SIMULATION

module Sensor_TB;
parameter tck              = 10;       // clock period in ns
parameter clk_freq = 1000000000 / tck; // Frequenzy in HZ

	reg 	reset; //entrada
	reg 	clk; //entrada
	reg	Sensor;

	Sensor s1(.clk(clk),.sensor(Sensor));
	/* Clocking device */
	initial begin
	        clk <= 0;
		Sensor =0;
		end
	always #(tck/2) clk <= ~clk;
	always #32 Sensor =!Sensor;


	initial begin: TEST_WAVE
		$dumpfile("Sensor_TB.vcd");
		$dumpvars(-1, s1);
/*	
	#0  reset = 1;
//	#1 
	Sensor = 0;
	#32 reset = 0;
	while ($time < 500) begin
		sensor=!sensor;
		#32
		end
*/

/*
	#1 Sensor = 1;
	#32 Sensor = 0;
	#32 Sensor = 1;
	#32 Sensor = 0;
	#32 Sensor = 1;
	#32 Sensor = 0;
*/

	#(tck*200)$finish; //tiempo simulación
	end

endmodule

