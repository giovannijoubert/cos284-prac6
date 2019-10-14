section .text
global trieContains

trieContains:   
        push    rbp
        mov     rbp, rsp
        mov     qword  [rbp - 16], rdi
        mov     qword  [rbp - 24], rsi
        mov     rsi, qword  [rbp - 16]
        mov     qword  [rbp - 32], rsi
        mov     dword  [rbp - 36], 0
.forloopone:                             
        mov     rax, qword  [rbp - 24]
        movsxd  rcx, dword  [rbp - 36]
        movsx   edx, byte  [rax + rcx]
        cmp     edx, 0
        je      .cleanup
        mov     rax, qword  [rbp - 24]
        movsxd  rcx, dword  [rbp - 36]
        movsx   edx, byte  [rax + rcx]
        sub     edx, 97
        mov     dword  [rbp - 40], edx
        mov     rax, qword  [rbp - 24]
        mov     edx, dword  [rbp - 36]
        add     edx, 1
        movsxd  rcx, edx
        movsx   edx, byte  [rax + rcx]
        cmp     edx, 0
        jne     .conditional
        mov     rax, qword  [rbp - 32]
        movsxd  rcx, dword  [rbp - 40]
        movsx   edx, byte  [rax + rcx + 208]
        cmp     edx, 1
        sete    sil
        and     sil, 1
        movzx   edx, sil
        mov     dword  [rbp - 4], edx
        jmp     .fin
.conditional:                               
        mov     rax, qword  [rbp - 32]
        movsxd  rcx, dword  [rbp - 40]
        cmp     qword  [rax + 8*rcx], 0
        jne     .endforloopone
        mov     dword  [rbp - 4], 0
        jmp     .fin
.endforloopone:                               
        mov     rax, qword  [rbp - 32]
        movsxd  rcx, dword  [rbp - 40]
        mov     rax, qword  [rax + 8*rcx]
        mov     qword  [rbp - 32], rax
        jmp     .endit
.endit:                              
        jmp     .conditionaltwo
.conditionaltwo:                               
        mov     eax, dword  [rbp - 36]
        add     eax, 1
        mov     dword  [rbp - 36], eax
        jmp     .forloopone
.cleanup:
        ud2
.fin:
        mov     eax, dword  [rbp - 4]
        pop     rbp
        ret