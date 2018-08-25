		.data
dato:		.word	4
res:		.space	4
		.text
main:		lw	$s0,dato	
		or	$s1,$zero,$zero
		ori	$t0,$zero,0
		xori	$t0,$zero,0
bucle:		beq	$t0,$s0,e2
		e2:
		sltiu   $s0, $s0, 1
		slti 	$s0, $s0, 1

		addiu	$s1, $s1, 1
		bne	$s1, $zero, e
		e:
		sltu	$s1, $s1, $zero
		sub	$s1, $s1, $zero
		subu	$s1, $s1, $zero
		xor	$s1, $zero, $s1
		slt	$s1, $zero, $s1
		nor	$s1, $zero, $s1
		and	$s1, $s1, $zero
		addu	$s1, $s1, $zero
		
		add	$s1,$t0,$s1
		andi	$s1, $s1, 1
		
		addi	$t0,$t0,1
		j	e1
		e1:nop
		sw	$s1,res
		lui	$v0,10
		syscall
