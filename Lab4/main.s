.text
.global _start
.extern PrintString

_start: 
movia sp, 0x7FFFFC

movia r2, MSG
call PrintString
movia r2, MSG2
call PrintString
call GetChar
movia r5, MSG
movi r6, ' '
mov r3, r0
mov r4, r0
WHILE:
IF:
	ldb r3,0(r5)
	beq r3, r0, ENDWHILE
	beq r3, r6, THEN
	br ENDIF
THEN:
	stb r2,0(r5)
	addi r4, r4, 1
ENDIF:
	addi r5,r5,1
	ldb r3,0(r5)
	br WHILE
ENDWHILE:
movi r2, '\n'
call PrintChar
movia r2, MSG
call PrintString
movia r6, COUNT
stw r4, 0(r6)

_end: 
break

# ----------------------------------------

.data

COUNT: .skip 4

MSG: .asciz "ELEC 274 Lab 4\n"
MSG2: .asciz "Type Replace char:\n"


.end