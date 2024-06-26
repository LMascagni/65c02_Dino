; Flag di comandi LCD
E       = %10000000 ; Segnale di abilitazione LCD
RW      = %01000000 ; Flag di lettura/scrittura LCD (H - Lettura, L - Scrittura)
RS      = %00100000 ; Flag di input LCD (H - Dati, L - Istruzione)

; Istruzioni LCD
LCD_SHIFT_DISPLAY_LEFT = %00011000
LCD_SCREEN_OFF = %00001000
LCD_SCREEN_ON = %00001100

; Indirizzi del cursore LCD
LCD_ADDR_FIRST_OVERFLOW = %10101000
LCD_ADDR_SECOND_OVERFLOW = %11101000
LCD_ADDR_FIRST_ROW_FIRST_CHAR = %10000000
LCD_ADDR_LAST_ROW_FIRST_CHAR = %11000000
LCD_ADDR_LAST_ROW_LAST_CHAR = %11100111
LCD_ADDR_TOP_RIGHT_CORNER = %10001111

; Sottoprogrammi LCD 1602a
set_cursor_address:
    jsr lcd_instruction
    rts

shift_display_left:
    pha
    lda #%00011000    ; Shifta il display a sinistra (il cursore segue)
    jsr lcd_instruction
    pla
    rts

shift_cursor_left:
    pha
    lda #%00010000    ; Shifta il cursore a sinistra
    jsr lcd_instruction
    pla
    rts

lcd_wait:
    pha
    lda #%00000000  ; Porta B è input
    sta DDRB
lcdbusy:
    lda #RW
    sta PORTA
    lda #(RW | E)
    sta PORTA
    lda PORTB
    and #%10000000
    bne lcdbusy

    lda #RW
    sta PORTA
    lda #%11111111  ; Porta B è output
    sta DDRB
    pla
    rts

lcd_instruction:
    pha
    jsr lcd_wait 
    sta PORTB
    lda #%0         ; Cancella i bit RS/RW/E
    sta PORTA
    lda #E          ; Bit di abilitazione ON   
    sta PORTA
    lda #%0         ; Bit di abilitazione OFF   
    sta PORTA
    pla
    rts

print_char:
    jsr lcd_wait
    sta PORTB
    lda #RS         ; Imposta il bit RS per scrivere   
    sta PORTA
    lda #(RS | E)  ; Imposta RS ed E  
    sta PORTA
    lda #RS         ; Latch Dati   
    sta PORTA
    rts

