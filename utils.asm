; https://www.nesdev.org/wiki/Controller_reading_code#Alternative_2_Controllers_Read
ReadControllers:
  LDA buttons
  STA oldButtons
  LDA buttons + 1
  STA oldButtons + 1

  LDA #$01
  STA JOYPAD_1
  STA buttons + 1               ; player 2's buttons double as a ring counter
  LSR A                         ; now A is 0
  STA JOYPAD_1
@loop:
  LDA JOYPAD_1
  AND #%00000011                ; ignore bits other than controller
  CMP #$01                      ; Set carry if and only if nonzero
  ROL buttons + 0               ; Carry -> bit 0; bit 7 -> Carry
  LDA JOYPAD_2                  ; Repeat for player 2
  AND #%00000011
  CMP #$01
  ROL buttons + 1               ; Carry -> bit 0; bit 7 -> Carry
  BCC @loop

  LDA oldButtons + 0
  EOR #$FF
  AND buttons + 0
  STA pressedButtons + 0
  LDA oldButtons + 1
  EOR #$FF
  AND buttons + 1
  STA pressedButtons + 1
  RTS

; Based off RLE decompressor by Shiru
WriteRLE:
  LDY #$00
  JSR WriteRLEByte
  STA temp + 0
@1
  JSR WriteRLEByte
  CMP temp + 0
  BEQ @2
  STA PPU_DATA
  STA temp + 1
  BNE @1
@2
  JSR WriteRLEByte
  CMP #$00
  BEQ @done
  TAX
  LDA temp + 1
@3
  STA PPU_DATA
  DEX
  BNE @3
  BEQ @1
@done
  RTS

WriteRLEByte
  LDA (tempPointer), y
  INC tempPointer + 0
  BNE @done
  INC tempPointer + 1
@done
  RTS
