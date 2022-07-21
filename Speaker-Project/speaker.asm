num equ 49d

org 0000h
ljmp main


org 0100h
	
delay_200ms:
	push 00h
	mov r0, #200
	h4: acall delay_1ms
	djnz r0, h4
	pop 00h
	ret
	
delay_100ms:
	push 00h
	mov r0, #100
	h3: acall delay_1ms
	djnz r0, h3
	pop 00h
	ret

delay_1ms:
	push 00h
	mov r0, #4
	h2: acall delay_250us
	djnz r0, h2
	pop 00h
	ret

delay_250us:
	push 00h
	mov r0, #244
	h1: djnz r0, h1
	pop 00h
	ret
	
load_t1:
mov a, #num
mov th1,#0b1h
mov tl1,#0e0h
setb tr1
ret
	
reload_t1:
dec a
clr tf1
mov th1,#0b1h
mov tl1,#0e0h
setb tr1
ret


note_sa:
lcall load_t1
main_sa:
mov tl0, #0b9h
mov th0, #0efh
setb tr0
loop_sa:
jnb tf0, loop_sa
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_sa
lcall reload_t1
skip_sa:
jnz main_sa
mov p0, #00h
lcall delay_100ms
ret

note_re:
lcall load_t1
main_re:
mov tl0, #088h
mov th0, #0f1h
setb tr0
loop_re:
jnb tf0, loop_re
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_re
lcall reload_t1
skip_re:
jnz main_re
mov p0, #00h
lcall delay_100ms
ret

note_ga:
lcall load_t1
main_ga:
mov tl0, #0fah
mov th0, #0f2h
setb tr0
loop_ga:
jnb tf0, loop_ga
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_ga
lcall reload_t1
skip_ga:
jnz main_ga
mov p0, #00h
lcall delay_100ms
ret

note_ma:
lcall load_t1
main_ma:
mov tl0, #0cbh
mov th0, #0f3h
setb tr0
loop_ma:
jnb tf0, loop_ma
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_ma
lcall reload_t1
skip_ma:
jnz main_ma
mov p0, #00h
lcall delay_100ms
ret

note_pa:
lcall load_t1
main_pa:
mov tl0, #026h
mov th0, #0f5h
setb tr0
loop_pa:
jnb tf0, loop_pa
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_pa
lcall reload_t1
skip_pa:
jnz main_pa
mov p0, #00h
lcall delay_100ms
ret

note_da:
lcall load_t1
main_da:
mov tl0, #03ch
mov th0, #0f6h
setb tr0
loop_da:
jnb tf0, loop_da
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_da
lcall reload_t1
skip_da:
jnz main_da
mov p0, #00h
lcall delay_100ms
ret

note_ni:
lcall load_t1
main_ni:
mov tl0, #052h
mov th0, #0f7h
setb tr0
loop_ni:
jnb tf0, loop_ni
clr tf0
clr tr0
cpl p0.0
jnb tf1, skip_ni
lcall reload_t1
skip_ni:
jnz main_ni
mov p0, #00h
lcall delay_100ms
ret

main:
mov p0, #00h
mov tmod, #11h
song_loop:
lcall note_sa
lcall note_sa
lcall note_re
lcall note_sa
lcall note_ma
lcall note_ga
lcall note_sa
lcall note_sa
lcall note_re
lcall note_sa
lcall note_pa
lcall note_ma
lcall note_sa
lcall note_sa
lcall note_da
lcall note_pa
lcall note_ma
lcall note_ga
lcall note_re
lcall note_da
lcall note_da
lcall note_pa
lcall note_ma
lcall note_pa
lcall note_ma
lcall delay_200ms
ljmp song_loop
here: sjmp here
end
