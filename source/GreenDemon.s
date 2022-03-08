@ this patch makes it so one ups kill you instead of giving you a life

repl_020af410_ov_02:
repl_020af324_ov_02:
	mov r12, #0x0
	str r12, [r13, #0x8]	@ spawnOuchParticles: 0
	str r12, [r13, #0x4]	@ presetHurt: 0
	mov r12, #0x1
	str r12, [r13]			@ arg4: 1
	ldr r2, =0x0209f394		@ PLAYER_ARR
	ldr r0, [r2]			@ PLAYER_ARR[0]
	mov r3, #0x0c000		@ speed: 0x0c000
	mov r2, #0x8			@ damage: 8
	add r1, r0, #0x5c		@ source: player->pos
	push {r14}
	bl 0x020d8e70			@ Player::Hurt
	pop {r14}
	bx r14					@ exit hook