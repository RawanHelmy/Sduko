;-------------------------------------------------
; Starting Sduko Game
;-------------------------------------------------

INCLUDE Irvine32.inc
BUFFER_SIZE = 5000
.data
unsolved byte 81 dup (?)
solved byte 81 dup (?)
line byte 3, 6, 12, 15, 21, 24, 30, 33, 39, 42, 48, 51, 57, 60, 66, 69, 75, 78
dash byte 27,54

buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "rawan.txt"
fileHandle HANDLE ?
stringLength DWORD ? 
starttime DWORD ?
endtime DWORD ?
.code
main PROC
INVOKE GetTickCount                        ; gets the current time
mov starttime , eax
call ReadBoardFile                        ; reads the data from the file to the buffer


;call SaveTheBoard                         ;l 3ashan el function de tsht3'l 7oto ay 7aga f el buffer 
;call display                               ; bta3t fatma w esraaa

mov edx ,offset buffer                     ; b3d ma aret mn el file 7ateto f el buffer 
call writestring                           ;w btl3o  

INVOKE GetTickCount
sub eax , starttime
mov eax ,endtime                          ; calculates time in milisecond    



exit
main ENDP



ReadBoardFile PROC uses edx  eax  ecx  ; file name should be in the variable 

mov edx,OFFSET filename
call OpenInputFile
mov fileHandle,eax
                                             ; Check for errors.
cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
jne file_ok                                  ; no: skip
jmp quit                                     ; and quit
file_ok:
                                             ; Read the file into a buffer.
mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size                        ; error reading?

call WriteWindowsMsg
jmp close_file
check_buffer_size:
cmp eax,BUFFER_SIZE                          ; buffer large enough?
jb buf_size_ok ; yes
jmp quit                                     ; and quit
buf_size_ok:
mov buffer[eax],0                            ; insert null terminator


mov ecx , eax                                ; change zeros to the character
mov edx, 0                                   ; b3'ayr e; zero b dash 3ashn mostafa kn 3yz keda 
mov bl , '_'                           
l1 :
cmp buffer[edx] , '0'
jz en                                        ; ana tol el w2t ht3ml m3 el buffer 
jmp l2                                       ; k2no characters w strings mfesh 7aga hena f el code da esmaha int
en:
mov buffer[edx] ,bl
l2 :
add edx , 1

loop l1

close_file:                            
mov eax,fileHandle
call CloseFile

quit:
RET
ReadBoardFile ENDP


SaveTheBoard PROC  uses edx  eax ; save the current board

mov edx ,offset filename
call CreateOutputFile 
mov fileHandle,eax 

                               ; Check for errors. 
cmp eax, INVALID_HANDLE_VALUE  ; error found? 
jne file_ok                    ; no: skip 

jmp quit 

file_ok:            
                               ; Write the buffer to the output file. 
mov eax,fileHandle 
mov edx,OFFSET buffer          ; the buffer should include the name of the solved and the unsolved file
mov ecx,stringLength 
call WriteToFile 

call CloseFile                 ; Display the return value. 

quit: 
RET


SaveTheBoard ENDP

display proc  ; bta3 fatma w esraa

pushad
mov ecx,81
mov edi ,offset unsolved
mov edx, 0
mov esi, 1
mov ebx, 9
mov eax, 0
l1:
	push eax
	mov eax,[edi]
	call writedec
	mov al, ' '
	call writechar
	pop eax
	cmp ebx,esi
	jne end_if_1
		call crlf
		add ebx, 9
	end_if_1:
	push edx
	mov edx, offset line
	push eax
	movzx eax, al
	add edx, eax
	pop eax 
	movzx edx, byte ptr[edx]
	cmp	esi, edx
	pop edx
	jne end_if_2
		push eax
		mov al, '|'
		call writechar
		mov al, ' '
		call writechar
		pop eax
		inc al
	end_if_2:
	push edx
	mov edx, offset dash
	push eax
	movzx eax, ah
	add edx, eax
	pop eax 
	movzx edx, byte ptr[edx]
	cmp	esi, edx
	pop edx
	jne end_if_3
		push eax
		push ecx
		mov al, '-'
		mov ecx, 21
		l2:
			call writechar
		loop l2
		pop ecx
		pop eax
		call crlf
		inc ah
	end_if_3:
	inc esi
	inc edi
loop l1
popad
ret
display endp

END main