#MOV INSTRUCTION

//It copies the second operand called SOURCE to the first operand called DESTINATION

        MOV     AX, 7

//Types of operand supported

        MOV     REG, MEMORY
        MOV     MEMORY, REG
        MOV     REG, REG
        MOV     MEMORY, IMMIDIATE
        MOV     REG, IMMIDIATE
        //Note: MOV MEM, MEM is not supported
       
       // REG           AX,BX,AH,AL,CH,CL,CX,DI,SI...ETC
       // IMMIDIATE     7, -11, 4FH,...ETC
       // MEMORY        [BX] or [BX+SI] + DISPLACEMENT  
                //The combination of (BX ,SI, DI, BP) registers inside [] can be use to acces the memory
                        //EX: [BX+SI] 
                        //    [SI]
                        //    [BP+DI]+DISP
                        //Note: read ADRS MODE (addressing mode) & PHYCAL ADDR CALC (physycal address calculation)

        MOV     AX, BX          //REG, REG
        MOV     [BX], AX        //MEM, REG
        MOV     AX, [BX]        //REG, MEM
        MOV     [BX+SI], 5      //MEM, IMMEDIATE
        MOV     AX, 5           //REG, IMMEDIATE


#ADD INSTRUCTION

        ADD     DESTINATION, SOURCE     //The result is stored in destination

        //EX:  AX = 11H , BX = 14H
        ADD     AX, BX       // AX = 25H

        //Types of operands supported
        //Destination, Source

        ADD     AX, BX          //REG, REG
        ADD     [BX], AX        //MEMORY, REG
        ADD     AX, [BX]        //REG, MEMORY
        ADD     [BX], 7         //MEMORY, IMMEDIATE
        ADD     CL, 40H         //REG, IMMEDIATE

#SUB INSTRUCTION       

        MOV     CH, 22H
        SUB     CH, 11H  // Now CH = 11H
        //If SUB CH, 44H... FLAGS
        //Z = 0, C = 1, S = 1

        MOV     CH, 12H
        SUB     CH, 12H //Now CH = 0
        //Flag Z = 1 //Z FLags are set to 1, C = 0

        MOV     CH, 21H
        SUB     CH, 11H //Now CH = 10H
        //Z = 0, C = 0, S = 0

        MOV     CH, 12H
        SUB     CH, 24H
        //Z = 0, S = 1, C = 1


#MUL & IMUL INSTRUCTION

        MUL     SOURCE  //only one operand
                        //source ->reg/mem
                //assumes one operand in AL or AX
                //Result AL = AL * BL (8bits)
                //       AX = AX * BX (16bits)
        //Note: immediate multiplication is not allowed. 
        ¡NO! MUL 7 is meaningless

        MOV     AL, 7H
        MOV     BL, 7H  //keeps immediate data in BL register
        MUL     BL      //AL = 7H * 7H = 49H

        #signed numers
        MOV     AL, 35H
        MOV     BL, 7H          //keeps immediate data in BL

        IMUL    BL      //AX = 00F5H or +245
        //it uses Overflow flag, C = 1

        #IMUL
        MOV     AL, -5H
        MOV     BL, 7H
        IMUL    BL      //Result: -35H


#DIV & IDIV INSTRUCTION

        DIV     SOURCE //source->reg/mem
        //Note: immediate divition is not available
        ¡NO! DIV 7H
        //An interruption is generated when an error occurs
        //i) DIV by CERO
        //ii)Devide overflow

        MOV     AX, 0041H
        MOV     BL, 02H 
        DIV     BL
        //AL = 20 (QUOTIENT)
        //AH = 01 (REMAINDER)



        
        









