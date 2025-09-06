; STATS.ASM - Subrutinas para estadísticas
; RegistroCE

.model small

; === VARIABLES EXTERNAS ===
EXTRN notas_int:BYTE
EXTRN contador_estudiantes:BYTE
EXTRN imprimir_cadena:PROC
EXTRN salto_linea:PROC

.data
    ; === VARIABLES PARA ESTADÍSTICAS ===
    suma_notas dw 0
    promedio_final db 0
    nota_maxima db 0
    nota_minima db 100
    aprobados_count db 0
    reprobados_count db 0
    porcentaje_aprobados db 0
    porcentaje_reprobados db 0

    ; === MENSAJES PARA ESTADÍSTICAS ===
    mensaje_promedio db 13,10, "     ", 254, " Promedio: $"
    mensaje_maximo db 13,10, "     ", 254, " Maximo: $"
    mensaje_minimo db 13,10, "     ", 254, " Minimo: $"
    mensaje_aprobados db 13,10, "     ", 254, " Aprobados Cantidad: $"
    mensaje_aprobados_porc db " Porcentaje: $"
    mensaje_reprobados db 13,10, "     ", 254, " Reprobados Cantidad: $"
    mensaje_reprobados_porc db " Porcentaje: $"
    mensaje_porcentaje db "%$"

.code
PUBLIC calcular_estadisticas, mostrar_todas_estadisticas, convertir_y_mostrar_nota

; === SUBRUTINAS PARA ESTADÍSTICAS ===

calcular_estadisticas proc
    push ax
    push bx
    push cx
    push si
    ; inicializar variables
    mov suma_notas, 0
    mov nota_maxima, 0
    mov nota_minima, 100
    mov aprobados_count, 0
    mov reprobados_count, 0
    mov si, 0
    xor ch, ch
    mov cl, contador_estudiantes
    
; recorrer todas las notas
estadisticas_loop:
    cmp cl, 0
    je calcular_finales
    
    mov al, [notas_int + si]
    ; sumar para promedio
    xor ah, ah
    add suma_notas, ax
    ; verificar máximo
    cmp al, nota_maxima
    jbe no_es_maximo
    mov nota_maxima, al

no_es_maximo:
    ; verificar mínimo
    cmp al, nota_minima
    jae no_es_minimo
    mov nota_minima, al

no_es_minimo:
    ; verificar aprobado/reprobado (>=70 aprobado)
    cmp al, 70
    jb es_reprobado
    inc aprobados_count
    jmp continuar_loop
es_reprobado:
    inc reprobados_count
    
continuar_loop:
    inc si
    dec cl
    jmp estadisticas_loop
    
calcular_finales:
    ; calcular promedio = suma ÷ cantidad
    mov ax, suma_notas
    mov bl, contador_estudiantes
    div bl
    mov promedio_final, al
    ; calcular porcentaje aprobados = (aprobados * 100) ÷ total
    mov al, aprobados_count
    mov bl, 100
    mul bl
    mov bl, contador_estudiantes
    div bl
    mov porcentaje_aprobados, al 
    ; calcular porcentaje reprobados = (reprobados * 100) ÷ total
    mov al, reprobados_count
    mov bl, 100
    mul bl
    mov bl, contador_estudiantes
    div bl
    mov porcentaje_reprobados, al
    
    pop si
    pop cx
    pop bx
    pop ax

    ret
calcular_estadisticas endp

mostrar_todas_estadisticas proc
    push ax
    push dx
    ; mostrar promedio
    lea dx, mensaje_promedio
    call imprimir_cadena
    mov al, promedio_final
    call convertir_y_mostrar_nota
    ; mostrar máximo
    lea dx, mensaje_maximo
    call imprimir_cadena
    mov al, nota_maxima
    call convertir_y_mostrar_nota
    ; mostrar mínimo
    lea dx, mensaje_minimo
    call imprimir_cadena
    mov al, nota_minima
    call convertir_y_mostrar_nota
    ; mostrar aprobados
    lea dx, mensaje_aprobados
    call imprimir_cadena
    mov al, aprobados_count
    call convertir_y_mostrar_nota
    lea dx, mensaje_aprobados_porc
    call imprimir_cadena
    mov al, porcentaje_aprobados
    call convertir_y_mostrar_nota
    lea dx, mensaje_porcentaje
    call imprimir_cadena
    ; mostrar reprobados
    lea dx, mensaje_reprobados
    call imprimir_cadena
    mov al, reprobados_count
    call convertir_y_mostrar_nota
    lea dx, mensaje_reprobados_porc
    call imprimir_cadena
    mov al, porcentaje_reprobados
    call convertir_y_mostrar_nota
    lea dx, mensaje_porcentaje
    call imprimir_cadena
    
    pop dx
    pop ax

    ret
mostrar_todas_estadisticas endp

convertir_y_mostrar_nota proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 0 ; limpiar parte alta
    mov bl, 100 ; divisor para centenas
    ; verificar si es >= 100
    cmp al, 100
    jb menor_que_100
    ; mostrar "100"
    mov ah, 02h
    mov dl, '1'
    int 21h
    mov dl, '0'
    int 21h
    mov dl, '0'
    int 21h
    jmp fin_conversion

menor_que_100:
    mov bl, 10 ; divisor para decenas
    mov ah, 0 ; limpiar parte alta
    div bl ; al = cociente (decenas), ah = residuo (unidades)
    mov cl, ah ; guardar unidades en cl
    ; verificar si hay decenas
    cmp al, 0
    je solo_unidades
    ; mostrar decena
    add al, '0' ; convertir a ASCII
    mov ah, 02h
    mov dl, al
    int 21h
    ; mostrar unidad
    mov al, cl
    add al, '0'
    mov dl, al
    int 21h
    jmp fin_conversion

solo_unidades:
    ; mostrar solo la unidad
    mov al, cl
    add al, '0'
    mov ah, 02h
    mov dl, al
    int 21h

fin_conversion:
    pop dx
    pop cx
    pop bx
    pop ax

    ret
convertir_y_mostrar_nota endp

end