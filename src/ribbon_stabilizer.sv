
`timescale 1ns / 1ps
`default_nettype none

module ribbon_stabilizer (
  input wire clk,
  input wire rst,
  input wire [7:0] r_val,
  
  output logic [7:0] r_val_s
  );


  logic [31:0] count;
  logic [7:0] r_max; 

  always_ff @(posedge clk) begin

    if (rst) begin
      r_val_s <= 0;
      count <= 0;
      r_max <= 0;
    end

    else begin
      if (count == 4091) begin
        count <= 0;
        r_val_s <= r_max;
        r_max <= 0;
      end

      else begin
        count <= count + 1;
        if (r_val > r_max) r_max <= r_val;
      end
    end

  end
  

endmodule




`default_nettype wire