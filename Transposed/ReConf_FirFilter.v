/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ReConf_FirFilter.v
  - Description      : Top module
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module ReConf_FirFilter(
	input iClk_12M,
	input iRsn,
	input iEnSample_300k,
	input iCoeffiUpdateFlag,
	input iCsnRam,
	input iWrnRam,
	input [3:0] iAddrRam,
	input signed [15:0] iWrDtRam,
	input [5:0] iNumOfCoeff,//0~40
	input signed [2:0] iFirIn,
	output signed [15:0] oFirOut
	);
	//reg [15:0] RdDtRam1, oRdDtRam2, oRdDtRam3, oRdDtRam4;
	//parameter

	integer i;

	wire [3:0] wEnMul1, wEnMul2, wEnMul3, wEnMul4;
	wire wEnAdd1, wEnAdd2, wEnAdd3, wEnAdd4;
	wire wEnAcc1, wEnAcc2, wEnAcc3, wEnAcc4;
	wire wEnDelay;
	
	//ram1
	wire wCsnRam1;
	wire wWrnRam1;
	wire [3:0] wAddrRam1;
	wire signed [15:0] wWrDtRam1;
	wire signed [15:0] wRdDtRam1;

	//ram2
	wire wCsnRam2;
	wire wWrnRam2;
	wire [3:0] wAddrRam2;
	wire signed [15:0] wWrDtRam2;
	wire signed [15:0] wRdDtRam2;

	//ram3
	wire wCsnRam3;
	wire wWrnRam3;
	wire [3:0] wAddrRam3;
	wire signed [15:0] wWrDtRam3;
	wire signed [15:0] wRdDtRam3;

	//ram4
	wire wCsnRam4;
	wire wWrnRam4;
	wire [3:0] wAddrRam4;
	wire signed [15:0] wWrDtRam4;
	wire signed [15:0] wRdDtRam4;
	
	wire signed [15:0] wMac1;
	wire signed [15:0] wMac2;
	wire signed [15:0] wMac3;
	wire signed [15:0] wMac4;
	
	wire signed  [2:0] wDelay1;
	wire signed  [2:0] wDelay2;
	wire signed  [2:0] wDelay3;
	wire signed  [2:0] wDelay4;

	//SpSram instance 
    SpSram_10x16 SpSram1(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam1),
        .iWrnRam(wWrnRam1),
        .iAddrRam(wAddrRam1),
        .iWrDtRam(wWrDtRam1),
        .oRdDtRam(wRdDtRam1)
    );
	
    SpSram_10x16 SpSram2(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam2),
        .iWrnRam(wWrnRam2),
        .iAddrRam(wAddrRam2),
        .iWrDtRam(wWrDtRam2),
        .oRdDtRam(wRdDtRam2)
    );

    SpSram_10x16 SpSram3(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam3),
        .iWrnRam(wWrnRam3),
        .iAddrRam(wAddrRam3),
        .iWrDtRam(wWrDtRam3),
        .oRdDtRam(wRdDtRam3)
    );

    SpSram_10x16 SpSram4(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam4),
        .iWrnRam(wWrnRam4),
        .iAddrRam(wAddrRam4),
        .iWrDtRam(wWrDtRam4),
        .oRdDtRam(wRdDtRam4)
    );


	//FSM
	Controller Controller(
		.iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iEnSample_300k(iEnSample_300k),
		.iCsnRam(iCsnRam),
        .iWrnRam(iWrnRam),
        .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
        .iAddrRam(iAddrRam),   
		.iWrDtRam(iWrDtRam),
		.iNumOfCoeff(iNumOfCoeff),
        .oEnDelay(wEnDelay), //10개

        .oEnMul1(wEnMul1),
        .oEnAdd1(wEnAdd1),
        .oEnAcc1(wEnAcc1),
        .oEnMul2(wEnMul2),
        .oEnAdd2(wEnAdd2),
        .oEnAcc2(wEnAcc2),
        .oEnMul3(wEnMul3),
        .oEnAdd3(wEnAdd3),
        .oEnAcc3(wEnAcc3),
        .oEnMul4(wEnMul4),
        .oEnAdd4(wEnAdd4),
        .oEnAcc4(wEnAcc4),//12개

        // Outputs for RAMs
        .oWrDtRam1(wWrDtRam1),
        .oAddrRam1(wAddrRam1),
        .oWrnRam1(wWrnRam1),
        .oCsnRam1(wCsnRam1),

        .oWrDtRam2(wWrDtRam2),
        .oAddrRam2(wAddrRam2),
        .oWrnRam2(wWrnRam2),
        .oCsnRam2(wCsnRam2),

        .oWrDtRam3(wWrDtRam3),
        .oAddrRam3(wAddrRam3),
        .oWrnRam3(wWrnRam3),
        .oCsnRam3(wCsnRam3),

        .oWrDtRam4(wWrDtRam4),
        .oAddrRam4(wAddrRam4),
        .oWrnRam4(wWrnRam4),
        .oCsnRam4(wCsnRam4)
	);


//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력 
	Mul_Add_Shift MAS_1(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnSample_300k(iEnSample_300k),
		.iEnMul(wEnMul1),
		.iEnAdd(wEnAdd1),
		.iEnAcc(wEnAcc1),
		.iCoeff(wRdDtRam1),
		.iFirIn(iFirIn),
		.oMac(wMac1)
	);
//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력
	Mul_Add_Shift_2 MAS_2(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnSample_300k(iEnSample_300k),
		.iEnMul(wEnMul2),
		.iEnAdd(wEnAdd2),
		.iEnAcc(wEnAcc2),
		.iShift(wMac1),
		.iCoeff(wRdDtRam2),
		.iFirIn(iFirIn),
		.oMac(wMac2)
	);
//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력
	Mul_Add_Shift_2 MAS_3(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnMul(wEnMul3),
		.iEnAdd(wEnAdd3),
		.iEnAcc(wEnAcc3),
		.iShift(wMac2),
		.iCoeff(wRdDtRam3),
		.iDelay(wDelay3),
		.iFirIn(iFirIn),
		.oMac(wMac3)
	);
//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력
	Multiplier_Adder_Shift_Output MAS_Final(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnMul(wEnMul4),
		.iEnAdd(wEnAdd4),
		.iEnAcc(wEnAcc4),
		.iCoeff(wRdDtRam4),
		.iDelay(wDelay4),
		.oFirOut(oFirOut)
	);	
	
endmodule
	
	
	
	
	