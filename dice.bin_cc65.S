; Target assembler: cc65 v2.18.0 [--target none -C dice.bin_cc65.cfg]
;***************************************************************
;* Dungeons and Dragons Dice simulator for the KIM-1           *
;* (c) 29.7.81 Myron A. Calhoun                                *
;*             Manhattan, KS                                   *
;*                                                             *
;* Load to address $0000                                       *
;*                                                             *
;* Pressing the KIM-1's 1..5 Keys simulates rolling a 4 6 8 10 *
;* 20 or 100 sided dice. The result is displayed as a random   *
;* number in the range 1-4, 1-6, 1-8, 1-10, 1-20 and 1-100,    *
;* respectively.                                               *
;* Holding one of the above keys down will display successive  *
;* random numbers but too fast to read. pressing any other key *
;* will clear the display to zeros. "Random" numbers are       *
;* derived from the free-running build-in timer in the KIM-1.  *
;***************************************************************
         .setcpu "6502"
RIGHT    =       $f9
MIDDLE   =       $fa
LEFT     =       $fb
RANDOM   =       $1704
SCANDS   =       $1f1f
GETKEY   =       $1f6a

         .org    $0000
Start:   lda     #$00
         sta     RIGHT
         sta     MIDDLE
NewVal:  sta     LEFT
Display: jsr     SCANDS
         beq     Display
         cld
         jsr     GETKEY
         cmp     #$15
         beq     Display
         cmp     #$06
         bcs     Start
         tax
         lda     RANDOM
         and     #$7f
Tryagain:
         cmp     z:Table,x
         bcc     Convert
         sec
         sbc     z:Table,x
         jmp     Tryagain

Convert: tax
         ldy     #$00
         sed
NotYet:  clc
         adc     #$01
         dex
         bpl     NotYet
         sta     MIDDLE
         lda     #$00
         rol     A
         jmp     NewVal

Table:   .byte   $04
         .byte   $06
         .byte   $08
         .byte   $0a
         .byte   $14
         .byte   $64
