	.file	"program.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	move
	.type	move, @function
move:
	lui	a6,%hi(moves.0)
	lw	a4,%lo(moves.0)(a6)
	slli	a3,a4,1
	add	a3,a3,a4
	slli	a3,a3,1
	lui	a5,%hi(.LANCHOR0)
	addi	a5,a5,%lo(.LANCHOR0)
	add	a5,a5,a3
	sh	a0,0(a5)
	sh	a1,2(a5)
	sh	a2,4(a5)
	addi	a4,a4,1
	sw	a4,%lo(moves.0)(a6)
	ret
	.size	move, .-move
	.align	2
	.globl	hanoi
	.type	hanoi, @function
hanoi:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	sw	s4,8(sp)
	mv	s2,a1
	mv	s1,a2
	li	a5,1
	beq	a0,a5,.L6
	mv	s0,a0
	mv	s3,a3
	addi	s4,a0,-1
	mv	a3,a2
	mv	a2,s3
	mv	a0,s4
	call	hanoi
	mv	a2,s1
	mv	a1,s2
	mv	a0,s0
	call	move
	mv	a3,s2
	mv	a2,s1
	mv	a1,s3
	mv	a0,s4
	call	hanoi
.L2:
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	lw	s4,8(sp)
	addi	sp,sp,32
	jr	ra
.L6:
	li	a0,1
	call	move
	j	.L2
	.size	hanoi, .-hanoi
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	li	a3,66
	li	a2,67
	li	a1,65
	li	a0,4
	call	hanoi
	li	a0,0
	lw	ra,12(sp)
	addi	sp,sp,16
	jr	ra
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
