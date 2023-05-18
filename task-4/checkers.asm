
section .data

section .text
	global checkers
    extern printf

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    xor edx, edx

build_matrix:
    ; case x = 0, the element is on the last line
    cmp eax, 0
    je last_line

    ; case x = 7, the element is on the first line
    cmp eax, 7
    je first_line

    ; x is inside the matrix

    ; y = 0, the element is on the first column
    cmp ebx, 0 
    je first_column

    ; y = 7, the element is on the last column
    cmp ebx, 7
    je last_column

    ; y is also inside matrix

    ; edx stores position of the left lower neighbour
    ; equivalent to 8 * (eax - 1) + ebx - 1 + 2
    xor edx, edx
    mov edx, eax 
    sub edx, 1
    shl edx, 3
    add edx, ebx
    sub edx, 1

    ; changing the left and right lower neighbours
    mov byte [ecx + edx], 1
    mov byte [ecx + edx + 2], 1

    add edx, 16 ; 8 * (eax - 1) + ebx - 1  + 16

    ; left and right upper neighbours
    mov byte [ecx + edx], 1
    mov byte [ecx + edx + 2], 1

    jmp end

last_column:
    ; the only 2 neighbours are on the line from left
    ; calculates the valid position of the neighbours
    ; left neighbour
    mov byte [ecx + 8 * (eax - 1) + 6], 1
    ; right neighbour
    mov byte [ecx + 8 * (eax + 1) + 6], 1
    jmp end

first_column:
    ; the only 2 neighbours are on the line from right
    ; calculates the valid position of the neighbours
    ; left neighbour
    mov byte [ecx + 8 * (eax - 1) + 1], 1
    ; right neighbour
    mov byte [ecx + 8 * (eax + 1) + 1], 1
    jmp end

first_line:
    cmp ebx, 0 
    je first_corner_up
    jg maybe_middle_up

maybe_middle_up:
    cmp ebx, 7
    je last_corner_up
    ; else there are 2 neighbours, both on the line below
    ; left neighbour
    mov byte [ecx + 8 * 6 + ebx - 1], 1
    ; right neighbour
    mov byte [ecx + 8 * 6 + ebx + 1], 1
    jmp end

last_corner_up:
    ; case corner x = 7, y = 7
    ; only left lower neighbour
    mov byte [ecx + 8 * 6 + 6], 1
    jmp end

first_corner_up:
    ; case corner x = 7, y = 0
    ; only right lower neighbour
    mov byte [ecx + 8 * 6 + 1], 1
    jmp end

last_line:
    ; x = 0
    cmp ebx, 0 
    je first_corner_down
    jg maybe_middle_down

first_corner_down:
    ; corner case x = 0 si y = 0
    ; only right upper neighbour
    mov byte [ecx + 8 + 1], 1
    jmp end

maybe_middle_down:
    cmp ebx, 7
    je last_corner_down 
    ; else there are 2 neighbours, both on the above line
    ; left neighbour
    mov byte [ecx + 8 + ebx - 1], 1
    ; right neighbour
    mov byte [ecx + 8 + ebx + 1], 1
    jmp end

last_corner_down:
    ; corner case x = 0, y = 7
    ; only left upper neighbour
    mov byte [ecx + 8 + 6], 1
    jmp end

end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY