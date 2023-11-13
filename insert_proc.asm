.686

.model flat

extern _malloc : proc

public _insert

.data

.code

_insert proc
push ebp
mov ebp, esp
push ebx
push ecx
push edx
push esi
push edi
sub esp, 12
mov esi, [ebp + 8] ; array address

xor ecx, ecx; counter
count_elements:
mov edx, dword ptr [esi + 4*ecx]
cmp edx, 0cccccccch
je finish_count_elements
add ecx, 1
jmp count_elements

finish_count_elements:
mov [esp + 8], ecx
inc ecx ; add place for the element that will be added
shl ecx, 2 ; multiply by 4 
push ecx
call _malloc
add esp, 4
cmp eax, 0
je finish

mov edi, [ebp + 12] ; element
mov edx, [ebp + 16] ; position
xor ecx, ecx ; counter helper

mov [esp], ecx ; old array index
mov [esp + 4], ecx ; new array index
main_loop:
mov ecx, dword ptr [esp]
cmp ecx, edx
je insert_element
cmp ecx, [esp + 8] 
je finish
mov ecx, dword ptr [esp]
mov ebx, dword ptr [esi + 4*ecx] ; get array element
mov ecx, dword ptr [esp + 4]
mov [eax + 4*ecx], dword ptr ebx
inc ecx
mov [esp + 4], dword ptr ecx
mov ecx, dword ptr [esp]
inc ecx
mov [esp], dword ptr ecx
jmp skip
insert_element:
mov ecx, dword ptr [esp + 4]
mov [eax + 4*ecx], dword ptr edi
inc ecx
mov [esp + 4], dword ptr ecx
mov edx, -1

skip:
jmp main_loop



finish:
add esp, 12
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop ebp
ret
_insert endp

end
