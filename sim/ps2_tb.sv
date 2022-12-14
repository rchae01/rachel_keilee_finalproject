`timescale 1ns / 1ps
`default_nettype none

module ps2_tb;

  //make logics for inputs and outputs!
  logic clk_in;
  logic rst_in;
  logic d_out;
  logic d_in;
  logic cs;
  logic clk2;
  logic [15:0] led;
  logic ca, cb, cc, cd, ce, cf, cg;
  logic [7:0] an;

  logic [10:0] frame = 11'b01011001011;
  top_level uut(.clk(clk_in),
                  .btnc(rst_in),
                  .d_out(d_out),
                  .d_in(d_in),
                  .cs(cs)
                  .clk2(clk2)
                  .led(led),
                  .ca(ca),
                  .cb(cb),
                  .cc(cc),
                  .cd(cd),
                  .ce(ce),
                  .cf(cf),
                  .cg(cg),
                  .an(an)
                );
  always begin
    #5;  //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
    clk_in = !clk_in;
  end

  //initial block...this is our test simulation
  initial begin
    $dumpfile("top_level.vcd"); //file to store value change dump (vcd)
    $dumpvars(0,ps2_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk_in = 0;
    rst_in = 0;
    #20  //wait
    rst_in = 1;
    #20; //hold
    rst_in=0;
    #20;
    for(int i=0; i<11; i=i+1)begin
      ps_data_in = frame[10-i];
      #100;
      ps_clk_in = 0;
      #100;
    end
    #600
     for(int i=0; i<11; i=i+1)begin
      ps_clk_in = 1;
      ps_data_in = frame[10-i];
      #100;
      ps_clk_in = 0;
      #100;
    end
    #600


    $finish;

  end
endmodule //counter_tb

`default_nettype wire
