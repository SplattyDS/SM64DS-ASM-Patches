@ Return to the level entrance instead of Castle Floor 1 
@ r0 and r1 are level_id and entrance_id of the to be loaded level, if loading to the default castle floor 1 entrance (id 0) change the NEXT_LEVEL_ID and NEXT_ENTRANCE_ID to the ones stored in HUB_LEVEL_ID and HUB_ENTRANCE_ID
@ This doesnt always get called when loading a level but it does always get called when pressing Exit Course

nsub_0202ACC0:
	@ If player is not warping to the default entrance
	cmp r0, #0x2
	bne exit_code_0202ACC0
	cmp r1, #0x0
	bne exit_code_0202ACC0
	
	@ Check current level id (before the warp), if you are currently in a hub area, exit code
	ldr r0, =0x0209f2f8				@ Load address of LEVEL_ID in r0
	ldrb r0, [r0]					@ Load value of LEVEL_ID in r0
	push {r14}
	bl 0x02013558					@ Load ACT_SELECTOR_ID of LEVEL_ID in r0: SubLevelToLevel(r0)
	pop {r14}
	cmp r0, #0x1D					@ ACT_SELECTOR_ID == 0x1D (29: HUB)
	beq exit_code_0202ACC0			@ If true, exit code
	
	@ Warp player to next hub level and entrance
	ldr r0, =HUB_LEVEL_ID
	ldrb r0, [r0]
	ldr r1, =HUB_ENTRANCE_ID
	ldrb r1, [r1]
	b exit_code_0202ACC0
	
	exit_code_0202ACC0:
	push {r14}   @ execute original instruction
	b 0x0202acc4 @   go to the next instruction

@ Hook when entering exit, save HUB entrance and level here if level hub
@ Safe: r0 and r1
@ NEXT_ENTRANCE_ID: r3
nsub_0202AB68:
	@ Set hub level and entrance ids if warping to a non-hub level from the hub
	ldr r0, =0x02092110				@ Load address of NEXT_LEVEL_ID in r0
	ldrb r0, [r0]					@ Load value   of NEXT_LEVEL_ID in r0
	push {r14}
	bl 0x02013558					@ Load ACT_SELECTOR_ID of NEXT_LEVEL_ID in r0: SubLevelToLevel(r0)
	pop {r14}
	cmp r0, #0x1D					@ NEXT_ACT_SELECTOR_ID == 0x1D (29: HUB)
	beq exit_code_0202AB68			@ If true, exit code
	ldr r0, =0x0209f2f8				@ Load address of LEVEL_ID in r0
	ldrb r0, [r0]					@ Load value of LEVEL_ID in r0
	push {r14}
	bl 0x02013558					@ Load ACT_SELECTOR_ID of LEVEL_ID in r0: SubLevelToLevel(r0)
	pop {r14}
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
	ldr r1, =0x0209f2f8				@ Execute original instruction
	b 0x0202ab6c					@ Go to the next instruction