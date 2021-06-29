`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 Harshal Chowdhary
// ///////////////////////////////////////////////////////////////////////////////
// File Name:      UartProtocol.v
// Type:           Module
// Department:     Electronics and Communication Engineering, B.Tech
// Author:         Harshal Chowdhary
// Authors' Email: harshalchowdhary15@gmail.com
// Create Date:    12:56:10 07/02/2021 
// Module Name:    uart_transmiter 
//////////////////////////////////////////////////////////////////////////////////
// Release History
// 06/22/2021 Harshal Chowdhary UART Transmiter
//////////////////////////////////////////////////////////////////////////////////
// Keywords:       UART PROTOCOL. UART Transmiter
//////////////////////////////////////////////////////////////////////////////////
// Purpose:         This transmitter is able to 
//                  transmit 8 bits of serial data, one start bit, one stop bit,
//                  and no parity bit.
// Constants:       Frequency of clock = 25MHz and Baud Rate = 115200bps
//                  CLOCKS PER BIT = (Frequency of clock)/(Baud Rate)
//						  CLOCKS PER BIT = 217
//////////////////////////////////////////////////////////////////////////////////
module UART_Transmitter
	#(parameter CLOCKS_PER_BIT = 217)(
    input [7:0] databus,
	 input valid,
	 input clk,
	 output reg outserial
	 );
parameter IDLE = 2'b00, START = 2'b01, DATABIT = 2'b10, STOP = 2'b11;

reg [1:0] next_state;
reg [7:0] clock_count;
reg [2:0] index;

always @(posedge clk)
begin
	case(next_state)
		IDLE: begin
					index <= 1'h0;
					if(valid == 1'b1)
						begin
							clock_count <= 2'h00;
							next_state <= START;
						end
					else 
						next_state <= IDLE;
				end
		
		START: begin
					outserial<=1'b0;
					if(clock_count < CLOCKS_PER_BIT - 1)
						begin
							clock_count <= clock_count + 1'b1;
							next_state <= START;
						end
					else 
						begin
							clock_count <= 0;
							next_state <= DATABIT;
						end
				end
				
		DATABIT: begin
						outserial <= databus[index];
						if(clock_count < CLOCKS_PER_BIT - 1)
							begin
								clock_count <= clock_count + 1'b1;
								next_state <= DATABIT;
							end
						else
							begin
								clock_count<=0;
								if(index < 3'b111)
									begin
										index <= index + 1'b1;
										next_state <= DATABIT;
									end
								else 
									begin 
										index <=1'b0;
										next_state <= STOP;
									end
							end
					end
		
		STOP: begin
					outserial<=1'b1;
					if(clock_count < CLOCKS_PER_BIT - 1)
						begin
							clock_count <= clock_count + 1'b1;
							next_state <= STOP;
						end
					else 
						begin
							clock_count <= 0;
							next_state <= IDLE;
						end
				end
		
		default: next_state<=IDLE;
	endcase
end

endmodule
