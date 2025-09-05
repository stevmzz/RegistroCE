; BUBBLE.ASM - Subrutinas de ordenamiento
; RegistroCE

.model small

; === VARIABLES EXTERNAS ===
EXTRN notas_int:BYTE
EXTRN contador_estudiantes:BYTE
EXTRN imprimir_cadena:PROC
EXTRN salto_linea:PROC
EXTRN convertir_y_mostrar_nota:PROC
EXTRN nombres_completos:BYTE
EXTRN indices_ordenados:BYTE
EXTRN MAX_ESTUDIANTES:ABS
EXTRN NOMBRE_COMPLETO:ABS

.data
; mensajes para ordenamiento
msg_ordenado db "                   ",196,196,196,196,196,196,"[ CALIFICACIONES ORDENADAS ]",196,196,196,196,196,196, "$"

.code
PUBLIC burbuja_asc, burbuja_desc, mostrar_notas_ordenadas

; subrutina para inicializar el array de indices con 0,1,2,3...
inicializar_indices proc
    push ax
    push bx
    push cx
    xor ah, ah
    mov al, contador_estudiantes ; numero de estudiantes
    mov cx, ax ; contador para loop
    mov bx, 0 ; indice actual

init_loop:
    cmp cx, 0 ; terminamos?
    je fin_init
    mov byte ptr [indices_ordenados + bx], bl ; guardar indice
    inc bx ; siguiente indice
    dec cx ; decrementar contador
    jmp init_loop

fin_init:
    pop cx
    pop bx
    pop ax
    ret
inicializar_indices endp

; subrutina para ordenar estudiantes de menor a mayor nota usando burbuja
burbuja_asc proc
    push cx
    push bx
    push si
    push di
    push ax
    push dx
    call inicializar_indices ; llenar array de indices
    mov cl, contador_estudiantes ; numero de estudiantes
    dec cl ; n-1 pasadas
    jz fin_burbuja_asc ; si solo hay 1, salir

bucle_externo_asc:
    mov si, 0 ; indice inicial
    mov ch, cl ; comparaciones en esta pasada

bucle_interno_asc:
    mov bx, si
    ; obtener indices a comparar
    mov al, byte ptr [indices_ordenados + bx] ; indice i
    mov dl, byte ptr [indices_ordenados + bx + 1] ; indice i+1
    ; obtener notas de esos estudiantes
    push bx
    push dx
    xor ah, ah
    mov bx, ax
    mov al, byte ptr [notas_int + bx] ; nota del estudiante i
    pop dx
    push ax
    xor dh, dh
    mov bx, dx
    mov dl, byte ptr [notas_int + bx] ; nota del estudiante i+1
    pop ax
    pop bx
    ; comparar notas
    cmp al, dl ; nota[i] vs nota[i+1]
    jbe no_swap_asc ; si ya estan ordenadas, no intercambiar
    ; intercambiar indices
    mov al, byte ptr [indices_ordenados + bx]
    mov dl, byte ptr [indices_ordenados + bx + 1]
    mov byte ptr [indices_ordenados + bx], dl
    mov byte ptr [indices_ordenados + bx + 1], al

no_swap_asc:
    inc si ; siguiente par
    dec ch ; decrementar comparaciones
    jnz bucle_interno_asc
    dec cl ; siguiente pasada
    jnz bucle_externo_asc

fin_burbuja_asc:
    pop dx
    pop ax
    pop di
    pop si
    pop bx
    pop cx
    ret
burbuja_asc endp

; subrutina para ordenar estudiantes de mayor a menor nota usando burbuja
burbuja_desc proc
    push cx
    push bx
    push si
    push di
    push ax
    push dx
    call inicializar_indices ; llenar array de indices
    mov cl, contador_estudiantes ; numero de estudiantes
    dec cl ; n-1 pasadas
    jz fin_burbuja_desc ; si solo hay 1, salir

bucle_externo_desc:
    mov si, 0 ; indice inicial
    mov ch, cl ; comparaciones en esta pasada

bucle_interno_desc:
    mov bx, si
    ; obtener indices a comparar
    mov al, byte ptr [indices_ordenados + bx] ; indice i
    mov dl, byte ptr [indices_ordenados + bx + 1] ; indice i+1
    ; obtener notas de esos estudiantes
    push bx
    push dx
    xor ah, ah
    mov bx, ax
    mov al, byte ptr [notas_int + bx] ; nota del estudiante i
    pop dx
    push ax
    xor dh, dh
    mov bx, dx
    mov dl, byte ptr [notas_int + bx] ; nota del estudiante i+1
    pop ax
    pop bx
    ; comparar notas para orden descendente
    cmp al, dl ; nota[i] vs nota[i+1]
    jae no_swap_desc ; si ya estan ordenadas desc, no intercambiar
    ; intercambiar indices
    mov al, byte ptr [indices_ordenados + bx]
    mov dl, byte ptr [indices_ordenados + bx + 1]
    mov byte ptr [indices_ordenados + bx], dl
    mov byte ptr [indices_ordenados + bx + 1], al

no_swap_desc:
    inc si ; siguiente par
    dec ch ; decrementar comparaciones
    jnz bucle_interno_desc
    dec cl ; siguiente pasada
    jnz bucle_externo_desc

fin_burbuja_desc:
    pop dx
    pop ax
    pop di
    pop si
    pop bx
    pop cx
    ret
burbuja_desc endp

; subrutina para mostrar lista ordenada de nombres completos con sus notas
mostrar_notas_ordenadas proc
    push ax
    push bx
    push cx
    push si
    push dx
    push di
    cmp contador_estudiantes, 0 ; hay estudiantes?
    je fin_mostrar_notas ; no: salir
    xor ch, ch
    mov cl, contador_estudiantes ; numero de estudiantes
    mov si, 0 ; indice actual

bucle_mostrar_notas:
    ; mostrar espacios de alineacion
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
    ; obtener indice del estudiante en posicion ordenada
    mov bx, si
    mov al, [indices_ordenados + bx] ; indice real del estudiante
    ; calcular posicion en array de nombres
    push ax
    push si
    push cx
    xor ah, ah
    mov bx, NOMBRE_COMPLETO ; 60 bytes por nombre
    mul bx ; ax = indice * 60
    lea di, nombres_completos
    add di, ax ; di apunta al nombre del estudiante
    ; mostrar todos los 60 caracteres del nombre
    mov cx, NOMBRE_COMPLETO

mostrar_char_nombre:
    cmp cx, 0 ; terminamos los 60 chars?
    je fin_mostrar_nombre
    mov al, [di] ; cargar caracter
    mov ah, 02h
    mov dl, al
    int 21h ; mostrar caracter
    inc di ; siguiente caracter
    dec cx ; decrementar contador
    jmp mostrar_char_nombre

fin_mostrar_nombre:
    ; espacio separador entre nombre y nota
    mov ah, 02h
    mov dl, ' '
    int 21h
    ; restaurar registros y mostrar nota
    pop cx
    pop si
    pop ax
    xor ah, ah
    mov bx, ax ; indice del estudiante
    mov al, [notas_int + bx] ; cargar nota del estudiante
    call convertir_y_mostrar_nota ; mostrar la nota
    call salto_linea ; nueva linea
    ; siguiente estudiante
    inc si
    dec cl
    jnz bucle_mostrar_notas

fin_mostrar_notas:
    pop di
    pop dx
    pop si
    pop cx
    pop bx
    pop ax
    ret
mostrar_notas_ordenadas endp

end