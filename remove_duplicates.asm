.686
.model flat

extern _malloc : proc

public _remove_duplicates

.data

.code

_find proc
push ebp
mov ebp, esp
push ecx
push esi
push edi
push edx
push ebx

mov esi, [ebp + 8] ; element
mov edi, [ebp + 12] ; number of elements
mov edx, [ebp + 16] ; array
xor ecx, ecx
mov eax, 0
ptl:
cmp ecx, edi
je finish_ptl
mov ebx, [edx + 4*ecx]
cmp ebx, esi
je exists
inc ecx
jmp ptl

exists:
mov eax, 1

finish_ptl:

pop ebx
pop edx
pop edi
pop esi
pop ecx
pop ebp
ret
_find endp

_remove_duplicates proc
push ebp
mov ebp, esp
push ebx
push ecx
push edx
push esi
push edi
sub esp, 12
mov esi, [ebp + 8]

xor ecx, ecx
count:
mov ebx, [esi + ecx*4]
cmp ebx, 0cccccccch
je finish_count
inc ecx
jmp count
finish_count:
mov [esp], ecx
shl ecx, 2
push ecx
call _malloc
add esp, 4

cmp eax, 0
je finish

mov [esp + 4], eax ; save address
xor ecx, ecx; old counter
xor edi, edi; new counter
create_array:
cmp ecx, [esp]
je finish

mov ebx, dword ptr [esi + ecx*4]
mov eax, dword ptr [esp + 4]
push eax
push edi
push ebx
call _find
add esp, 12
cmp eax, 0
jne skip
mov eax, dword ptr [esp + 4]
mov [eax + 4*edi], dword ptr ebx
inc edi

skip:
inc ecx
jmp create_array

finish:
mov eax, [esp + 4]
add esp, 12
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop ebp
ret
_remove_duplicates endp
end
