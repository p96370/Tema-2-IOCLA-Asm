%include "../include/io.mac"

    ;;
    ;;   TODO: Declare 'avg' struct to match its C counterpart
    ;;
struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs
    extern printf

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ; I used the global array as it follows: 
    ; prio_result as a frequency array for priorities
    ; and time_result as the sum of all proccesses time with the same priority

    ; traverses the processes from last to first
traverse:
    ; checks if there are no more processes in array
    cmp ebx, 0
    je initialize

    xor esi, esi
    mov esi, ebx
    sub esi, 1
    shl esi, 2
    add esi, ebx
    sub esi, 1
    ; esi conteins the position to add on
    ; more precisely esi = (ebx - 1) * 5, because it is not allowed to 
    ; multiply by 5 inside instruction

    ; edx representes the current priority
    xor edx, edx
    lea edx, [ecx + esi + proc.prio] 
    movzx edx, byte [edx]
    
    ; substract 1 because position starts fom 0 to 4 
    ; and priorities are from 1 to 5
    sub edx, 1 

    ; increase frequence of the current priority in global array prio_result
    add dword [prio_result + edx * 4], 1
    
    ; extract time from current priority and place it in edi
    xor edi, edi
    lea edi, [ecx + esi + proc.time] 
    movzx edi, word [edi]

    ; edx holds position to add on
    ; edi holds time to add
    add dword [time_result + edx * 4], edi

    ; move to the element from left
    sub ebx, 1
    jmp traverse

initialize:
    ; getting ready to traverse the 2 newly calculated arrays
    ; their length is 5
    xor ecx, ecx
    mov ecx, 4
    xor esi, esi
    ; move the structure array in esi register in order to further use eax
    mov esi, eax

calculate_structure:
    cmp ecx, 0
    jl end
    
    ; eax, edx and ebx needed for div operation
    ; eax is the dividend
    mov eax, dword [time_result + ecx * 4]
    ; ebx is the divisor
    mov ebx, dword [prio_result + ecx * 4]

    ; if divisor is 0 skip divison
    cmp ebx, 0 
    je continue

    ; set edx to 0 because it will hold the remainder after divison
    xor edx, edx
    
    div ebx    
    
    ; put the results in the structure on correct fields
    mov word [esi + ecx * 4 + avg.quo], ax
    mov word [esi + ecx * 4 + avg.remain], dx

continue:
    dec ecx
    jmp calculate_structure

end:
    ;; Your code ends here
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY