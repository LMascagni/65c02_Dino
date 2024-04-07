; Indirizzi I/O 6000 -> 600F
PORTA   = $6001     
PORTB   = $6000
DDRA    = $6003
DDRB    = $6002
PCR     = $600c     ; Registro di controllo periferiche -> 65c22
IFR     = $600d     ; Registro flag interrupt -> 65c22
IER     = $600e     ; Registro abilitazione interrupt -> 65c22

; Punto di ingresso per il programma
reset:
    ldx #$ff    ; Carica $ff in X
    txs         ; Trasferisce $ff come puntatore stack
    cli         ; Cancella il flag interrupt

    lda #%10000010  ; Abilita l'interrupt CA1
    sta IER
    lda #$00        ; Abilita il fronte negativo di CA1
    sta PCR

    lda #%11111111  ; Imposta 8 pin su PORTB come output
    sta DDRB

    lda #%11100000  ; Imposta 3 pin su PORTA come output
    sta DDRA

    lda #%00111000  ; Display 8-bit - 2 linee - Font 5x8 (001<DL><N><F>xx)   
    jsr lcd_instruction

    lda #%00001100  ; Display acceso - Cursore spento - Lampeggio spento 
    jsr lcd_instruction

    lda #%00000110  ; Incremento e shift del cursore - non shifta il display
    jsr lcd_instruction

    lda #$01  ; Pulisce il display
    jsr lcd_instruction

    jmp entrypoint


