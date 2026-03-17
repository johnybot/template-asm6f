MIRRORING_HORIZONTAL            = %00000000
MIRRORING_VERTICAL              = %00000001
MIRRORING_FOUR_SCREEN           = %00001000

; ==============================
; MARK: Sprites
; ==============================
SPRITE_YPOS                     = $0
SPRITE_TILE                     = $1
SPRITE_ATTR                     = $2
SPRITE_XPOS                     = $3
SPRITE_SIZE                     = 4

; ==============================
; MARK: Work RAM
; ==============================
ZERO_PAGE                       = $0000
STACK                           = $0100 
SPRITE_BUFFER                   = $0200 
WORK_RAM_3                      = $0300
WORK_RAM_4                      = $0400
WORK_RAM_5                      = $0500
WORK_RAM_6                      = $0600
WORK_RAM_7                      = $0700

; ==============================
; MARK: PPU Registers
; ==============================
PPU_CONTROL                     = $2000
PPU_MASK                        = $2001
PPU_STATUS                      = $2002
SPR_ADDR                        = $2003
SPR_IO                          = $2004
PPU_SCROLL                      = $2005
PPU_ADDRESS                     = $2006
PPU_DATA                        = $2007

; ==============================
; MARK: APU Registers
; ==============================
SND_PULSE1_CTRL                 = $4000
SND_PULSE1_RAMP_CTRL            = $4001
SND_PULSE1_FT                   = $4002
SND_PULSE1_CT                   = $4003
SND_PULSE2_CTRL                 = $4004
SND_PULSE2_RAMP_CTRL            = $4005
SND_PULSE2_FT                   = $4006
SND_PULSE2_CT                   = $4007
SND_TRI_CTRL1                   = $4008
SND_TRI_CTRL2                   = $4009
SND_TRI_FREQ1                   = $400A
SND_TRI_FREQ2                   = $400B
SND_NOISE_CTRL1                 = $400C
SND_NOISE_CTRL2                 = $400D
SND_NOISE_FREQ1                 = $400E
SND_NOISE_FREQ2                 = $400F
SND_DMC_CTRL                    = $4010
SND_DMC_DA                      = $4011
SND_DMC_ADDR                    = $4012
SND_DMC_DL                      = $4013
SPRITE_DMA_TRANSFER             = $4014
SND_CLOCK                       = $4015
SND_FRAME_COUNTER               = $4017

; ==============================
; MARK: Controllers
; ==============================
JOYPAD_POLL                     = $4016
JOYPAD_1                        = $4016
JOYPAD_2                        = $4017

BUTTON_RIGHT                    = %00000001
BUTTON_LEFT                     = %00000010
BUTTON_DOWN                     = %00000100
BUTTON_UP                       = %00001000
BUTTON_START                    = %00010000
BUTTON_SELECT                   = %00100000
BUTTON_B                        = %01000000
BUTTON_A                        = %10000000

; ==============================
; MARK: PPU RAM
; ==============================
NAMETABLE_1                     = $2000
ATTRIBUTES_1                    = $23C0
NAMETABLE_2                     = $2400
ATTRIBUTES_2                    = $27C0
NAMETABLE_3                     = $2800
ATTRIBUTES_3                    = $2BC0
NAMETABLE_4                     = $2C00
ATTRIBUTES_4                    = $2FC0

PALETTE_BG                      = $3F00
PALETTE_BG_1                    = $3F00
PALETTE_BG_2                    = $3F04
PALETTE_BG_3                    = $3F08
PALETTE_BG_4                    = $3F0C

PALETTE_SPRITE                  = $3F10
PALETTE_SPRITE_1                = $3F10
PALETTE_SPRITE_2                = $3F14
PALETTE_SPRITE_3                = $3F18
PALETTE_SPRITE_4                = $3F1C