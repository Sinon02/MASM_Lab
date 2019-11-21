INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 501
.data
buffer BYTE BUFFER_SIZE DUP(?)
N DWORD ?

.code
main PROC

	call ReadInt
	mov N,eax
	mov ebx,0
	mov ecx,0
	mov edx,1
First_Loop:
	cmp ebx,N
	jge quit
	jmp Second_Loop
go_First_Loop:
	call Crlf
	add ebx,1
	mov ecx,0
	jmp First_Loop
Second_Loop:
	cmp ecx,N
	jge go_First_Loop
	cmp ecx,ebx
	jg not_print
	mov eax,edx
	call WriteDec
	mWrite <" ",0>
	add edx,1
	add ecx,1
	jmp Second_Loop


not_print:
	add edx,1
	add ecx,1
	jmp Second_Loop
quit:
	exit
main ENDP
END main

