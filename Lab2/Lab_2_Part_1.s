#	ELEC 274

	.equ LAST_RAM_WORD,   0x007FFFFC
	.equ JTAG_UART_BASE,  0x10001000
	.equ DATA_OFFSET,     0
	.equ STATUS_OFFSET,   4
	.equ WSPACE_MASK,     0xFFFF
	
	.text
	.global _start
	.org	0x00000000

#----------------------------------------------------------------------------------		
	
_start:
	movia	sp, LAST_RAM_WORD
	movi	r2, '\n'
	call	PrintChar
	movia	r2, MSG
	call	PrintString
	movia	r2, LIST
	call	PrintHexList
	movi	r2, '\n'
	call	PrintChar
	movia	r2, LIST
	ldw		r3, N(r0)	#Load size of the list
	call	CntMult4
	call	PrintHexDigit
	movi	r2, '\n'
	call	PrintChar
	movia	r2, LIST
	call	DoubleList
	
	call	PrintHexList
_end:
	br	_end
	
#----------------------------------------------------------------------------------		
	
PrintChar:
	subi	sp, sp, 8
	stw 	r3, 4(sp)
	stw 	r4, 0(sp)
	movia 	r3, JTAG_UART_BASE
pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)
	andhi	r4, r4, WSPACE_MASK
	beq		r4, r0, pc_loop
	stwio	r2, DATA_OFFSET(r3)
	ldw	r3, 4(sp)
	ldw 	r4, 0(sp)
	addi	sp, sp, 8
	ret

	

CntMult4:	
	subi	sp, sp, 20
	stw		ra, 16(sp)
	stw		r5, 12(sp) 		#Local List
	stw		r4, 8(sp)		#List size
	stw		r3, 4(sp)		#Current element
	stw		r2, 0(sp)		#Count
	
	mov		r4, r3		#Load size of the list
	mov		r5, r2
	mov		r2, r0
CN4_LOOP:
	ldw		r3, 0(r5)
	andi	r3, r3, 3
	
	CN4_IF:
		bgt	r3, r0, CN4_ELSE #if the r2>0
	CN4_THEN:
		addi	r2, r2, 1
	CN4_ELSE:
	CN4_END_IF:
	
	addi	r5, r5, 4		#Increment ptr to next value
	subi	r4, r4, 1
	bgt		r4, r0, CN4_LOOP
	
	ldw		ra, 16(sp)
	ldw		r5, 12(sp) 		#Local List
	ldw		r4, 8(sp)		#List size
	ldw		r3, 4(sp)		#Current element
	addi	sp, sp, 20
	ret
	
	
	
DoubleList:
	subi	sp, sp, 20
	stw		ra, 16(sp)
	stw		r5, 12(sp) 		#Local List
	stw		r4, 8(sp)		#List size
	stw		r3, 4(sp)		#Current element
	stw		r2, 0(sp)		#Count
	
	mov		r4, r3		#Load size of the list
	mov		r5, r2
DL_LOOP:
	ldw		r2, 0(r5)
	
	slli	r2, r2, 1

	
	stw		r2, 0(r5)
	addi	r5, r5, 4		#Increment ptr to next value
	
	subi	r4, r4, 1
	bgt		r4, r0, DL_LOOP
	
	ldw		ra, 16(sp)
	ldw		r5, 12(sp) 		#Local List
	ldw		r4, 8(sp)		#List size
	ldw		r3, 4(sp)		#Current element
	ldw		r2, 0(sp)
	addi	sp, sp, 20
	ret
	
	
	
	
	
PrintString:
	subi	sp, sp, 12
	stw 	ra, 8(sp)
	stw 	r3, 4(sp)
	stw 	r2, 0(sp)
	mov	r3, r2
ps_loop:
	ldb 	r2, 0(r3)
	beq 	r2, r0, end_ps_loop
	call 	PrintChar
	addi	r3, r3, 1
	br 	ps_loop
end_ps_loop:
	ldw 	ra, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	r2, 0(sp)
	addi	sp, sp, 12
	ret			

PrintHexDigit:
	subi	sp, sp, 12
	stw 	ra, 8(sp)
	stw 	r3, 4(sp)
	stw 	r2, 0(sp)
	movi	r3, 10
	
PHD_IF:
	blt	r2, r3, PHD_ELSE
PHD_THEN:
	subi 	r2, r2, 10
	addi 	r2, r2, 'A'
	br	PHD_END_IF
PHD_ELSE:
	addi	r2, r2, '0'
PHD_END_IF:
	call 	PrintChar
	ldw 	ra, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	r2, 0(sp)
	addi	sp, sp, 12
	ret
	
PrintHexList:
	subi	sp, sp, 16
	stw	ra, 12(sp)
	stw	r4, 8(sp) 		#Local pointer
	stw 	r3, 4(sp)		#List size
	stw 	r2, 0(sp)		#Original ptr to list
	
	ldw	r3, N(r0)		#Load size of the list
	mov	r4, r2
	
PHL_LOOP:
	ldw	r2, 0(r4)
	call	PrintHexDigit
	movi	r2, ','
	call 	PrintChar
	addi	r4, r4, 4		#Increment ptr to next value
	subi	r3, r3, 1
	bgt	r3, r0, PHL_LOOP
	
	movi	r2, '\n'
	call 	PrintChar
	ldw 	ra, 12(sp)
	ldw 	r4, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	r2, 0(sp)
	addi	sp, sp, 16
	ret
	
#-----------------------------------------------------------------------------

	.org	0x1000
LIST:	.word	1,10,2,12,3,16
N:		.word	6	
MSG:	.asciz	"ELEC274 Lab 2\n"
		.end
