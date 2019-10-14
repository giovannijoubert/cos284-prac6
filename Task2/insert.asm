section .text
global trieInsert

extern malloc
extern trieAlloc
extern trieInit
trieInsert
      push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     qword  [rbp - 8], rdi
        mov     qword  [rbp - 16], rsi
        mov     rsi, qword  [rbp - 8]
        mov     qword  [rbp - 24], rsi
        mov     dword  [rbp - 28], 0
.forloopone:                              
        mov     rax, qword  [rbp - 16]
        movsxd  rcx, dword  [rbp - 28]
        movsx   edx, byte  [rax + rcx]
        cmp     edx, 0
        je      .endit
        mov     rax, qword  [rbp - 16]
        movsxd  rcx, dword  [rbp - 28]
        movsx   edx, byte  [rax + rcx]
        sub     edx, 97
        mov     dword  [rbp - 32], edx
        mov     rax, qword  [rbp - 16]
        mov     edx, dword  [rbp - 28]
        add     edx, 1
        movsxd  rcx, edx
        movsx   edx, byte  [rax + rcx]
        cmp     edx, 0
        jne     .forlooptwo
        mov     rax, qword  [rbp - 24]
        movsxd  rcx, dword  [rbp - 32]
        mov     byte  [rax + rcx + 208], 1
        jmp     .jumpout
.forlooptwo:                               
        mov     rax, qword  [rbp - 24]
        movsxd  rcx, dword  [rbp - 32]
        cmp     qword  [rax + 8*rcx], 0
        jne     .endforloopone
        call    trieAlloc
        mov     rcx, qword  [rbp - 24]
        movsxd  rdx, dword  [rbp - 32]
        mov     qword  [rcx + 8*rdx], rax
        mov     rax, qword  [rbp - 24]
        movsxd  rcx, dword  [rbp - 32]
        mov     rdi, qword  [rax + 8*rcx]
        call    trieInit
.endforloopone:                               
        mov     rax, qword  [rbp - 24]
        movsxd  rcx, dword  [rbp - 32]
        mov     rax, qword  [rax + 8*rcx]
        mov     qword  [rbp - 24], rax
.jumpout:                              
        jmp     .endfoorlooptwo
.endfoorlooptwo:                              
        mov     eax, dword  [rbp - 28]
        add     eax, 1
        mov     dword  [rbp - 28], eax
        jmp     .forloopone
.endit:
        add     rsp, 32
        pop     rbp
        ret