@ press L and R to enter debug fly mode
nsub_020e4d28_ov_02:
	sub r13, r13, #0x18 @ original instruction
	mov r4, r0
	ldr r5, =0x0211025c
	
	@ Pressing L and R ?
	ldr r1, =0x020a0e58
	ldrh r1, [r1]
	and r1, #0x300
	cmp r1, #0x300
	bne 0x020e4d2c
	
	@ is already flying?
	mov r1, r5
	bl 0x020e308c @ Player::IsState
	cmp r0, #0x0
	mov r0, r4
	bne 0x020e4d2c
	
	@ start flying
	mov r1, r5
	bl 0x020e30a0 @ Player::ChangeState
	mov r0, r4
	b 0x020e4d2c