#DATA TYPE

1. DB   (DEFINE BYTE)
2. DW   (DEFINE WORD)(LARGER VALUES)
3. DD   (DEFINE DOUBLEWORD)
4. DQ   (DEFINE QUADWORD)

DECLARATION

        VAR_NAME     TYPE    VALUE
1.          A         DB       9
         MESSAGE      DB  'HELLOWORLD'

HERE A DATABYTE MEMORY IS ALLOCATED FOR EACH CHARACTER

        VAR_NAME     TYPE    VALUE
2.         VAR        DW     1122H


STRINGS

        STR1    DB      "HELLO WORLD"
        STR2    DB      "HELLO WORLD",'$'               //$ FOR END OF STRING '\0'
        STR3    DB      10,13, "HELLO WOLRD",'$'        //10,13 FOR NEW LINE  '\n'

ARRAYS

        name    type    value 
        a       DB      1h,2h,3Fh,7Fh
        b       DW      1111h,2222h,333h

        ACCESING VALUE FROM ARRAY:
                
                a       db      22h,23h,24h,25h
                                a[0],a[1],a[2],a[3]
                MOV     AL,a[2]
                or
                MOV     SI, 2
                MOV     AL, a[SI]

        ARRAY DECLARATION USING DUP
        DUP OR dup STANDS FOR DUPLICATE
                X       DB      3 DUP(7)       ==       X       DB      7,7,7
                Y       DB      3 DUP(5,6)     ==       Y       DB      5,6,5,6,5,6

        EMPTY ARRAY
                VAR     DB      10 DUP(?)      ==       int var[10] = {0}

        
        



    

