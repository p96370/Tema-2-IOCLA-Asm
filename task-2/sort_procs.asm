%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs
    extern printf

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    xor ecx, ecx
    mov ecx, eax

    ; traverse array from last to first and compare the current element 
    ; with the previous one so that the bigger one remains on the last position
traverse_array:
    ; for each position here traverse the array again starting with the current
    ; position to the beggining of the array
    cmp ecx, 1
    je end
    ; always reinitialize eax with length of array
    mov eax, [ebp + 12]     

traverse_swap:
    cmp eax, 1
    je continue_traverse
    xor ebx, ebx
    xor esi, esi

    ; compare ecx with eax
    
    ; esi = (eax - 1) * 5 temporary register used for calculating position
    mov esi, eax ; 
    sub esi, 1
    shl esi, 2
    add esi, eax
    sub esi, 1
    
    ; ebx hold  the priority of the current process
    lea ebx, [edx + esi + proc.prio]
    movzx ebx, byte [ebx]


    ; edi = (eax - 2) * 5, it is the position of the previous process
    xor edi, edi
    mov edi, esi
    sub edi, 5

    ; esi holds the priority of the previous process
    xor esi, esi
    lea esi, [edx + edi + proc.prio]
    movzx esi, byte [esi]

    ; compare the 2 priorities to see if the previous one is higher 
    ; than the current one, if so than swap them
    ; if the priorities are equal compare their time so that the last process
    ; if the highest
    cmp esi, ebx 
    jg swap
    je cmp_time

continue_traverse_swap:
    ; the second traverse continues and the current position decrements
    sub eax, 1
    jmp traverse_swap
    
continue_traverse:
    ; the first traverse continues and the current position decrements
    sub ecx, 1
    jmp traverse_array

swap:
    ; first swap 
    ; (eax - 2) * 5, used for position
    xor esi, esi
    mov esi, eax 
    sub esi, 2
    shl esi, 2
    add esi, eax
    sub esi, 2
    
    ; in edi is stored the priority of the previous process
    xor edi, edi
    lea edi, [edx + esi + proc.prio] 
    movzx edi, byte [edi]

    ; (eax - 1) * 5 = (eax - 2) * 5 + 5
    ; (eax - 1) * 5, position for current process
    add esi, 5 

    ; in ebx is stored the priority of the current process
    xor ebx, ebx
    lea ebx, [edx + esi + proc.prio] 
    movzx ebx, byte [ebx] 

    ; swap priorities
    sub esi, 5
    mov byte [edx + esi + proc.prio], bl
    add esi, 5
    mov ebx, edi
    mov byte [edx + esi + proc.prio], bl
    

    ; second swap
    ; (eax - 2) * 4 + eax - 2 = (eax - 2) * 5
    xor esi, esi
    mov esi, eax 
    sub esi, 2
    shl esi, 2
    add esi, eax
    sub esi, 2
    
    ; (eax - 1) * 5 = (eax - 2) * 5 + 5
    ; in edi is stored the time of the previous process
    xor edi, edi
    lea edi, [edx + esi + proc.time] 
    movzx edi, word [edi]

    add esi, 5 ; (eax - 1) * 4 + eax - 1

    ; in ebx is stored the time of the current process
    xor ebx, ebx
    lea ebx, [edx + esi + proc.time] 
    movzx ebx, word [ebx] 

    ; swap time
    mov word [edx + esi + proc.time], di
    sub esi, 5
    mov word [edx + esi + proc.time], bx

    xor ebx, ebx
    xor esi, esi

    ; the third swap
    xor esi, esi
    mov esi, eax ; (eax - 2) * 4 + eax - 2
    sub esi, 2
    shl esi, 2
    add esi, eax
    sub esi, 2
    
    ; (eax - 1) * 5 = (eax - 2) * 5 + 5

    ; in edi is stored the pid of the previous process
    xor edi, edi
    lea edi, [edx + esi + proc.pid] 
    movzx edi, word [edi]

    add esi, 5 ; (eax - 1) * 4 + eax - 1

    ; in ebx is stored the pid of the current process
    xor ebx, ebx
    lea ebx, [edx + esi + proc.pid] 
    movzx ebx, word [ebx]

    ; swap pid
    mov word [edx + esi + proc.pid], di
    sub esi, 5
    mov word [edx + esi + proc.pid], bx

    jmp continue_traverse_swap

cmp_time:
    xor ebx, ebx
    xor esi, esi

    ; esi = (eax - 1) * 5, temporary variable
    mov esi, eax 
    sub esi, 1
    shl esi, 2
    add esi, eax
    sub esi, 1

    ; in ebx is stored the time of the current process
    lea ebx, [edx + esi + proc.time]
    movzx ebx, word [ebx]

    ; edi = (eax - 2) * 5
    mov edi, esi
    sub edi, 5

    ; in esi is stored the time of the previous process
    xor esi, esi
    lea esi, [edx + edi + proc.time] 
    movzx esi, word [esi]

    ; compare the previous time with the current time
    cmp esi, ebx 
    jg swap
    je cmp_pid
    jl continue_traverse_swap

cmp_pid:
    xor ebx, ebx
    xor esi, esi

    ; esi = (eax - 1) * 5 temporary variable
    mov esi, eax 
    sub esi, 1
    shl esi, 2
    add esi, eax
    sub esi, 1

    ; ebx holds the pid of the current process
    lea ebx, [edx + esi + proc.pid]
    movzx ebx, word [ebx]

    ; edi = (eax - 2) * 5
    xor edi, edi
    mov edi, esi
    sub edi, 5

    ; esi holds the pid of the previous process
    xor esi, esi
    lea esi, [edx + edi + proc.pid] ;
    movzx esi, word [esi]

    ; compare pid
    cmp esi, ebx
    jg swap
    jmp continue_traverse_swap

end:
    ;; Your code ends here
   
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY