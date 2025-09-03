; FIND.ASM - Subrutinas para buscar estudiantes
; RegistroCE

.model small

; === VARIABLES EXTERNAS ===
EXTRN MAX_ESTUDIANTES:ABS
EXTRN NOMBRE_COMPLETO:ABS
EXTRN NOTA_STR:ABS

EXTRN nombres_completos:BYTE
EXTRN notas_str:BYTE
EXTRN contador_estudiantes:BYTE
EXTRN linea_fina:BYTE

EXTRN signo_prompt:BYTE

; === SUBRUTINAS EXTERNAS ===
EXTRN imprimir_cadena:PROC
EXTRN salto_linea:PROC
EXTRN presionar_continuar:PROC

.data
    msg_buscar_prompt db 196, 196, 196, 196, 196,196,196,196,196,196,196, 196, 196, 196, 196,196,196,196,196, "[ Ingrese su estudiante a buscar (1-15) ]",196, 196, 196, 196, 196,196,196,196,196,196,196, 196, 196, 196, 196,196,196,196,196,196, "$"
    msg_estudiante_no_existe db "                      ",196,196,196,196,196,196,"[ ESTUDIANTE NO EXISTE ]",196,196,196,196,196,196, 13, 10, "$"
    msg_indice_invalido db "            ",196,196,196,196,196,196,"[ INDICE INVALIDO. Use numeros del 1 al 15 ]",196,196,196,196,196,196, 13, 10, "$"
    
    ; buffer para leer el índice
    buffer_indice db 3
                  db ?
                  db 3 dup(0)
    
    ; índice convertido (1-15)
    indice_usuario db 0  

.code
PUBLIC buscar_estudiante_por_indice

; subrutina para buscar estudiante
buscar_estudiante_por_indice proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ; mostrar prompt
    call salto_linea
    lea dx, msg_buscar_prompt
    call imprimir_cadena
    call salto_linea

    ; mostrar prompt con formato
    lea dx, signo_prompt
    call imprimir_cadena

    ; leer índice del usuario
    mov ah, 0Ah
    lea dx, buffer_indice
    int 21h
    call salto_linea

    ; convertir string a número
    call convertir_indice
    cmp al, 0FFh  ; verificar si hubo error
    je fin_busqueda

    ; verificar si el estudiante existe
    mov al, indice_usuario
    cmp al, contador_estudiantes
    jae estudiante_no_existe

    ; mostrar el estudiante encontrado
    call mostrar_estudiante_encontrado
    jmp fin_busqueda_ok

estudiante_no_existe:
    call salto_linea
    lea dx, msg_estudiante_no_existe
    call imprimir_cadena
    jmp fin_busqueda_ok

fin_busqueda_ok:
    

fin_busqueda:
    call salto_linea
    lea dx, linea_fina
    call imprimir_cadena
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
buscar_estudiante_por_indice endp

; convertir string indice a entero
convertir_indice proc
    push si
    push bx
    push cx

    ; verificar que se haya ingresado algo
    mov al, [buffer_indice + 1]  ; longitud ingresada
    cmp al, 0
    je indice_vacio

    ; apuntar al primer carácter
    lea si, buffer_indice + 2
    mov cl, [buffer_indice + 1]  ; longitud
    mov bx, 0  ; acumulador

    ; verificar que solo sean dígitos y convertir
convertir_digito_indice:
    cmp cl, 0
    je validar_indice_rango
    
    mov al, [si]
    
    ; verificar que sea dígito (0-9)
    cmp al, '0'
    jb indice_no_numerico
    cmp al, '9'
    ja indice_no_numerico
    
    ; convertir a número
    sub al, '0'
    mov ah, 0
    
    ; multiplicar acumulador por 10 y sumar
    push ax
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    pop ax
    add bx, ax
    
    ; verificar que no sea muy grande
    cmp bx, 99
    ja indice_muy_grande
    
    inc si
    dec cl
    jmp convertir_digito_indice

validar_indice_rango:
    ; verificar rango 1-15
    cmp bx, 1
    jb indice_fuera_rango
    cmp bx, 15
    ja indice_fuera_rango
    
    ; guardar índice (convertir a base 0)
    dec bx
    mov indice_usuario, bl
    mov al, 0  ; éxito
    jmp fin_conversion_indice

indice_vacio:
indice_no_numerico:
indice_muy_grande:
indice_fuera_rango:
    call salto_linea
    lea dx, msg_indice_invalido
    call imprimir_cadena
    mov al, 0FFh  ; error

fin_conversion_indice:
    pop cx
    pop bx
    pop si
    ret
convertir_indice endp

; subrutina para mostrar el estudiante encontrado
mostrar_estudiante_encontrado proc
    push ax
    push bx
    push si
    push di
    push cx

    call salto_linea
    
    ; === MOSTRAR NOMBRE COMPLETO ===
    
    ; calcular posición en array nombres_completos
    mov al, indice_usuario
    xor ah, ah
    mov bx, NOMBRE_COMPLETO ; 60 bytes por entrada
    mul bx
    
    lea si, nombres_completos
    add si, ax ; si apunta al nombre del estudiante
    
    ; mostrar nombre carácter por carácter (hasta encontrar espacios finales)
    mov cx, NOMBRE_COMPLETO
mostrar_nombre_loop:
    cmp cx, 0
    je nombre_mostrado
    
    mov al, [si]
    
    ; si encontramos espacios consecutivos al final, parar
    cmp al, ' '
    je verificar_fin_nombre
    
    ; mostrar carácter
    mov ah, 02h
    mov dl, al
    int 21h
    
    inc si
    dec cx
    jmp mostrar_nombre_loop

verificar_fin_nombre:
    ; verificar si todos los caracteres restantes son espacios
    push si
    push cx
    
revisar_espacios:
    cmp cx, 0
    je son_espacios_finales  ; si llegamos al final, son espacios finales
    
    mov al, [si]
    cmp al, ' '
    jne no_son_espacios_finales  ; si encontramos algo que no es espacio
    
    inc si
    dec cx
    jmp revisar_espacios

son_espacios_finales:
    pop cx
    pop si
    jmp nombre_mostrado  ; terminar de mostrar nombre

no_son_espacios_finales:
    pop cx
    pop si
    
    ; mostrar el espacio y continuar
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    inc si
    dec cx
    jmp mostrar_nombre_loop

nombre_mostrado:
    ; mostrar un espacio entre nombre y nota
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    ; === MOSTRAR NOTA ===
    
    ; calcular posición en array notas_str
    mov al, indice_usuario
    xor ah, ah
    mov bx, NOTA_STR ; 10 bytes por entrada
    mul bx
    
    lea si, notas_str
    add si, ax ; si apunta a la nota del estudiante
    
    ; mostrar nota carácter por carácter (hasta encontrar espacios finales)
    mov cx, NOTA_STR
mostrar_nota_loop:
    cmp cx, 0
    je nota_mostrada
    
    mov al, [si]
    
    ; si encontramos espacios consecutivos al final, parar
    cmp al, ' '
    je verificar_fin_nota
    
    ; mostrar carácter
    mov ah, 02h
    mov dl, al
    int 21h
    
    inc si
    dec cx
    jmp mostrar_nota_loop

verificar_fin_nota:
    ; similar al nombre, verificar si son espacios finales
    push si
    push cx
    
revisar_espacios_nota:
    cmp cx, 0
    je son_espacios_finales_nota
    
    mov al, [si]
    cmp al, ' '
    jne no_son_espacios_finales_nota
    
    inc si
    dec cx
    jmp revisar_espacios_nota

son_espacios_finales_nota:
    pop cx
    pop si
    jmp nota_mostrada

no_son_espacios_finales_nota:
    pop cx
    pop si
    
    ; mostrar el espacio y continuar
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    inc si
    dec cx
    jmp mostrar_nota_loop

nota_mostrada:
    call salto_linea

    pop cx
    pop di
    pop si
    pop bx
    pop ax
    ret
mostrar_estudiante_encontrado endp

end