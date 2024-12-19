/*********************************************************************
  - Project          : Direct form vs Transposed form
  - File name        : SpSram_Param_Direct.v
  - Description      : SpSram with parameterized size
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.12.10 : Initial release
*********************************************************************/
`timescale 1ns/10ps

module SpSram_Param_Direct #(
  parameter DATA_WIDTH = 16,  // Data width
  parameter ADDR_DEPTH = 33   // Address depth
)(
  // Clock & reset
  input                    iClk_12M,            // Rising edge
  input                    iRsn,               // Sync. & low reset

  // SP-SRAM Input & Output
  input                    iCsnRam,            // Chip selected @ low
  input                    iWrnRam,            // 0: Write, 1: Read
  input       [5:0]        iAddrRam,           // Data address
  input signed [DATA_WIDTH-1:0] iWrDtRam,      // Write data

  output reg signed [DATA_WIDTH-1:0] oCoeff1,
  output reg signed [DATA_WIDTH-1:0] oCoeff2,
  output reg signed [DATA_WIDTH-1:0] oCoeff3,
  output reg signed [DATA_WIDTH-1:0] oCoeff4,
  output reg signed [DATA_WIDTH-1:0] oCoeff5,
  output reg signed [DATA_WIDTH-1:0] oCoeff6,
  output reg signed [DATA_WIDTH-1:0] oCoeff7,
  output reg signed [DATA_WIDTH-1:0] oCoeff8,
  output reg signed [DATA_WIDTH-1:0] oCoeff9,
  output reg signed [DATA_WIDTH-1:0] oCoeff10,
  output reg signed [DATA_WIDTH-1:0] oCoeff11,
  output reg signed [DATA_WIDTH-1:0] oCoeff12,
  output reg signed [DATA_WIDTH-1:0] oCoeff13,
  output reg signed [DATA_WIDTH-1:0] oCoeff14,
  output reg signed [DATA_WIDTH-1:0] oCoeff15,
  output reg signed [DATA_WIDTH-1:0] oCoeff16,
  output reg signed [DATA_WIDTH-1:0] oCoeff17,
  output reg signed [DATA_WIDTH-1:0] oCoeff18,
  output reg signed [DATA_WIDTH-1:0] oCoeff19,
  output reg signed [DATA_WIDTH-1:0] oCoeff20,
  output reg signed [DATA_WIDTH-1:0] oCoeff21,
  output reg signed [DATA_WIDTH-1:0] oCoeff22,
  output reg signed [DATA_WIDTH-1:0] oCoeff23,
  output reg signed [DATA_WIDTH-1:0] oCoeff24,
  output reg signed [DATA_WIDTH-1:0] oCoeff25,
  output reg signed [DATA_WIDTH-1:0] oCoeff26,
  output reg signed [DATA_WIDTH-1:0] oCoeff27,
  output reg signed [DATA_WIDTH-1:0] oCoeff28,
  output reg signed [DATA_WIDTH-1:0] oCoeff29,
  output reg signed [DATA_WIDTH-1:0] oCoeff30,
  output reg signed [DATA_WIDTH-1:0] oCoeff31,
  output reg signed [DATA_WIDTH-1:0] oCoeff32,
  output reg signed [DATA_WIDTH-1:0] oCoeff33
);

  // Integer declaration
  integer          i;

  // wire & reg declaration
  reg  [DATA_WIDTH-1:0] rMem [1:ADDR_DEPTH]; // Memory array

  /*************************************************************/
  // SP-SRAM function
  /*************************************************************/
  // rMem write operation
  always @(posedge iClk_12M)
  begin
    // Synchronous & low reset
    if (!iRsn)
    begin
      for (i = 1; i <= ADDR_DEPTH; i = i + 1)
      begin
        rMem[i] <= {DATA_WIDTH{1'b0}};
      end
    end
    // Write condition
    else if (iCsnRam == 1'b0 && iWrnRam == 1'b0)
    begin
      rMem[iAddrRam] <= iWrDtRam;
    end
  end

  // rMem read operation
  always @(*) begin
    // Synchronous & low reset
    if (!iRsn) begin
      oCoeff1  <= {DATA_WIDTH{1'b0}};
      oCoeff2  <= {DATA_WIDTH{1'b0}};
      oCoeff3  <= {DATA_WIDTH{1'b0}};
      oCoeff4  <= {DATA_WIDTH{1'b0}};
      oCoeff5  <= {DATA_WIDTH{1'b0}};
      oCoeff6  <= {DATA_WIDTH{1'b0}};
      oCoeff7  <= {DATA_WIDTH{1'b0}};
      oCoeff8  <= {DATA_WIDTH{1'b0}};
      oCoeff9  <= {DATA_WIDTH{1'b0}};
      oCoeff10 <= {DATA_WIDTH{1'b0}};
      oCoeff11 <= {DATA_WIDTH{1'b0}};
      oCoeff12 <= {DATA_WIDTH{1'b0}};
      oCoeff13 <= {DATA_WIDTH{1'b0}};
      oCoeff14 <= {DATA_WIDTH{1'b0}};
      oCoeff15 <= {DATA_WIDTH{1'b0}};
      oCoeff16 <= {DATA_WIDTH{1'b0}};
      oCoeff17 <= {DATA_WIDTH{1'b0}};
      oCoeff18 <= {DATA_WIDTH{1'b0}};
      oCoeff19 <= {DATA_WIDTH{1'b0}};
      oCoeff20 <= {DATA_WIDTH{1'b0}};
      oCoeff21 <= {DATA_WIDTH{1'b0}};
      oCoeff22 <= {DATA_WIDTH{1'b0}};
      oCoeff23 <= {DATA_WIDTH{1'b0}};
      oCoeff24 <= {DATA_WIDTH{1'b0}};
      oCoeff25 <= {DATA_WIDTH{1'b0}};
      oCoeff26 <= {DATA_WIDTH{1'b0}};
      oCoeff27 <= {DATA_WIDTH{1'b0}};
      oCoeff28 <= {DATA_WIDTH{1'b0}};
      oCoeff29 <= {DATA_WIDTH{1'b0}};
      oCoeff30 <= {DATA_WIDTH{1'b0}};
      oCoeff31 <= {DATA_WIDTH{1'b0}};
      oCoeff32 <= {DATA_WIDTH{1'b0}};
      oCoeff33 <= {DATA_WIDTH{1'b0}};
    end else if (iCsnRam == 1'b0 && iWrnRam == 1'b1) begin
			case (iAddrRam)
      6'd1:   oCoeff1  <= rMem[1];
      6'd2:   oCoeff2  <= rMem[2];
      6'd3:   oCoeff3  <= rMem[3];
      6'd4:   oCoeff4  <= rMem[4];
      6'd5:   oCoeff5  <= rMem[5];
      6'd6:   oCoeff6  <= rMem[6];
      6'd7:   oCoeff7  <= rMem[7];
      6'd8:   oCoeff8  <= rMem[8];
      6'd9:   oCoeff9  <= rMem[9];
      6'd10:  oCoeff10 <= rMem[10];
      6'd11:  oCoeff11 <= rMem[11];
      6'd12:  oCoeff12 <= rMem[12];
      6'd13:  oCoeff13 <= rMem[13];
      6'd14:  oCoeff14 <= rMem[14];
      6'd15:  oCoeff15 <= rMem[15];
      6'd16:  oCoeff16 <= rMem[16];
      6'd17:  oCoeff17 <= rMem[17];
      6'd18:  oCoeff18 <= rMem[18];
      6'd19:  oCoeff19 <= rMem[19];
      6'd20:  oCoeff20 <= rMem[20];
      6'd21:  oCoeff21 <= rMem[21];
      6'd22:  oCoeff22 <= rMem[22];
      6'd23:  oCoeff23 <= rMem[23];
      6'd24:  oCoeff24 <= rMem[24];
      6'd25:  oCoeff25 <= rMem[25];
      6'd26:  oCoeff26 <= rMem[26];
      6'd27:  oCoeff27 <= rMem[27];
      6'd28:  oCoeff28 <= rMem[28];
      6'd29:  oCoeff29 <= rMem[29];
      6'd30:  oCoeff30 <= rMem[30];
      6'd31:  oCoeff31 <= rMem[31];
      6'd32:  oCoeff32 <= rMem[32];
      6'd33:  oCoeff33 <= rMem[33];
      default: ; // No action
      endcase
    end
  end
endmodule
