GetSRAMBank::
; load sram bank a
; if invalid bank, sram is disabled
	cp NUM_SRAM_BANKS
	jr nc, CloseSRAM
	; fallthrough

OpenSRAM::
; switch to sram bank a
	push af
; latch clock data
	ld a, 1
	ld [MBC3LatchClock], a
; enable sram/clock write
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
; select sram bank
	pop af
	ld [MBC3SRamBank], a
	ret

ClearsScratch::
	xor a
	call GetSRAMBank
	ld hl, sScratch
	ld bc, 2 tiles
	xor a
	rst ByteFill
	; fallthrough

CloseSRAM::
	push af
	ld a, SRAM_DISABLE
; reset clock latch for next time
	ld [MBC3LatchClock], a
; disable sram/clock write
	ld [MBC3SRamEnable], a
	pop af
	ret
