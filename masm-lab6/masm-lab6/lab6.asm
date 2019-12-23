INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 501
.data
buffer BYTE BUFFER_SIZE DUP(?)
err_msg BYTE "Error: x<0!",0
x DWORD ?
a1 DWORD ?
a2 DWORD ?
a3 DWORD ?
index DWORD ?
point DWORD ?
nafp DWORD ?
temp DWORD ?
control WORD ?
demical DWORD ?
ZERO DWORD 0
TEN DWORD 10
ONE DWORD 1
.code
main PROC
readin:
	call ReadInt
	mov x,eax
	call ReadInt
	mov a1,eax
	call ReadInt
	mov a2,eax
	call ReadInt
	mov a3,eax
	cmp x,0
	jl error
cal:
	FILD x
	FSQRT
	FILD a1
	FMUL
	FILD a2
	FILD x
	FYL2X
	FILD x
	FSIN
	FILD a3
	FMUL
	FADD
	FADD
output:
	mov index,0
	mov point,0
	mov nafp,0
	FSTCW control
	mov ax,control
	AND ah,252
	mov control,ax
	FLDCW control
	FICOM ZERO
	FSTSW ax
	TEST ax,100h
	jz down2one
	mov buffer[0],'-'
	mov index,1
	FABS 
down2one:
	FICOM ONE
	FSTSW ax
	TEST ax,100h
	jnz mul10
	FIDIV TEN
	INC point
	jmp down2one
mul10:
	FICOM ZERO
	FSTSW ax
	TEST ax,4000h
	jnz quit
	cmp nafp,6
	jg quit
	.IF point==0
	mov ecx,index
	mov buffer[ecx],'.'
	INC index
	.ENDIF
	FIMUL TEN
	FST temp
	FRNDINT
	FISTP demical
	FLD temp
	FICOM demical
	FSTSW ax
	TEST ax,100h
	jz store_str ;>=
	sub demical,1
store_str:
	mov eax,demical
	add eax,'0'
	mov ecx,index
	mov buffer[ecx],al
	INC index
	INC nafp
	DEC point
	FISUB demical
	jmp mul10
error:
	mov edx,OFFSET err_msg
	
quit:
	.IF index==0
		mov buffer[0],'0'
		INC index
	.ENDIF
	mov ecx,index
	mov buffer[ecx],0
	mov edx,OFFSET buffer
	call WriteString
	exit
main ENDP
END main