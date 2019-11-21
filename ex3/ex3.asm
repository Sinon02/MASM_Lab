INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 501
.data
buffer BYTE BUFFER_SIZE DUP(?)
number DWORD BUFFER_SIZE DUP(?)
filename BYTE "Input3.txt",0
fileHandle HANDLE ?
N DWORD ?
len DWORD ?
.code

main PROC
	;open file
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle,eax
	
	;check fo errors
	cmp	eax,INVALID_HANDLE_VALUE		
	jne	file_ok					
	mWrite <"Cannot open file",0dh,0ah>
	jmp	quit					
	
file_ok:
	;Read from file
	mov edx,OFFSET buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	mov N,eax
pre_process:
	mov ebx,0
	mov ecx,0
pre_process_loop:
	cmp ebx,N
	jge sort
	mov AL,buffer[ebx]
	call IsDigit
	jnz is_neg
come_back:
	add ebx,1
	add ecx,1
	jmp pre_process_loop
is_neg:
	cmp buffer[ebx],'-'
	je come_back
string2int:
	mov eax,ebx
	sub eax,ecx
	add eax,OFFSET buffer
	mov edx,eax
	call ParseInteger32
	mov edx,len
	mov number[edx*4],eax
	add edx,1
	mov len,edx
	add ebx,1
	mov ecx,0
	jmp pre_process_loop
sort:
	mov ebx,0
	mov ecx,0

loop1:
	cmp ebx,len
	jge pre_print
	mov ecx,len
	sub ecx,1
	jmp loop2

go_loop1:
	add ebx,1
	mov ecx,len
	sub ecx,1
	jmp loop1
loop2:
	cmp ecx,ebx
	jle go_loop1
	mov edx,number[ecx*4-4]
	cmp number[ecx*4],edx
	jge not_sort
	mov eax,number[ecx*4]
	mov number[ecx*4],edx
	mov number[ecx*4-4],eax
	sub ecx,1
	jmp loop2
not_sort:
	sub ecx,1
	jmp loop2
pre_print:
	mov edi, OFFSET number
	mov ecx, len
	mov edx,0
print:
	mov eax,number[edx*4]
	call WriteInt
	mWrite <" ",0>
	add edx,1
	loop print
	
quit:
	mov eax,fileHandle
	call CloseFile
	exit
main ENDP
END main
