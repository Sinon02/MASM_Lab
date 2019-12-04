INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 20

.data
buffer  DWORD BUFFER_SIZE DUP(?)
N DWORD ?
I DWORD ?
J DWORD ?
K DWORD ?
.code
; the Factorial receives a value in eax, which is in [1,20], and output the value to screen
Factorial PROC NEAR USES eax ebx ecx edx
clear_up:
	mov buffer[0],1
	mov ecx,1
check_end:
	cmp ecx,BUFFER_SIZE
	jae start
	mov buffer[ecx*4],0
	add ecx,1
	jmp check_end
start:
	mov N,eax
	mov I,0
multi:
	add I,1
	mov eax,N
	cmp I,eax
	ja print_start
	mov J,0
loop1:
	cmp J,BUFFER_SIZE
	jae check_carry
	mov edx,J
	mov eax,buffer[edx*4]
	mul I
	mov edx,J
	mov buffer[edx*4],eax
	add J,1
	jmp loop1
check_carry:
	mov K,0
check_carry_loop:
	cmp K,BUFFER_SIZE-1
	jae multi
	mov ecx,K
	cmp buffer[ecx*4],10
	jae carry
carry_back:
	add K,1
	jmp check_carry_loop
carry:
	mov eax,buffer[ecx*4]
	mov ebx,10
	mov edx,0
	div ebx
	mov buffer[ecx*4],edx
	add buffer[ecx*4+4],eax
	jmp carry_back
	
print_start:
	mov ecx,BUFFER_SIZE-1
print:
	cmp buffer[ecx*4],0
	jne start_print
	sub ecx,1
	jmp print
start_print:
	mov eax,buffer[ecx*4]
	call WriteDec
	cmp ecx,0
	je quit
	sub ecx,1
	jmp start_print	

quit:
	RET
Factorial ENDP

main PROC
.code
	call ReadInt
	call Factorial
	exit
main ENDP
END main

