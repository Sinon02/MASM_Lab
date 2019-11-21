INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 301
.data
buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "Input1.txt",0
out_file BYTE "Output1.txt",0
fileHandle HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file [",0
str4 BYTE "]:",0
str3 BYTE "Enter up to 300 characters and press "
     BYTE "[Enter]: ",0dh,0ah,0

.code

main PROC
	;Create a new file
	mov edx,OFFSET filename
	call CreateOutputFile
	mov fileHandle,eax

	;Check
	cmp eax, INVALID_HANDLE_VALUE
	jne file_ok
	mov edx,OFFSET str1
	call WriteString
	jmp quit
file_ok:
	;Input string
	mov edx,OFFSET str3
	call WriteString
	mov ecx,BUFFER_SIZE
	mov edx,OFFSET buffer
	call ReadString
	mov stringLength,eax

	;write to file
	mov eax,fileHandle
	mov edx,OFFSET buffer
	mov ecx,stringLength
	call WriteToFile
	mov bytesWritten,eax

	;close file
	mov eax,fileHandle
	call CloseFile
	

	;Display
	mov edx,OFFSET str2
	call WriteString
	mov edx,OFFSET filename
	call WriteString
	mov edx,OFFSET str4
	call WriteString
	mov eax,bytesWritten
	CALL WriteDec
	call Crlf

	;Open file
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle,eax
	
	;Check for errors
	cmp eax,INVALID_HANDLE_VALUE
	jne read_file
	mWrite <"Cannot open file",0dh,0ah,0>
	jmp quit

read_file:	
	;Read from file
	mov edx,OFFSET buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	mov buffer[eax],0
	mov edi,OFFSET buffer
	mov ecx,eax
	mov bl,97
	mov eax,0
transfer:
	cmp buffer[eax],bl
	jb next
	sub buffer[eax],32
next:
	add eax,1
	LOOP transfer

	mov edx,OFFSET buffer
	call WriteString
	call Crlf

	mov eax,fileHandle
	call CloseFile

	;Create a new output file
	mov edx,OFFSET out_file
	call CreateOutputFile
	mov fileHandle,eax

	;Check
	cmp eax, INVALID_HANDLE_VALUE
	jne out_file_ok
	mov edx,OFFSET str1
	call WriteString
	jmp quit
out_file_ok:
	;write to file
	mov eax,fileHandle
	mov edx,OFFSET buffer
	mov ecx,stringLength
	call WriteToFile
	mov bytesWritten,eax

	;close file
	mov eax,fileHandle
	call CloseFile
	

	;Display
	mov edx,OFFSET str2
	call WriteString
	mov edx,OFFSET out_file
	call WriteString
	mov edx,OFFSET str4
	call WriteString
	mov eax,bytesWritten
	CALL WriteDec
	call Crlf
	

quit:
	exit
main ENDP
END main
