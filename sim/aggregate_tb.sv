`timescale 1ns / 1ps
`default_nettype none

`define MESSAGE 168'h4261_7272_7921_2042_7265_616b_6661_7374_2074_696d65

module aggregate_tb;

    //make logics for inputs and outputs!
    logic clk;
    logic rst;
    logic axiiv;
    logic [1:0] axiid;
    logic axiov;
    logic [31:0] axiod;

    aggregate uut(.rst(rst),
                         .clk(clk),
                         .axiiv(axiiv),
                         .axiid(axiid),
                         .axiov(axiov),
                         .axiod(axiod));
    always begin
        #10;  //every 10 ns switch...so period of clock is 20 ns...50 MHz clock
        clk = !clk;
    end

    logic [63:0] message = 64'h12345678_00000000;

    //initial block...this is our test simulation
    initial begin
        $dumpfile("aggregate.vcd"); //file to store value change dump (vcd)
        $dumpvars(0,aggregate_tb); //store everything at the current level and below
        $display("Starting Sim"); //print nice message
        clk = 0; //initialize clk (super important)
        rst = 0; //initialize rst (super important)
        axiiv = 2'b0;
        axiid = 1'b0;

        #10  //wait a little bit of time at beginning
        rst = 1; //reset system
        #20; //hold high for a few clock cycles
        rst= 0;
        #20;

        #60;

        for (int v = 2; v > 0; v= v-2)begin
          axiid = {message[v], message[v-1]};
          axiiv = 1'b1;
          #20;

        end

        axiiv = 1'b0;

        #500


        for (int v = 31; v > 0; v= v-2)begin
          axiid = {message[v], message[v-1]};
          axiiv = 1'b1;
          #20;

        end

        axiiv = 1'b0;

        #500


        for (int v = 63; v > 0; v= v-2)begin
          axiid = {message[v], message[v-1]};
          axiiv = 1'b1;
          #20;

        end

        axiiv = 0;

        #500


        for (int v = 63; v > 0; v= v-2)begin
          axiid = {message[v], message[v-1]};
          axiiv = 1'b1;
          #20;

        end

        axiiv = 0;

        #500

          $display("Finishing Sim"); //print nice message
    $finish;
    end

endmodule

`default_nettype wire