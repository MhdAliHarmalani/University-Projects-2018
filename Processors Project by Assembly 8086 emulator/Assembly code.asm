include "emu8086.inc"
org 100h 
jmp start

gameNameMsg db "The Harmalani Code$" 
gameRulesMsg1 db "Welcome in The Harmalani Code game...$"  
gameRulesMsg2 db "To win you should find the correct code according to the following rules:$"  
gameRulesMsg3 db "1- # means: There is correct number at wrong position.$"
gameRulesMsg4 db "2- * means: There is correct number at correct position.$"
;gameRulesMsg5 db "3- ! means: There is wrong number.$"
gameRulesMsg6 db "- All characters should be numbers from 0 th 9.$"
gameRulesMsg7 db "- There is no repetition in the code numbers.$" 
gameRulesMsg8 db "To Start Game Press any key...$"
gameMsg1 db "Enter the correct code to find it (YOU MUST enter just 3 digit and DON'T REPEAT NUMBERS):$" 
gameMsgTry db "Try $"
gameMsgWin db "You Win :)$"
gameMsglose db "Game Over :($"
gameMsg2 db "The correct code (:p) is:$"

codeRef db 4,5 dup(0),'$'
codeUser db 4,5 dup(0),'$' 

start:
gotoxy 30,0
lea dx,gameNameMsg
mov ah,9
int 21h 
putc 10
putc 13
lea dx,gameRulesMsg1
mov ah,9
int 21h
putc 10
putc 13 
lea dx,gameRulesMsg2
mov ah,9
int 21h
putc 10
putc 13
lea dx,gameRulesMsg3
mov ah,9
int 21h
putc 10
putc 13
lea dx,gameRulesMsg4
mov ah,9
int 21h
;putc 10
;putc 13
;lea dx,gameRulesMsg5
;mov ah,9
;int 21h
putc 10
putc 13
lea dx,gameRulesMsg6
mov ah,9
int 21h
putc 10
putc 13
lea dx,gameRulesMsg7
mov ah,9
int 21h
putc 10
putc 13 
lea dx,gameRulesMsg8
mov ah,9
int 21h
putc 10
putc 13
CURSOROFF


mov ah,01h
int 21h 
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again. 
putc 10
putc 13

lea dx,gameMsg1
mov ah,9
int 21h
CURSORON 




mov bx,0; now bx is address rigister for code 

lea bx,codeRef+1
mov [bx],3 ;actual value in codeRef array because it was null becouse I haven't enter it as string
inc bx  
 
mov cl,3
jmp next_digit


next_digit:
mov ah,01h
int 21h


 ;allow_only_digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:
        CMP     AL, '9'
        JBE     next_digit1
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again. 
        jmp next_digit
        
        
         
next_digit1:

mov [bx] , al

inc bx        
dec cl       
jnz     next_digit ; wait for next input.      
       
       
       
        ;remove CodeRef
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.
        
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.
        
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.


putc 10 
putc 13

 


mov si,5
TryLoop: 

putc 10
putc 13

mov bp,0 ;winStar counter

lea dx,gameMsgTry
mov ah,9
int 21h
 
;to print number of attempts "Try 5 to 1" 
mov ax,si ;becuse ax will be changed with interrupt 
CALL   print_num
;

putc 10
putc 13 

lea dx,codeUser
mov ah,0ah
int 21h 

putc 10
putc 13 



;;Algorithim
lea bx,codeRef+2
lea di,codeUser+2

mov ch,1 ;for bx means for codeRef    i=1
mov cl,1 ;for di means for codeUser   j=1


jmp AlgLoop 

continue1:
lea di,codeUser+2
inc bx 

inc ch ;to count i of array in codeRef i=i+1 
mov cl,1; j=0

mov sp,0 ;;
mov sp,[bx]
 
;RCL dx,1 ;RCL means shift all bit to left and use CF to instead of the values  
mov al,8
ShiftLoop1:
clc ;;CF=0 
RCL sp,1

dec al
jnz ShiftLoop1 


cmp sp, 0h ;' ';" " or 13 means enter button

jz TryLoopdown
jnz AlgLoop

AlgLoop:
;mov bp,3

mov sp,0;;
mov dx,0;;
mov sp,[bx];sp for codeRef 
mov dx,[di];dx for codeUser 

;RCL dx,1 ;RCL means shift all bit to left and use CF to instead of the values  
mov al,8
ShiftLoop2:
clc ;;CF=0 
RCL sp,1 
clc
RCL dx,1

dec al
jnz ShiftLoop2 




continue2:
cmp sp,dx
jz printStar ;sp=dx means correct number at the correct position
jnz search   ;sp<>dx search in CodeUser about sp


;dec bp
;jnz AlgLoop
;jmp AlgLoop

;; 
TryLoopdown:
dec si
jnz TryLoop
jz EndGameOver  
  

printStar:

cmp ch,cl;compare if the correct number at the correct postion i==j
jz printStar1   ;print *
jnz printStar2  ;print #

printStar1: 
putc '*'
inc bp

;;Win Statuse

cmp bp,3
jz youWin

jmp EndStar

printStar2:
putc '#'
jmp EndStar

EndStar:


jmp search
;jmp continue
;or jmp trueCodeYouWin

search:
inc di 
inc cl ;to count j of array in codeUser j=j+1
mov dx,0;;
mov dx,[di]

;RCL dx,1 ;RCL means shift all bit to left and use CF to instead of the values  
mov al,8
ShiftLoop3:
clc ;;CF=0 
;RCL sp,1
RCL dx,1

dec al
jnz ShiftLoop3 


cmp dx, 0d00h;240Dh ;" " or 13 means enter button or '$' @@@@@@@@@@@@@@@@@@@@@@@ the problem is here fallow it by simulation and paper
jnz continue2 
jz continue1


EndGameOver:       
putc 10
putc 13
lea dx,gameMsglose
mov ah,9
int 21h
jmp EndGame

youWin:
putc 10
putc 13
lea dx,gameMsgWin
mov ah,9
int 21h

EndGame:
putc 10
putc 13
lea dx,gameMsg2
mov ah,9
int 21h
lea dx,CodeRef+2
mov ah,9
int 21h

hlt
 

define_print_num_uns
define_print_num
