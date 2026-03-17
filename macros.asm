  
  .macro JumpAddress addr
  .dw addr - 1
  .endm

  .macro SetPPUAddress addr
  LDA #>addr
  STA PPU_ADDRESS
  LDA #<addr
  STA PPU_ADDRESS
  .endm

  .macro SetPointer addr
  LDA #<addr
  STA tempPointer + 0
  LDA #>addr
  STA tempPointer + 1
  .endm

  .macro MoveToState state
  LDA #state
  STA engineState
  .endm

  .macro WritePPURLE source, destination
  SetPPUAddress destination
  SetPointer source
  JSR WriteRLE
  .endm
  
  .macro WritePPULoop source, destination, numberOfBytes
  SetPPUAddress destination
  LDX #$00
@loop
  LDA source, x
  STA PPU_DATA
  INX
  CPX #numberOfBytes
  BCC @loop
  .endm