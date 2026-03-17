  .include "constants.asm"
  .include "macros.asm"

; ==============================
; MARK: HEADER
; ==============================
  .inesprg 2                    ; 2 16kb program banks
  .ineschr 1                    ; 1 8kb character bank
  .inesmap 0                    ; NROM
  .inesmir MIRRORING_VERTICAL   ; Vertical VRAM mirroring

; ==============================
; MARK: Variables
; ==============================
  .enum ZERO_PAGE
temp                            .dsb 8
tempPointer                     .dsb 2

sleeping                        .dsb 1
frame                           .dsb 1
ppuMask                         .dsb 1
ppuControl                      .dsb 1
hScroll                         .dsb 1
vScroll                         .dsb 1
oldButtons                      .dsb 2
buttons                         .dsb 2
pressedButtons                  .dsb 2

engineState                     .dsb 1

playerX                         .dsb 1
playerY                         .dsb 1
  .ende

  .enum SPRITE_BUFFER
playerSprite                    .dsb SPRITE_SIZE * 1
  .ende

  .enum WORK_RAM_3
; Work RAM variables go here
  .ende

; ==============================
; MARK: Reset
; ==============================
  .base $8000
; https://www.nesdev.org/wiki/Init_code
Reset:
  SEI                           ; Ignore IRQs
  CLD                           ; Disable decimal mode
  LDX #$40
  STX SND_FRAME_COUNTER         ; Disable APU frame IRQ
  LDX #$FF
  TXS                           ; Set stack pointer to $01FF
  INX                           ; X = 0
  STX PPU_CONTROL               ; Disable NMI
  STX PPU_MASK                  ; Disable rendering
  STX SND_DMC_CTRL              ; Disable DMC IRQs

  BIT PPU_STATUS                ; Clear vblank flag
@vblankWait1:
  BIT PPU_STATUS
  BPL @vblankWait1              ; Wait until vblank flag is set

; Clear out Work RAM to known state (all 0s)
@clearMemory:
  LDA #$00                      ; We want to zero out all our work RAM
  STA ZERO_PAGE, x              ; Zero Page
  STA STACK, x                  ; Stack
  STA WORK_RAM_3 , x            ; Rest of Work RAM
  STA WORK_RAM_4 , x
  STA WORK_RAM_5 , x
  STA WORK_RAM_6 , x
  STA WORK_RAM_7 , x
  LDA #$FF                      ; Offscreen sprite data
  STA SPRITE_BUFFER, x          ; Sprite OAM Buffer
  INX
  BNE @clearMemory
  
@vblankWait2:
  BIT PPU_STATUS
  BPL @vblankWait2              ; Wait until vblank flag is set

; ==============================
; MARK: Init
; ==============================
Init:
  JSR LoadInitialPPUData

  LDA #$7C
  STA playerX
  STA playerY

  LDA #%00011110
  STA ppuMask

  LDA #%10001000                ; Enable NMI and allow the game to start
  STA ppuControl
  STA PPU_CONTROL

; ==============================
; MARK: Main
; ==============================
Main:
  INC sleeping
WaitForNMI:
  LDA sleeping
  BNE WaitForNMI

GameLogic:
  JSR ReadControllers

  JSR HandleGameState

  INC frame
  JMP Main                      ; Back to the wait loop

; ==============================
; MARK: NMI
; ==============================
NMI:
; Save the registers to the stack to restore later
  PHA                           ; Save A to the stack
  TXA                           ;
  PHA                           ; Save X to the stack
  TYA                           ;
  PHA                           ; Save y to the stack

; DMA transfer the sprites over
  LDA #<SPRITE_BUFFER
  STA SPR_ADDR
  LDA #>SPRITE_BUFFER
  STA SPRITE_DMA_TRANSFER

; TODO: Update background here

; Clear out the PPU_ADDRESS
  LDA #$00
  STA PPU_ADDRESS
  STA PPU_ADDRESS

; Set the PPU scroll
  LDA hScroll
  STA PPU_SCROLL
  LDA vScroll
  STA PPU_SCROLL

; Set the PPU control and mask
  LDA ppuControl
  STA PPU_CONTROL
  LDA ppuMask
  STA PPU_MASK

  DEC sleeping                  ; Indicate that we're done with the NMI
; Restore the registers from the stack
  PLA                           ; Load y from the stack
  TAY                           ;
  PLA                           ; Load x from the stack
  TAX                           ;
  PLA                           ; Load A from the stack
  RTI

; ==============================
; MARK: IRQ
; ==============================
IRQ:
  RTI

; ==============================
; MARK: CODE
; ==============================
  .include "engine.asm"
  .include "utils.asm"

LoadInitialPPUData:
  WritePPURLE TitleBackground, NAMETABLE_1
  WritePPURLE GameBackground, NAMETABLE_2

  WritePPULoop PaletteBackground, PALETTE_BG, 16
  WritePPULoop PaletteSprites, PALETTE_SPRITE, 16
  RTS

; ==============================
; MARK: DATA
; ==============================
  .org $E000
TitleBackground:
  .incbin "title.nrle"
GameBackground:
  .incbin "game.nrle"
PaletteBackground:
  .incbin "bg.pal"
PaletteSprites:
  .incbin "sprites.pal"

; ==============================
; MARK: Vectors
; ==============================
  .org $FFFA
  .dw NMI
  .dw Reset
  .dw IRQ

; ==============================
; MARK: CHR
; ==============================
  .incbin "tiles.chr"