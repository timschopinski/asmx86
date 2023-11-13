.686
.model flat

extern _malloc : proc

public _replace
; char* replace(char* text, char* text_to_replace, char* replacement_text);

.data

buffor db 255 dup (?) ; buffor for result
compare_buffor db 16 dup (?) ; buffor for text_to_replace

.code

_write_text proc
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx
	push ecx
	push edx

	mov esi, [ebp + 12] ; addres of text
	mov edi, [ebp + 8] ; address of replacement_text
	xor ecx, ecx ; counter

	write_text_loop:
		mov bl, byte ptr [edi + ecx]
		cmp bl, 0
		je finish_write_text_loop
		mov [esi + ecx], byte ptr bl
		inc ecx
		jmp write_text_loop

	finish_write_text_loop:


	pop edx
	pop ecx
	pop ebx
	pop esi
	pop esi
	pop ebp
	ret
_write_text endp

_compare proc
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx
	push edx
	push ecx
	
	mov esi, [ebp + 12] ; text address
	mov edi, [ebp + 8]; text_to_replace address

	xor edx, edx
	xor ebx, ebx
	xor ecx, ecx ; counter
	xor eax, eax ; comparison flag, if eax = 0 equal else not eqal
	compare:
		mov bl, byte ptr [esi + ecx] ; text character
		mov dl, byte ptr [edi + ecx] ; text_to_replace character
		inc ecx

		cmp dl, 0
		je finish_compare

		cmp bl, 0
		je not_equal

		cmp dl, bl
		je compare

	not_equal:
	mov eax, 1

	finish_compare:


	pop ecx
	pop edx
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_compare endp

_get_length proc
	push ecx
	push ebx

	xor ecx, ecx
	count:
		mov bl, byte ptr [eax + ecx]
		inc ecx
		cmp bl, 0
		jne count
	dec ecx
	mov eax, ecx
	pop ebx
	pop ecx
	ret
_get_length endp

_replace proc
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	push edi
	push esi
	sub esp, 20 ; allocate 16 bytes of memory on stack

	mov ebx, [ebp + 8] ; assign text address to ebx
	mov esi, [ebp + 12] ; assign text_to_replace address to esi
	mov edi, [ebp + 16] ; assign replacement_text address to edi

	; count nmber of character of the replacement_text
	mov eax, edi
	call _get_length
	mov [esp], eax

	; count nmber of character of the text_to_replace
	mov eax, esi
	call _get_length
	mov [esp  + 4], eax


	; allocate memory for output text -> current one times two
	mov eax, ebx
	call _get_length

	shl eax, 1 ; multiply by 2
	call _malloc

	; push allocated memory address to stack
	mov [esp + 8], eax

	xor ecx, ecx ; counter helper
	xor edx, edx ; main characters buffor
	mov eax, 0
	mov [esp + 12], eax ; input text counter
	mov [esp + 16], eax ; output text counter
	main_loop:
		mov ecx, [esp + 12]
		mov dl, byte ptr [ebx + ecx] ; text character

		cmp dl, 0
		je finish_main_loop

		mov eax, ebx
		mov ecx, [esp + 12]
		add eax, ecx
		push eax ; push current character address to stack
		push esi ; push text to replace on stack
		call _compare
		add esp, 8 ; clean stack
		cmp eax, 0 ; check if equal
		je replace_text

		not_replace_text:
		mov eax, [esp + 8] ; output text address
		mov ecx, [esp + 16]
		add eax, ecx ; assing propper index
		mov [eax], byte ptr dl
		inc ecx
		mov [esp + 16], ecx
		mov ecx, [esp + 12]
		inc ecx
		mov [esp + 12], ecx
		jmp skip

		replace_text:

		mov eax, [esp + 8]
		mov ecx, [esp + 16]
		add eax, ecx ; assing propper index
		push eax ; push address of result text
		push edi ; push addres of replacement_text
		call _write_text
		add esp, 8
		; add propper indexes
		mov ecx, [esp] ; length of replacement_text
		mov eax, [esp + 16] ; outpt buffor index
		add eax, ecx
		mov [esp + 16], eax

		mov ecx, [esp + 4] ; length of text_to_replace
		mov eax, [esp + 12] ; input buffor index
		add eax, ecx
		mov [esp + 12], eax

		skip:
		jmp main_loop

	finish_main_loop:
	mov ecx, [esp + 16]
	mov eax, [esp + 8]
	mov [eax + ecx], byte ptr 00h
	
	add esp, 20
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop ebp
	ret
_replace endp
end
