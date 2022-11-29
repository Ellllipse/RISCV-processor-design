	.file	"program.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text

_start:
	li sp, 0x00010000	# 4
	call main			# 8
	
	ebreak

	.align	2
	.globl	move
	.type	move, @function
move:
	lui	a6,%hi(moves.0)	
	lw	a4,%lo(moves.0)(a6)	# 12

	slli	a3,a4,1			# 16

	add	a3,a3,a4			# 20

	slli	a3,a3,1			# 24
	lui	a5,%hi(.LANCHOR0)
	addi	a5,a5,%lo(.LANCHOR0)	# 28
	
	add	a5,a5,a3			# 32

	sh	a0,0(a5)			# 36
	sh	a1,2(a5)			# 40
	sh	a2,4(a5)			# 44
	addi	a4,a4,1			# 48
	sw	a4,%lo(moves.0)(a6)	# 52
	ret						# 56
	.size	move, .-move
	.align	2
	.globl	hanoi
	.type	hanoi, @function
hanoi:
	addi	sp,sp,-32		# 60

	sw	ra,28(sp)			# 64
	sw	s0,24(sp)			# 68
	sw	s1,20(sp)			# 72
	sw	s2,16(sp)			# 76
	sw	s3,12(sp)			# 80
	sw	s4,8(sp)			# 84
	mv	s2,a1				# 88
	mv	s1,a2				# 92
	li	a5,1				# 96

	beq	a0,a5,.L6			# 100
	mv	s0,a0				# 104
	mv	s3,a3				# 108
	addi	s4,a0,-1		# 112
	mv	a3,a2				# 116

	mv	a2,s3				# 120
	mv	a0,s4				# 124
	call	hanoi			# 128
	mv	a2,s1				# 132

	mv	a1,s2				# 136
	mv	a0,s0				# 140
	call	move			# 144
	mv	a3,s2				# 148
	mv	a2,s1				# 152
	mv	a1,s3				# 156
	mv	a0,s4				# 160
	call	hanoi			# 164
.L2:
	lw	ra,28(sp)			# 168
	lw	s0,24(sp)			# 172
	lw	s1,20(sp)			# 176
	lw	s2,16(sp)			# 180
	lw	s3,12(sp)			# 184
	lw	s4,8(sp)			# 188
	addi	sp,sp,32		# 192
	jr	ra					# 196
.L6:
	li	a0,1				# 200
	call	move			# 204
	j	.L2					# 208
	.size	hanoi, .-hanoi
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"Move %u disk %d from %c to %c\n"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32		# 212
	sw	ra,28(sp)			# 216
	sw	s0,24(sp)			# 220
	sw	s1,20(sp)			# 224
	sw	s2,16(sp)			# 228
	sw	s3,12(sp)			# 232
	li	a3,66				# 236
	li	a2,67				# 240
	li	a1,65				# 244
	li	a0,4				# 248
	call	hanoi			# 252
	lui	s0,%hi(.LANCHOR0)
	addi	s0,s0,%lo(.LANCHOR0)
	li	s1,0
	lui	s3,%hi(.LC0)
	li	s2,15
	.size	main, .-main
	.globl	movearray
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	movearray, @object
	.size	movearray, 96
movearray:
	.zero	96
	.section	.sbss,"aw",@nobits
	.align	2
	.type	moves.0, @object
	.size	moves.0, 4
moves.0:
	.zero	4
	.ident	"GCC: () 12.2.0"
