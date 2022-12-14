`timescale 1ns / 1ps
`default_nettype none

module divider(input wire clk_in,
	       output logic sd_clk);


  logic xclk;
  logic [1:0] xclk_count;

  always_ff @(posedge clk_in) begin
    xclk_count <= xclk_count + 1;
  end

  assign sd_clk = (xclk_count > 1);

endmodule

`default_nettype wire
