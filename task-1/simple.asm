%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain 
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ;PRINTF32 `lungimea este: %d\n\x0`, ecx
    cmp edx, 26
    jl shift
    jg prepare
    ; if step is exactly 26 becomes 0
    xor edx, edx 
    jmp shift

    ; bring step to be strictly less than 26
prepare:
    sub edx, 26
    cmp edx, 26
    jg prepare
    je prepare

shift:
    ; ecx contains the position (in descending order)
    cmp ecx, 0
    je sfarsit

    ; extract letter from input string 
    xor eax, eax
    mov al, byte [esi + ecx - 1]

    ; add step to encrypt letter from position ecx - 1
    add al, dl
    ; check if new letter is higher than Z
    cmp al, 90
    jg check

continue:
    ; copy the new letter in the encryption string, held in register edx
    mov byte [edi + ecx - 1], al
    ; move to the left position
    sub ecx, 1 
    jmp shift

check:
    ; if new letter is higher than Z substract 26 from his ascii code
    ; it is exactly the same as if I calculate modulo 26, because the step
    ; is surely less than 26
    sub al, 26
    jmp continue

sfarsit:
    ;; Your code ends here
    ;; DO NOT MODIFY
    popa
    leave
    ret

    ;popa
    ;leave
    ;ret
    
    ;; DO NOT MODIFY
