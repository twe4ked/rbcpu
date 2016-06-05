; => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
;
; 30: "counter"
; 31: "parent"
; 32: "grandparent"
; 33: "loop"

LDA #1
STO #0
STO #1
STO #30   ; set "counter" to 1

STO #31   ; store current number at "parent"
STO #32   ; store current number at "grandparent"

LDA #10
STO #33   ; set "loop" to 10

LDA 30    ; load "counter"
ADD #1    ; increment "counter"
STO #30   ; store in "counter"

LDA 32    ; load "grandparent"
ADD 31    ; add "parent"
STO 30    ; store at "counter" position
STO #34   ; store at "current"

LDA 31    ; load "parent"
STO #32   ; store in "grandparent"

LDA 34    ; load the number at "counter"
STO #31   ; store the current number at "parent"

LDA 33    ; load "loop"
SUB #1    ; decrement "loop"
STO #33   ; store in "loop"
JNZ #19   ; jump to line 19 until "loop" is 0
