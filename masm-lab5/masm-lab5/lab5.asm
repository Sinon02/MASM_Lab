INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 1024

.data
stack1  DWORD BUFFER_SIZE DUP(?) ;stores number
stack2  DWORD BUFFER_SIZE DUP(?) ;stores operator
expr_string	 BYTE BUFFER_SIZE DUP(?) ;stores expression
string2int BYTE BUFFER_SIZE DUP(?) ;string2int
stack1_top DWORD ?
stack2_top DWORD ?
string_len DWORD ?
number_len DWORD ?
index DWORD ?
left_number DWORD ?
right_number DWORD ?
opt DWORD ?
.code
main PROC
.code
	mov edx,OFFSET expr_string
	mov ecx,BUFFER_SIZE
	call ReadString
	mov string_len,eax
	mov stack1_top,0
	mov stack2_top,0
	mov index,0
	mov number_len,0
readin:
	mov eax,index
	add index,1
	cmp eax,string_len
	jge quit
	movzx ebx,expr_string[eax]
	cmp ebx,40 ;40 is (
	jl quit
	cmp ebx,48 ;48 is 0
	jl operator
	mov ecx,number_len
	mov string2int[ecx],bl
	add number_len,1
	jmp readin
operator:
	cmp number_len,0
	jne str2int
operator_jmp_back:
	cmp ebx,45
	je is_neg
	cmp ebx,41
	je is_right
	cmp ebx,'+'
	je is_plus
	mov ecx,stack2_top
	mov stack2[ecx*4],ebx
	add stack2_top,1
	jmp readin
str2int:
	push ebx
	mov edx,OFFSET string2int
	mov ecx,number_len
	call ParseInteger32
	push eax
	mov ecx,number_len
	mov edi,OFFSET string2int
	mov eax,0
	cld
	REP stosb
	mov number_len,0
	pop eax
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	pop ebx
	jmp operator_jmp_back
is_neg:
	mov ecx,index
	cmp index,1
	je negetive
	movzx eax,expr_string[ecx-2]
	cmp eax,41 ;)
	je push_neg
	cmp eax,48 ;0
	jge push_neg
negetive:
	mov eax,45
	mov ecx,0
	mov string2int[ecx],al
	mov number_len,1
	jmp readin
push_neg:
	mov ecx,stack2_top
	cmp ecx,0
	je push_sub
	mov edx,'-'
	mov eax,stack2[ecx*4-4]
	cmp eax,'+'
	je calculate
	cmp eax,'-'
	je calculate
push_sub:
	mov stack2[ecx*4],'-'
	add stack2_top,1
	jmp readin
calculate:
	mov opt,eax
	mov ecx,stack2_top
	mov stack2[ecx*4-4],edx
	mov ecx,stack1_top
	sub stack1_top,2
	mov eax,stack1[ecx*4-4]
	mov right_number,eax
	mov eax,stack1[ecx*4-8]
	cmp opt,43
	je cal_add
	sub eax,right_number
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	jmp readin
cal_add:
	add eax,right_number
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	jmp readin
is_plus:
	mov ecx,stack2_top
	cmp ecx,0
	je push_plus
	mov edx,'+'
	mov eax,stack2[ecx*4-4]
	cmp eax,'+'
	je calculate
	cmp eax,'-'
	je calculate
push_plus:
	mov stack2[ecx*4],'+'
	add stack2_top,1
	jmp readin
	
is_right:
	mov ecx,stack2_top
	sub stack2_top,1
	cmp ecx,0 ;operator stack is empty?
	je quit
	mov eax,stack2[ecx*4-4]
	cmp eax,40
	je readin
	mov opt,eax
	mov ecx,stack1_top
	sub stack1_top,2
	mov eax,stack1[ecx*4-4]
	mov right_number,eax
	mov eax,stack1[ecx*4-8]
	cmp opt,43
	je add_
sub_:
	sub eax,right_number
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	jmp is_right
add_:
	add eax,right_number
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	jmp is_right
	
quit:
	cmp number_len,0
	je quit_loop
	mov edx,OFFSET string2int
	mov ecx,number_len
	call ParseInteger32
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	mov number_len,0
quit_loop:
	mov ecx,stack2_top
	sub stack2_top,1
	cmp ecx,0 ;operator stack is empty?
	je exit_
	mov eax,stack2[ecx*4-4]
	mov opt,eax
	mov ecx,stack1_top
	sub stack1_top,2
	mov eax,stack1[ecx*4-4]
	mov right_number,eax
	mov eax,stack1[ecx*4-8]
	cmp opt,43
	je quit_add
quit_sub:
	sub eax,right_number
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	jmp quit_loop
quit_add:
	add eax,right_number
	mov ecx,stack1_top
	mov stack1[ecx*4],eax
	add stack1_top,1
	jmp quit_loop
	
exit_:
	mov eax,stack1[0]
	call WriteInt
	exit
main ENDP
END main