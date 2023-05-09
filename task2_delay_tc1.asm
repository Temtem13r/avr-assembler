.include "m32def.inc"
;---������� �������� ����������---
.org 0
	jmp reset			;������ ���������� �� ������
	jmp int_0			;������ ���������� �� �������� ����� INT0
	jmp int_1			;������ ���������� �� �������� ����� INT1
	jmp int_2			;������ ���������� �� �������� ����� INT2
	jmp timer2_comp		;������ ���������� �� ���������� �/�2
	jmp timer2_ovf		;������ ���������� �� ������������ �/�2
	jmp timer1_capt		;������ ���������� �� ������� �/�1
	jmp timer1_compa	;������ ���������� �� ���������� � �/�1
	jmp timer1_compb	;������ ���������� �� ���������� � �/�1
	jmp timer1_ovf		;������ ���������� �� ������������ �/�1
	jmp timer0_comp		;������ ���������� �� ���������� �/�0
	jmp timer0_ovf		;������ ���������� �� ������������ �/�0
	jmp spi_ets			;������ ���������� �� ��������� ������ SPI
	jmp usart_rxc		;������ ���������� �� ��������� ������ USART
	jmp usart_udre		;������ ���������� �� ����� URD ����������� ����
	jmp	usart_txc		;������ ���������� �� ��������� �������� USART
	jmp a_d_c			;������ ���������� �� ��������� �������������� ���
	jmp ee_rdy			;������ ���������� �� ���������� EEPROM
	jmp ana_comp		;������ ���������� �� ����������� �����������
	jmp t_w_i			;������ ���������� �� ��������� ������ TWI
	jmp spm_rdy			;������ ���������� �� 
	
;---�������������---
reset:
	cli
	;-------------
	ldi r21, 0x08	;��������� � �������/������� 8
	ldi r22, 0x08	;��������� � �������/������� 8

	;������������� ��������� �����
	ldi r16, 0x04	
	out SPH, r16
	ldi r16, 0x5f
	out SPL, r16

	;��������� ����� �
	ldi r17, 0xff
	out DDRB, r17	;����������� ����� �� �����
	ldi r17, 0xfe
	out PORTB, r17	;����������� ��������� ���������� �����������

	;65256-14875-1 = 50�661-1 = 0XC5E5
	;����������� ������/������
	ldi r16, 0xC5
	out TCNT1H, r16		;������ ������� ����� � TCNT1H
	ldi r16, 0xE4
	out TCNT1L, r16		;������ ������� ����� � TCNT1L
	ldi r16, 0b00000011
	out TCCR1B , r16	;����� normal, ������������ 64
	ldi r16, 0b00000000	
	out TCCR1A , r16	;����� normal, ����� OC ��������
	ldi r16, 0b00000100
	out TIMSK, r16	;���������� ���������� �� ������������
	out TIFR, r16	;����� ����� ������� ������������
	sei	

;---�������� ���������---

main:
	nop


	rjmp main 

;---�/� ��������� ���������� �� ���������� T/�0--- 
timer1_ovf: 
			ldi r16, 0xC5
			out TCNT1H, r16		;������ ������� ����� � TCNT1H
			ldi r16, 0xE5
			out TCNT1L, r16		;������ ������� ����� � TCNT1L
			
			in r16, SREG
			cpi r21,0x01
			brcs m1
			out SREG, r16

			rol r17			;���������� ����� �����
 			out PORTB, r17	;����� ��������� ���������� ������������ �����������
			dec r21			;��������� ������� �� 1
			brne exit		;���� r21 �� ����� 0, ��������� �� ����� while

		m1:	ror r17			;���������� ����� �����
 			out PORTB, r17	;����� ��������� ���������� ������������ �����������
			dec r22			;��������� ������� �� 1
			brne exit		;���� r21 �� ����� 0, ��������� �� ����� while

			ldi r21, 0x08	;��������� � �������/������� 8
			ldi r22, 0x08	;��������� � �������/������� 8
exit:	reti

;---�������������� ����������---
int_0: reti
int_1: reti
int_2: reti
timer2_comp: reti
timer2_ovf: reti
timer1_capt: reti
timer1_compa: reti
timer1_compb: reti
;timer1_ovf: reti
timer0_comp: reti
timer0_ovf: reti
spi_ets: reti
usart_rxc: reti
usart_udre: reti
usart_txc: reti
a_d_c: reti
ee_rdy: reti
ana_comp: reti
t_w_i: reti
spm_rdy: reti




			
	
