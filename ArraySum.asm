global Java_JNIArraySum_computeNativeArraySum

section .data

    ; JNI function indexes can be found in the docs:
    ; http://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/functions.html
    GetIntArrayElements:     equ 187 * 8
    ReleaseIntArrayElements: equ 195 * 8

section .text

Java_JNIArraySum_computeNativeArraySum:

    push rdx                  ; save Java array pointer for later use
    push rdi                  ; save JNIEnv pointer for later use
    push rcx                  ; save array length for later use
    mov rsi, rdx              ; set array parameter for GetIntArrayElements
    mov rax, [rdi]            ; get location of JNI function table
    xor edx, edx              ; set isCopy parameter to false for GetIntArrayElements
    call [rax + GetIntArrayElements]
    pop rcx                   ; retrieve array length
    lea rcx, [rax + 4 * rcx]  ; compute loop end address (after last array element)
    mov r8, rax               ; copy native array pointer for later use
    xor ebx, ebx              ; initialise sum accumulator
    add_element:
        movsxd r9, dword [rax]; get current element
        add rbx, r9           ; add to sum
        add rax, 4            ; move array pointer to next element
        cmp rax, rcx          ; has all array been processed?
        jne add_element
    pop rdi                   ; retrieve JNIEnv
    pop rsi                   ; retrieve Java array pointer
    push rbx                  ; store sum result
    mov rax, [rdi]            ; get location of JNI function table
    mov rdx, r8               ; set elems parameter for ReleaseIntArrayElements
    call [rax + ReleaseIntArrayElements]
    pop rax                   ; retrieve sum result
    ret
