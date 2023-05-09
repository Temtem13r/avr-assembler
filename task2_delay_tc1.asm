.include "m32def.inc"
;---Таблица векторов прерывания---
.org 0
	jmp reset			;вектор прерывания по сбросу
	jmp int_0			;вектор прерывания по внешнему входу INT0
	jmp int_1			;вектор прерывания по внешнему входу INT1
	jmp int_2			;вектор прерывания по внешнему входу INT2
	jmp timer2_comp		;вектор прерывания по совпадению Т/С2
	jmp timer2_ovf		;вектор прерывания по переполнению Т/С2
	jmp timer1_capt		;вектор прерывания по захвату Т/С1
	jmp timer1_compa	;вектор прерывания по совпадению А Т/С1
	jmp timer1_compb	;вектор прерывания по совпадению В Т/С1
	jmp timer1_ovf		;вектор прерывания по переполнению Т/С1
	jmp timer0_comp		;вектор прерывания по совпадению Т/С0
	jmp timer0_ovf		;вектор прерывания по переполнению Т/С0
	jmp spi_ets			;вектор прерывания по оканчании обмена SPI
	jmp usart_rxc		;вектор прерывания по оканчании приема USART
	jmp usart_udre		;вектор прерывания по когда URD передатчика пуст
	jmp	usart_txc		;вектор прерывания по оканчании передачи USART
	jmp a_d_c			;вектор прерывания по оканчании преобразования АЦП
	jmp ee_rdy			;вектор прерывания по готовности EEPROM
	jmp ana_comp		;вектор прерывания от аналогового компаратора
	jmp t_w_i			;вектор прерывания по оканчании обмена TWI
	jmp spm_rdy			;вектор прерывания по 
	
;---Инициализация---
reset:
	cli
	;-------------
	ldi r21, 0x08	;загружаем в регистр/счетчик 8
	ldi r22, 0x08	;загружаем в регистр/счетчик 8

	;устанавливаем указатель стека
	ldi r16, 0x04	
	out SPH, r16
	ldi r16, 0x5f
	out SPL, r16

	;настройка порта В
	ldi r17, 0xff
	out DDRB, r17	;настраиваем ПОРТВ на выход
	ldi r17, 0xfe
	out PORTB, r17	;написываемм начальную комбинацию светодиодов

	;65256-14875-1 = 50 661-1 = 0XC5E5
	;настраиваем таймер/четчик
	ldi r16, 0xC5
	out TCNT1H, r16		;запись старшей части в TCNT1H
	ldi r16, 0xE4
	out TCNT1L, r16		;запись младшей части в TCNT1L
	ldi r16, 0b00000011
	out TCCR1B , r16	;режим normal, пердделитель 64
	ldi r16, 0b00000000	
	out TCCR1A , r16	;режим normal, вывод OC отключен
	ldi r16, 0b00000100
	out TIMSK, r16	;разрешение прерывания по переполнению
	out TIFR, r16	;сброс флага события переполнение
	sei	

;---Основная программа---

main:
	nop


	rjmp main 

;---П/п обработки прерывания по совпадению T/С0--- 
timer1_ovf: 
			ldi r16, 0xC5
			out TCNT1H, r16		;запись старшей части в TCNT1H
			ldi r16, 0xE5
			out TCNT1L, r16		;запись младшей части в TCNT1L
			
			in r16, SREG
			cpi r21,0x01
			brcs m1
			out SREG, r16

			rol r17			;логический сдвиг влево
 			out PORTB, r17	;вывод следующей комбинации светодиодных индикаторов
			dec r21			;уменьшаем счетчик на 1
			brne exit		;если r21 не равен 0, переходим на метку while

		m1:	ror r17			;логический сдвиг влево
 			out PORTB, r17	;вывод следующей комбинации светодиодных индикаторов
			dec r22			;уменьшаем счетчик на 1
			brne exit		;если r21 не равен 0, переходим на метку while

			ldi r21, 0x08	;загружаем в регистр/счетчик 8
			ldi r22, 0x08	;загружаем в регистр/счетчик 8
exit:	reti

;---Неиспользуемые прерывания---
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




			
	
