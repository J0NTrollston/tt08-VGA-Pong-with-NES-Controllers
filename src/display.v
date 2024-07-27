`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TinyTapeout 8
// Engineer: Brandon S. Ramos
// 
// Create Date: 07/15/2024 08:46:47 PM
// Design Name: 
// Module Name: display.v
// Project Name: VGA Pong with NES Controllers
// Target Devices: 
// Tool Versions: 
// Description: Location of the objects and where to display pixels
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module display(
    input wire [9:0] column,
    input wire [9:0] row,
    
    output wire r,
    output wire g,
    output wire b,
    
    input wire [9:0] leftPaddle,
    input wire [9:0] rightPaddle,
    
    input wire [9:0] ball_center_x,
    input wire [9:0] ball_center_y
    );
    
wire inside_border, lines, white, paddles, ball;
    
//Make sure all pixels are drawn in the border
assign inside_border = ((column>=20 && column<=620) || (row>=20 && row <=460)) ? 1'b1 : 1'b0;

//verticle border lines
assign lines = ((row >= 20) && (row <= 420) && (column == 20)) 
                            || ((row >= 20) && (row <= 420) && (column == 620))
                            || ((column >= 20) && (column <= 620) && (row == 20))
                            || ((column >= 20) && (column <= 620) && (row == 420)) ? 1'b1 : 1'b0;  
    
////horizontal border lines
//assign horizontal_lines = ((column >= 20) && (column <= 620) && (row == 20)) 
//                            || ((column >= 20) && (column <= 620) && (row == 420)) ? 1'b1 : 1'b0;
                            
//Gives the balls location depending on the x and y coordinates given in datapath                 
assign ball =  ((column == ball_center_x) && (row == ball_center_y-4))
            || ((column == ball_center_x+1) && (row == ball_center_y-4))
            || ((column == ball_center_x-1) && (row == ball_center_y-4))
            
            || ((column == ball_center_x-2) && (row == ball_center_y-3))
            || ((column == ball_center_x-1) && (row == ball_center_y-3))
            || ((column == ball_center_x)   && (row == ball_center_y-3))
            || ((column == ball_center_x+1) && (row == ball_center_y-3))
            || ((column == ball_center_x+2) && (row == ball_center_y-3))
            
            || ((column == ball_center_x-3) && (row == ball_center_y-2))
            || ((column == ball_center_x-2) && (row == ball_center_y-2))
            || ((column == ball_center_x-1) && (row == ball_center_y-2))
            || ((column == ball_center_x) && (row == ball_center_y-2))
            || ((column == ball_center_x+1) && (row == ball_center_y-2))
            || ((column == ball_center_x+2) && (row == ball_center_y-2))
            || ((column == ball_center_x+3) && (row == ball_center_y-2))
            
            || ((column == ball_center_x-4) && (row == ball_center_y-1))
            || ((column == ball_center_x-3) && (row == ball_center_y-1))
            || ((column == ball_center_x-2) && (row == ball_center_y-1))
            || ((column == ball_center_x-1) && (row == ball_center_y-1))
            || ((column == ball_center_x) && (row == ball_center_y-1))
            || ((column == ball_center_x+1) && (row == ball_center_y-1))
            || ((column == ball_center_x+2) && (row == ball_center_y-1))
            || ((column == ball_center_x+3) && (row == ball_center_y-1))
            || ((column == ball_center_x+4) && (row == ball_center_y-1))
            
            || ((column == ball_center_x-4) && (row == ball_center_y))
            || ((column == ball_center_x-3) && (row == ball_center_y))
            || ((column == ball_center_x-2) && (row == ball_center_y))
            || ((column == ball_center_x-1) && (row == ball_center_y))
            || ((column == ball_center_x) && (row == ball_center_y))
            || ((column == ball_center_x+1) && (row == ball_center_y))
            || ((column == ball_center_x+2) && (row == ball_center_y))
            || ((column == ball_center_x+3) && (row == ball_center_y))
            || ((column == ball_center_x+4) && (row == ball_center_y))
            
            || ((column == ball_center_x-4) && (row == ball_center_y+1))
            || ((column == ball_center_x-3) && (row == ball_center_y+1))
            || ((column == ball_center_x-2) && (row == ball_center_y+1))
            || ((column == ball_center_x-1) && (row == ball_center_y+1))
            || ((column == ball_center_x) && (row == ball_center_y+1))
            || ((column == ball_center_x+1) && (row == ball_center_y+1))
            || ((column == ball_center_x+2) && (row == ball_center_y+1))
            || ((column == ball_center_x+3) && (row == ball_center_y+1))
            || ((column == ball_center_x+4) && (row == ball_center_y+1))
            
            || ((column == ball_center_x-3) && (row == ball_center_y+2))
            || ((column == ball_center_x-2) && (row == ball_center_y+2))
            || ((column == ball_center_x-1) && (row == ball_center_y+2))
            || ((column == ball_center_x) && (row == ball_center_y+2))
            || ((column == ball_center_x+1) && (row == ball_center_y+2))
            || ((column == ball_center_x+2) && (row == ball_center_y+2))
            || ((column == ball_center_x+3) && (row == ball_center_y+2))
            
            || ((column == ball_center_x-2) && (row == ball_center_y+3))
            || ((column == ball_center_x-1) && (row == ball_center_y+3))
            || ((column == ball_center_x)   && (row == ball_center_y+3))
            || ((column == ball_center_x+1) && (row == ball_center_y+3))
            || ((column == ball_center_x+2) && (row == ball_center_y+3))
            
            || ((column == ball_center_x) && (row == ball_center_y+4))
            || ((column == ball_center_x+1) && (row == ball_center_y+4))
            || ((column == ball_center_x-1) && (row == ball_center_y+4)) ? 1'b1 : 1'b0;
                            
//This is where on the screen the left pong paddle will be drawn 
//size is 3 x 51(w x l)
assign paddles = ((column >=40 && column <= 43) 
    && (row >= (leftPaddle-25) && row <= (leftPaddle+25)) || (column >=597 && column <= 600) 
    && (row >= (rightPaddle-25) && row <= (rightPaddle+25))) ? 1'b1 : 1'b0;
    
//This is where on the screen the right pong paddle will be drawn
//size is 3 x 51(w x l)
//assign rightPaddle_en = (column >=597 && column <= 600) 
//    && (row >= (rightPaddle-25) && row <= (rightPaddle+25)) ? 1'b1 : 1'b0;
    
assign white = lines || paddles || ball;

assign r = ((inside_border == 1'b1) && (white == 1'b1)) ? 1'b1 : 1'b0;
assign g = ((inside_border == 1'b1) && (white == 1'b1)) ? 1'b1 : 1'b0;
assign b = ((inside_border == 1'b1) && (white == 1'b1)) ? 1'b1 : 1'b0;
    
endmodule
