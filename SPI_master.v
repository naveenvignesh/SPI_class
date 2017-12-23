module SPI_master(BCLK,SCLK,MISO,MOSI,SS,SS_SEL)
input   BCLK;    // bus clock from PLL
inout   SCLK;    // Serial clock generated/received to do transmission
inout   MOSI;    // Master out or slave input 
inout   MISO;    // Master input or slave output
inout   SS;      // Slave select signal

// registers
reg [7:0] BREG0 // SPICR1;
reg [7:0] BREG1 // SPICR2;
reg [7:0] BREG2 // SPIBR;
reg [7:0] BREG3 // SPISR;
reg [7:0] BREG4 // resv;
reg [7:0] BREG5 // SPIDR;
reg [7:0] BREG6 // resv;
reg [7:0] BREG7 // resv;

reg       read_reg;
reg       reg_addr;
reg [7:0] w_data,r_data,write_reg;

//handling inout ports
   wire   mst_out,mst_in;
   wire   slv_out,slv_in;

   assign MOSI = mode ? mst_out:1'bz;
   assign MISO = mode ? slv_out:1'bz;
   assign mst_in = MISO;
   assign slv_in = MOSI;
 
   
always @(posedge BCLK or negedge RST) begin 
  if (~RST) begin 
      BREG0 <= #0 8'h0;
      BREG1 <= #0 8'h0;
      BREG2 <= #0 8'h0;
      BREG3 <= #0 8'h0;
      BREG4 <= #0 8'h0;
      BREG5 <= #0 8'h0;
      BREG6 <= #0 8'h0;
      BREG7 <= #0 8'h0;
  end else begin 
      BREG0 <= #1 write_reg[0]? w_data:BREG0 ;
      BREG1 <= #1 write_reg[1]? w_data:BREG1 ;
      BREG2 <= #1 write_reg[2]? w_data:BREG2 ;
      BREG3 <= #1 write_reg[3]? w_data:BREG3 ;
      BREG4 <= #1 write_reg[4]? w_data:BREG4 ;
      BREG5 <= #1 write_reg[5]? w_data:BREG5 ;
      BREG6 <= #1 write_reg[6]? w_data:BREG6 ;
      BREG7 <= #1 write_reg[7]? w_data:BREG6 ;
           end
end 

always @(*) begin 
  write_reg=8'h0;
  r_data= 8'h0;  

  case(reg_addr)
   8'h00: write_reg[0] = 1'b1;
   8'h01: write_reg[1] = 1'b1;
   8'h02: write_reg[2] = 1'b1;
   8'h03: write_reg[3] = 1'b1;
   8'h04: write_reg[4] = 1'b1;
   8'h05: write_reg[5] = 1'b1;
   8'h06: write_reg[6] = 1'b1;
   8'h07: write_reg[7] = 1'b1;
  endcase

  case(reg_addr)
   8'h00: r_data= BREG0;
   8'h01: r_data= BREG1;
   8'h02: r_data= BREG2;
   8'h03: r_data= BREG3;
   8'h04: r_data= BREG4;
   8'h05: r_data= BREG5;
   8'h06: r_data= BREG6;
   8'h07: r_data= BREG7;
  endcase
end 

endmodule
