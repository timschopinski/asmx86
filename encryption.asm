.686
.model flat

extern _malloc : proc

public _encrypt

.data
lower_alphabet db 'abcdefghijklmnopqrstuvwxyz', 0
upper_alphabet db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 0
alphabet_length dd 25
.code

_find_position proc
push ebp
mov ebp, esp
push ecx
push edx
push ebx
push esi
push edi

mov esi, [ebp + 8] ; array address
mov ebx, [ebp + 12] ; element

xor ecx, ecx ; position counter
xor edx, edx
search:
mov dl, byte ptr[esi + ecx]
cmp dl, 0
je not_found
cmp dl, bl
je finish_search
inc ecx
jmp search

not_found:
mov ecx, -1 ; -1 if not found

finish_search:
mov eax, ecx ; result
pop edi
pop esi
pop ebx
pop edx
pop ecx
pop ebp
ret
_find_position endp

_encrypt proc
push ebp
mov ebp, esp
push ebx
push ecx
push edx
push edi
push esi
sub esp, 16

mov esi, [ebp + 8] ; text address
mov edi, [ebp + 12]; text_length

mov [esp], edi ; save for later text_length

; allocate memory
inc edi
push edi
call _malloc
add esp, 4
cmp eax, 0
je finish
mov [esp + 4], eax ; save allocated memory address

mov edi, [ebp + 16]; shift
mov [esp + 8], edi

xor ecx, ecx ; counter
xor edx, edx
xor ebx, ebx
main_loop:
mov edx, [esp] ; get text_length
cmp ecx, edx
je finish
xor edx, edx
mov dl, byte ptr [esi + ecx]
push edx
push offset lower_alphabet
call _find_position
add esp, 8

cmp eax, -1 ; check if not found
jne set_lower_alphabet_address

push edx
push offset upper_alphabet
call _find_position
add esp, 8
cmp eax, -1
je finish
set_upper_alphabet_address:
mov [esp + 12], offset upper_alphabet; set upperalphabet address to use
jmp write_shifted_letter

set_lower_alphabet_address:
mov [esp + 12], offset lower_alphabet ; set lower alphabet address to use

write_shifted_letter:
; position in eax
mov edi, [esp + 8]
add eax, edi ; add shift
cmp eax, alphabet_length
jbe no_alphabet_overflow
sub eax, alphabet_length
dec eax ; magic number xD
no_alphabet_overflow:
mov edx, [esp + 4] ; get allocated array
mov edi, [esp + 12] ; set alphabet address
mov bl, byte ptr [edi + eax]
mov [edx + ecx], byte ptr bl ; write to allocated memory
jmp set_indexes

set_indexes:
inc ecx
jmp main_loop


finish:
mov edi, [esp]
mov eax, [esp + 4]
mov [eax + edi], byte ptr 0 ; add 0 at the end
add esp, 16 ; remove allocated memory on stack
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop ebp
ret
_encrypt endp
end
