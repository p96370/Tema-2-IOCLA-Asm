section .data

section .text
    global bonus

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

build_matrix:
    cmp eax, 0 ; x = 0 
    je last_line

    cmp eax, 7 ; x = 7
    je first_line

    ; x is inside matrix

    cmp ebx, 0 ; y = 0
    je first_column

    cmp ebx, 7 ; y = 7
    je last_column

    ; y is also inside matrix so I have 4 neighbours

    xor esi, esi
    mov esi, ebx
    sub esi, 1
    
    xor edx, edx
    mov edx, 1

    ; after this loop in edx will be stored 2^(ebx - 1)
for_loop:
    shl edx, 1
    sub esi, 1
    cmp esi, 0
    jg for_loop

    xor edi, edi
    mov edi, eax
    sub edi, 1

    ; after this loop in edx will be stored the left lower neighbour
shift_up:
    shl edx, 8
    sub edi, 1
    cmp edi, 0
    jg shift_up

    xor edi, edi
    mov edi, edx
    shl edi, 2

    add edx, edi ; now in edx will be stored the right lower neighbour
    mov dword [ecx + 4], edx ; update the lower quadrant (the smaller number)

    xor edx, edx
    mov edx, 1

    cmp eax, 3 ; corner case if x is 3 
    je next_2_lines
    shl edx, 8

next_2_lines: ; esi is the left lower corner
    xor esi, esi
    mov esi, ebx
    sub esi, 1

for_loop_2:
    shl edx, 1
    sub esi, 1
    cmp esi, 0
    jg for_loop_2

    xor edi, edi
    mov edi, edx
    shl edi, 2

    add edx, edi
    mov dword [ecx + 0], edx
    jmp end

last_column:
    ; corner case for last column
    xor edx, edx
    mov edx, 1
    shl edx, 6

    xor esi, esi
    mov esi, eax
    sub esi, 1

    cmp esi, 0
    jg shift_last_column
    je continue_2

shift_last_column:
    cmp edx, 1073741824 ; 2^30
    jg only_upper_last
    shl edx, 8
    sub esi, 1
    cmp esi, 0
    jg shift_last_column

continue_2:
    xor edi, edi
    mov edi, edx
    shl edi, 16

    add edx, edi
    cmp eax, 3
    jg only_upper_last
    mov dword [ecx + 4], edx
    jmp end

only_upper_last:
    xor edx, edx
    mov edx, 1
    shl edx, 6

shift_what_is_left_2:
    shl edx, 8
    sub esi, 1
    cmp esi, 0
    jg shift_what_is_left_2

    xor edi, edi
    mov edi, edx
    shl edi, 16

    add edx, edi

    mov dword [ecx + 0], edx
    jmp end

first_column:
    ; corner case for first column
    xor edx, edx
    mov edx, 1
    shl edx, 1

    xor esi, esi
    mov esi, eax
    sub esi, 1

    cmp esi, 0
    jg shift_first_column
    je continue

shift_first_column:
    cmp edx, 33554432 ; 2^25, left upper border for lower number
    jg only_upper_first
    shl edx, 8
    sub esi, 1
    cmp esi, 0
    jg shift_first_column

continue:
    xor edi, edi
    mov edi, edx
    shl edi, 16

    add edx, edi
    cmp eax, 3
    jg only_upper_first
    mov dword [ecx + 4], edx
    jmp end

only_upper_first:
    xor edx, edx
    mov edx, 1
    shl edx, 1

shift_what_is_left:
    shl edx, 8
    sub esi, 1
    cmp esi, 0
    jg shift_what_is_left

    xor edi, edi
    mov edi, edx
    shl edi, 16

    add edx, edi

    mov dword [ecx + 0], edx
    jmp end

first_line:
    cmp ebx, 0 ; x = 7, y = 0
    je first_corner_up
    jg maybe_middle_up

maybe_middle_up:
    cmp ebx, 7
    je last_corner_up
    xor edx, edx
    mov edx, 1
    add ebx, 16
    sub ebx, 1
    xor esi, esi
    mov esi, ebx

shift_loop_up:
    shl edx, 1
    sub esi, 1
    cmp esi, 0
    jg shift_loop_up

    add ebx, 2
    xor esi, esi
    mov esi, ebx

    xor edi, edi
    mov edi, 1

shift_loop_up_2:
    shl edi, 1
    sub esi, 1
    cmp esi, 0
    jg shift_loop_up_2

    add edx, edi
    mov dword [ecx + 0], edx
    jmp end

last_corner_up:
    ; it only has left lower neighbour
    xor edx, edx
    mov edx, 1
    shl edx, 22
    mov dword [ecx + 0], edx 
    jmp end

first_corner_up:
    ; it only has right lower neighbour
    xor edx, edx
    mov edx, 1
    shl edx, 17
    mov dword [ecx + 0], edx 
    jmp end

last_line:
    cmp ebx, 0 ; x = 0 si y = 0
    je first_corner_down
    jg maybe_middle_down

first_corner_down:
    ; it only has right upper neighbour
    xor edx, edx
    mov edx, 1
    shl edx, 9
    mov dword [ecx + 4], edx
    jmp end

maybe_middle_down:
    cmp ebx, 7
    je last_corner_down ; x = 0, y = 7
    ; else there are 2 neighbours, both on the upper line
    xor edx, edx
    mov edx, 1

    sub ebx, 1
    add ebx, 8

    xor esi, esi
    mov esi, ebx

shift_loop_down:
    shl edx, 1
    sub esi, 1
    cmp esi, 0
    jg shift_loop_down

    xor edi, edi
    mov edi, 1
    add ebx, 2
    mov esi, ebx ; esi is position

shift_loop_down_2:
    shl edi, 1
    sub esi, 1
    cmp esi, 0
    jg shift_loop_down_2

    add edx, edi
    mov dword [ecx + 4], edx
    jmp end

last_corner_down:
    ; it only has left upper neighbour
    xor edx, edx
    mov edx, 1
    shl edx, 14
    mov dword [ecx + 4], edx
    jmp end

end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY