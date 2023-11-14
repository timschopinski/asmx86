.686
.model flat

public _days_until

.data

days_in_month db 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 0

.code


_days_until proc
push ebp
mov ebp, esp
push ebx
push ecx
push edx
push edi
push esi

mov esi, [ebp + 8]
xor ebx, ebx
mov bx, word ptr [esi + 3] ; get month
xor eax, eax
mov al, bl
sub eax, 30h
mov edi, 10
xor edx, edx
mul edi
mov edx, eax
xor eax, eax
mov al, bh
sub eax, 30h

add edx, eax
dec edx ; number of months

xor edi, edi
xor eax, eax
xor ebx, ebx
xor ecx, ecx
mov edi, offset days_in_month
ptl:
cmp ecx, edx
je finish_ptl
mov bl, byte ptr [edi + ecx]
add eax, ebx
inc ecx
jmp ptl

finish_ptl:

mov edi, eax ; save resut

xor eax, eax
xor ecx, ecx
xor ebx, ebx
mov bx, word ptr [esi]
mov al, bl
sub eax, 30h

mov ecx, 10
xor edx, edx
mul ecx
xor edx, edx
mov dl, bh
sub edx, 30h

add eax, edx

add eax, edi
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop ebp
ret
_days_until endp
end
