INCLUDE Irvine32.inc
BUFFER_SIZE = 501
.data
buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "Input1.txt",0
fileHandle HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file [output.txt]: ",0
str3 BYTE "Enter up to 500 characters and press "
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
	call CloseFile

	;Display
	mov edx,OFFSET str2
	call WriteString
	mov eax,bytesWritten
	CALL WriteDec
	call Crlf

quit:
	exit
main ENDP
END main
