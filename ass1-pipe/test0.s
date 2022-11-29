	.file	"program.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text

_start:
	li sp, 0x00010000	# 4
	call main			# 8
	ebreak				# 12

	.align	2
	.globl	move
	.type	move, @function
move:
	lui	a6,%hi(moves.0)	# 16
	lw	a4,%lo(moves.0)(a6)	# 20
	slli	a3,a4,1			# 24
	add	a3,a3,a4			# 28
	slli	a3,a3,1			# 32
	lui	a5,%hi(.LANCHOR0)	# 36
	addi	a5,a5,%lo(.LANCHOR0)	# 40
	add	a5,a5,a3			# 44
	sh	a0,0(a5)			# 48
	sh	a1,2(a5)			# 52
	sh	a2,4(a5)			# 56
	addi	a4,a4,1			# 60
	sw	a4,%lo(moves.0)(a6)	# 64
	ret						# 68
	.size	move, .-move
	.align	2
	.globl	hanoi
	.type	hanoi, @function
hanoi:
	addi	sp,sp,-32		# 72
	sw	ra,28(sp)			# 76
	sw	s0,24(sp)			# 80
	sw	s1,20(sp)			# 84
	sw	s2,16(sp)			# 88
	sw	s3,12(sp)			# 92
	sw	s4,8(sp)			# 96
	mv	s2,a1				# 100
	mv	s1,a2				# 104
	li	a5,1				# 108
	beq	a0,a5,.L6			# 112
	mv	s0,a0				# 116
	mv	s3,a3				# 120
	addi	s4,a0,-1		# 124
	mv	a3,a2				# 128
	mv	a2,s3				# 132
	mv	a0,s4				# 136
	call	hanoi			# 140
	mv	a2,s1				# 144
	mv	a1,s2				# 148
	mv	a0,s0				# 152
	call	move			# 156
	mv	a3,s2				# 160
	mv	a2,s1				# 164
	mv	a1,s3				# 168
	mv	a0,s4				# 172
	call	hanoi			# 176
.L2:
	lw	ra,28(sp)			# 180
	lw	s0,24(sp)			# 184
	lw	s1,20(sp)			# 188
	lw	s2,16(sp)			# 192
	lw	s3,12(sp)			# 196
	lw	s4,8(sp)			# 200
	addi	sp,sp,32		# 204
	jr	ra					# 208
.L6:
	li	a0,1				# 212
	call	move			# 216
	j	.L2					# 220
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
	addi	sp,sp,-32		# 224
	sw	ra,28(sp)			# 228
	sw	s0,24(sp)			# 232
	sw	s1,20(sp)			# 236
	sw	s2,16(sp)			# 240
	sw	s3,12(sp)			# 
	li	a3,66
	li	a2,67
	li	a1,65
	li	a0,4
	call	hanoi
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
