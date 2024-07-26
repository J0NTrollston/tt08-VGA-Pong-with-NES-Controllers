`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TinyTapeout 8
// Engineer: Brandon S. Ramos
// 
// Create Date: 07/24/2024 04:14:43 PM
// Design Name: 
// Module Name: ballFunction.v
// Project Name: VGA Pong with NES Controllers
// Target Devices: 
// Tool Versions: 
// Description: Module determines the ball movement and inc/dec the position
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ballFunction(
    input wire clk,
    input wire reset_n,
    
    input wire [3:0] cw_ballMovement,
    
    output wire [9:0] ball_center_x,
    output wire [9:0] ball_center_y
    );

//Intermediate signals
reg [9:0] ball_center_x_proc;
reg [9:0] ball_center_y_proc;

//Process to move the ball
always @(posedge clk) begin
    if((reset_n == 1'b0)) begin
        ball_center_x_proc <= 10'b0101000000;
        ball_center_y_proc <= 10'b0011011100;
    end else if(cw_ballMovement == 4'b0010) begin //Up Left
        ball_center_x_proc <= ball_center_x_proc - 10'b0000000001;
        ball_center_y_proc <= ball_center_y_proc - 10'b0000000001;
    end else if(cw_ballMovement == 4'b0011) begin //Down Right
        ball_center_x_proc <= ball_center_x_proc - 10'b0000000001;
        ball_center_y_proc <= ball_center_y_proc + 10'b0000000001;
    end else if(cw_ballMovement == 4'b0100) begin //Up Right
        ball_center_x_proc <= ball_center_x_proc + 10'b0000000001;
        ball_center_y_proc <= ball_center_y_proc - 10'b0000000001;
    end else if(cw_ballMovement == 4'b0001) begin //Down Right
        ball_center_x_proc <= ball_center_x_proc + 10'b0000000001;
        ball_center_y_proc <= ball_center_y_proc + 10'b0000000001;
    end 
    else if(cw_ballMovement == 4'b0101) begin //Reset
        ball_center_x_proc <= 10'b0101000000;
        ball_center_y_proc <= 10'b0011011100;
    end
end

assign ball_center_x = ball_center_x_proc;
assign ball_center_y = ball_center_y_proc;

endmodule