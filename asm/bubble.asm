; BUBBLE.ASM - Subrutinas de ordenamiento
; RegistroCE

.model small

; === VARIABLES EXTERNAS ===
EXTRN notas_int:BYTE
EXTRN contador_estudiantes:BYTE
EXTRN imprimir_cadena:PROC
EXTRN salto_linea:PROC
EXTRN convertir_y_mostrar_nota:PROC

.data
    ; === MENSAJES PARA ORDENAMIENTO ===
    msg_ordenado db "                   ",196,196,196,196,196,196,"[ CALIFICACIONES ORDENADAS ]",196,196,196,196,196,196, "$"

.code
PUBLIC burbuja_asc, burbuja_desc, mostrar_notas_ordenadas

; --- BURBUJA ASCENDENTE ---
; Ordena el arreglo "notas" de menor a mayor
burbuja_asc proc
    push cx
    push bx
    push si
    push di
    push ax

    mov cl, contador_estudiantes    ; número de estudiantes
    dec cl                          ; n-1 pasadas
    jz fin_burbuja_asc              ; si solo hay 1 estudiante, salir

bucle_externo_asc:
    mov si, 0                       ; índice = 0
    mov ch, cl                      ; comparaciones en esta pasada

bucle_interno_asc:
    ; cargar notas_int[si] y notas_int[si+1]
    mov bx, si
    mov al, byte ptr [notas_int + bx]      ; al = notas_int[i]
    mov dl, byte ptr [notas_int + bx + 1]  ; dl = notas_int[i+1]
    
    cmp al, dl
    jbe no_swap_asc

    ; --- swap ---
    mov byte ptr [notas_int + bx], dl
    mov byte ptr [notas_int + bx + 1], al

no_swap_asc:
    inc si                          ; siguiente índice
    dec ch
    jnz bucle_interno_asc

    dec cl
    jnz bucle_externo_asc

fin_burbuja_asc:
    pop ax
    pop di
    pop si
    pop bx
    pop cx
    ret
burbuja_asc endp

; --- BURBUJA DESCENDENTE ---
; Ordena el arreglo "notas" de mayor a menor
burbuja_desc proc
    push cx
    push bx
    push si
    push di
    push ax

    mov cl, contador_estudiantes    ; número de estudiantes
    dec cl                          ; n-1 pasadas
    jz fin_burbuja_desc             ; si solo hay 1 estudiante, salir

bucle_externo_desc:
    mov si, 0                       ; índice = 0
    mov ch, cl                      ; comparaciones en esta pasada

bucle_interno_desc:
    mov bx, si
    mov al, byte ptr [notas_int + bx]      ; al = notas_int[i]
    mov dl, byte ptr [notas_int + bx + 1]  ; dl = notas_int[i+1]
    
    cmp al, dl
    jae no_swap_desc

    ; --- swap ---
    mov byte ptr [notas_int + bx], dl
    mov byte ptr [notas_int + bx + 1], al

no_swap_desc:
    inc si                      ; siguiente par
    dec ch
    jnz bucle_interno_desc

    dec cl
    jnz bucle_externo_desc

fin_burbuja_desc:
    pop ax
    pop di
    pop si
    pop bx
    pop cx
    ret
burbuja_desc endp

mostrar_notas_ordenadas proc
    push ax
    push bx
    push cx
    push si
    push dx

    ; verificar si hay estudiantes
    cmp contador_estudiantes, 0
    je fin_mostrar_notas

    xor ch, ch                      ; limpiar parte alta
    mov cl, contador_estudiantes    ; número de estudiantes
    mov si, 0                       ; índice inicial

bucle_mostrar_notas:
    ; mostrar espacios iniciales para alinear
    mov ah, 02h
    mov dl, ' '
    int 21h
    mov dl, ' '
    int 21h
    mov dl, ' '
    int 21h
    mov dl, ' '
    int 21h
    mov dl, ' '
    int 21h
    
    ; cargar nota actual
    mov bx, si
    mov al, [notas_int + bx]
    
    ; convertir y mostrar la nota
    call convertir_y_mostrar_nota
    
    ; salto de línea después de cada nota
    call salto_linea
    
    ; siguiente nota
    inc si
    dec cl
    jnz bucle_mostrar_notas

fin_mostrar_notas:
    pop dx
    pop si
    pop cx
    pop bx
    pop ax
    ret
mostrar_notas_ordenadas endp

end