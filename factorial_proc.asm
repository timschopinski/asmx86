.686
.model flat

public _factorial

.data

.code


_factorial proc
	push ebp
	mov ebp, esp
	push ecx
	push edx
	push ebx
	mov ebx, dword ptr [ebp + 8]
	mov eax, 1
	mov ecx, 1
	multiply:
		xor edx, edx
		cmp ecx, ebx
		je finish
		inc ecx
		mul ecx
		jmp multiply
	
	finish:

	pop ebx
	pop edx
	pop ecx
	pop ebp
	ret
_factorial endp
end
