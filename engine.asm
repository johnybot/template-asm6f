STATE_TITLE                     = $00
STATE_GAME                      = $01

StateRoutines:
  JumpAddress StateTitle
  JumpAddress StateGame
HandleGameState:
  LDA engineState
  ASL A
  TAX
  LDA StateRoutines + 1, x
  PHA
  LDA StateRoutines + 0, x
  PHA
  RTS

StateTitle:
  JSR ClearPlayer

  ; Advance to game
  LDA pressedButtons
  AND #BUTTON_A | BUTTON_START
  BEQ @notStart
  MoveToState STATE_GAME
  LDA ppuControl
  EOR #%00000001
  STA ppuControl
@notStart
  RTS

StateGame:
  JSR DrawPlayer

  ; Return to title
  LDA pressedButtons
  AND #BUTTON_B
  BEQ @notB
  MoveToState STATE_TITLE
  LDA ppuControl
  EOR #%00000001
  STA ppuControl
@notB

  ; Move character around
  LDA buttons
  AND #BUTTON_UP
  BEQ @notUp
  DEC playerY
@notUp
  LDA buttons
  AND #BUTTON_DOWN
  BEQ @notDown
  INC playerY
@notDown
  LDA buttons
  AND #BUTTON_LEFT
  BEQ @notLeft
  DEC playerX
@notLeft
  LDA buttons
  AND #BUTTON_RIGHT
  BEQ @notRight
  INC playerX
@notRight
  RTS

ClearPlayer:
  LDA #$FF
  STA playerSprite + SPRITE_YPOS
  RTS

DrawPlayer:
  LDA playerX
  STA playerSprite + SPRITE_XPOS
  LDA playerY
  STA playerSprite + SPRITE_YPOS
  LDA #$00
  STA playerSprite + SPRITE_ATTR
  LDA #$00
  STA playerSprite + SPRITE_TILE
  RTS