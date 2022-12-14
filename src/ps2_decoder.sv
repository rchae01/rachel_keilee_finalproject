
`default_nettype none
module ps2_decoder( input wire clk_in,
  input wire rst_in,
  input wire ps_data_in,
  input wire ps_clk_in,
  output logic [7:0] code_out,
  output logic code_valid_out
);
  
  integer i;
  logic [9:0] out;
  logic last_ps_clk;
  logic last_rst;
  
  always_ff @(posedge clk_in) begin
    if ((last_rst== 0) && (rst_in == 1)) begin
      code_out <= 0;
      out <= 9'b0;
      code_valid_out <= 0;
      i <= 0;
    end

    else if (i == 11) begin
      code_out <= out[8:1];
      out <= 0;
      i <= 0;
      if (((out[1]^out[2])^(out[3]^out[4])^(out[5]^out[6])^(out[7]^out[8])) != out[9]) begin
        code_valid_out <= 1'b1;
      end
    end

    else if ((ps_clk_in == 0) && (last_ps_clk == 1)) begin
      out[i] <= ps_data_in;
      i <= i + 1;
      code_out <= 0;
    end


    last_ps_clk <= ps_clk_in;
    last_rst <= rst_in;

    if (code_valid_out) code_valid_out <= 1'b0;
  end

endmodule
`default_nettype wire