@ note that this requires the wingsForAll.s patch by pants64 to work properly

nsub_020c7bb8:
	cmp r0, r0		@ force condition flag to true, cmp r0 #0x4 forces it to false in case you want no one to have Wings in the ? Switch level
	b 020c7bbc