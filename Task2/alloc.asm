section .text
global trieAlloc
global trieInit

extern malloc
trieAlloc:     

        mov     rdi, 240
        call    malloc
        ret

trieInit:
        push    rbp
        mov     rbp, rsp
        mov     QWORD  [rbp-24], rdi
        mov     DWORD  [rbp-4], 0
.forloop:
        cmp     DWORD  [rbp-4], 25
        jg      .endloop
        mov     rax, QWORD  [rbp-24]
        mov     edx, DWORD  [rbp-4]
        mov     QWORD  [rax+rdx*8], 0
        mov     rdx, QWORD  [rbp-24]
        mov     eax, DWORD  [rbp-4]
        cdqe
        mov     BYTE  [rdx+208+rax], 0
        add     DWORD  [rbp-4], 1
        jmp     .forloop
.endloop:
        nop
        pop     rbp
        ret