@ Thanks to Pants64 for the first hook address (0x02029378)

@ Return to the hub level entrance instead of Castle Floor 1 
@ Exit level: r0
@ Exit entrance: r1
nsub_02029378:
	@ Warp player to next hub level and entrance
	ldr r0, =HUB_LEVEL_ID
	ldrb r0, [r0]
	ldr r1, =HUB_ENTRANCE_ID
	ldrb r1, [r1]
	b 0x0202937c 					@ Go to the next instruction

@ Hook when entering exit, save HUB entrance and level here if level hub
@ Safe: r0 and r1
@ NEXT_ENTRANCE_ID: r3
nsub_0202AB68:
	@ Set hub level and entrance ids if warping to a non-hub level from the hub
	push {r14}
	ldr r0, =0x02092110				@ Load address of NEXT_LEVEL_ID in r0
	ldrb r0, [r0]					@ Load value   of NEXT_LEVEL_ID in r0
	bl 0x02013558					@ Load ACT_SELECTOR_ID of NEXT_LEVEL_ID in r0: SubLevelToLevel(r0)
	cmp r0, #0x1D					@ NEXT_ACT_SELECTOR_ID == 0x1D (29: HUB)
	beq exit_code_0202AB68			@ If true, exit code
	ldr r0, =0x0209f2f8				@ Load address of LEVEL_ID in r0
	ldrb r0, [r0]					@ Load value of LEVEL_ID in r0
	bl 0x02013558					@ Load ACT_SELECTOR_ID of LEVEL_ID in r0: SubLevelToLevel(r0)
	cmp r0, #0x1D					@ ACT_SELECTOR_ID == 0x1D (29: HUB)
	bne exit_code_0202AB68			@ If false, exit code
	
	@ Set HUB_LEVEL_ID to the level ID before warping and set HUB_ENTRANCE_ID to the just entered warp entrance
	ldr r0, =HUB_LEVEL_ID			@ Load address of HUB_LEVEL_ID in r0
	ldr r1, =0x0209f2f8				@ Load address of LEVEL_ID (before warp) in r1
	ldrb r1, [r1]					@ Load   value of LEVEL_ID in r1
	strb r1, [r0]					@ Store r1 (value of LEVEL_ID) in r0 (address of HUB_LEVEL_ID)
	ldr r0, =HUB_ENTRANCE_ID		@ Load address of HUB_ENTRANCE_ID in r0
	strb r3, [r0]					@ Store r3 (value of NEXT_ENTRANCE_ID) in r0 (address of HUB_ENTRANCE_ID)
	b exit_code_0202AB68			@ Exit code
	
	exit_code_0202AB68:
	pop {r14}
	ldr r1, =0x0209f2f8				@ Execute original instruction
	b 0x0202ab6c					@ Go to the next instruction