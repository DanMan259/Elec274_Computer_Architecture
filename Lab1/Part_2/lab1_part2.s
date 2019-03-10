#--------------------------------------------------------------------------------------------
# This program demonstrates arithmetic, memory accesses, and subroutines.
#--------------------------------------------------------------------------------------------
	.equ 	LAST_RAM_WORD, 0x007FFFFC 	# last word location in DRAM chip
	
	.text								# needed to indicate the start of a code segment
	.global _start						# makes the _start symbol visible to the linker
	.org 	0x00000000					# starting memory location for following content
	
_start:
	movia 	sp, LAST_RAM_WORD 			# initializes stack pointer for subroutines
	ldw		r2, A(r0)					# read value of A from memory into register r2
	ldw		r3, B(r0)					# read value of B from memory into register r3
	ldw		r4, C(r0)
	call	Current						# call subroutine with parameters in r2 and r3
	stw		r5, D(r0)					# write return value in r2 to C in memory
		
_end:
	br		_end						# infinite loop once execution of program completes
			
#--------------------------------------------------------------------------------------------

Current:
	subi	sp, sp, 20					# adjust stack pointer down to reserve space
	stw		r16, 0(sp)					# save value of register r16 so it can be a temp
	stw		r15, 4(sp)					# save value of register r15 so it can be a temp
	stw		r14, 8(sp)					# save value of register r14 so it can be a temp
	stw		r13, 12(sp)					# save value of register r13 so it can be a temp
	stw		r12, 16(sp)					# save value of register r12 so it can be a temp
	
	sub		r16, r3, r4					
	mul		r15, r16, r16
	mul		r14, r2, r15
	movi	r12, 2
	div		r13, r14, r12
	mov		r5, r13						# transfer value from r16 into r5
	
	ldw		r12, 16(sp)					# restore value of r13 from stack
	ldw		r13, 12(sp)					# restore value of r13 from stack
	ldw		r14, 8(sp)					# restore value of r14 from stack
	ldw		r15, 4(sp)					# restore value of r15 from stack
	ldw		r16, 0(sp)					# restore value of r16 from stack
	addi	sp, sp, 16					# readjust stack pointer up to deallocate space
	ret								# return to calling routine with result in r5
	
#--------------------------------------------------------------------------------------------

	.org	0x00001000					# starting memory location for following content
	
A:	.word	7							# specify initial value of 7 in location for A
B: 	.word 	6							# specify initial value of 6 in location for B
C:	.word	5							# specify initial value of 6 in location for C
D:	.skip	4							# reserve 4 bytes (1 word) of space for D
										# (this space is technically uninitizalized
										# but it will normally be zero by default)
										
	.end								# indicates the end of the assembly-language source