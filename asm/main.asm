; MAIN.ASM - RegistroCE Programa Principal
; Tarea 1: Paradigmas de Programacion (CE1106)   
; Autores: Steven, Allan y Javier  

.model small
.stack 200h

; === VARIABLES EXTERNAS ===
EXTRN mostrar_titulo:PROC
EXTRN mostrar_menu:PROC
EXTRN salto_linea:PROC
EXTRN mostrar_mensaje_prompt:PROC
EXTRN leer_opcion:PROC
EXTRN opcion_invalida:PROC
EXTRN imprimir_cadena:PROC
EXTRN mostrar_banner:PROC
EXTRN ingresar_calificaciones:PROC
EXTRN notas_int:BYTE
EXTRN contador_estudiantes:BYTE
EXTRN buscar_estudiante_por_indice:PROC
EXTRN signo_prompt:BYTE
EXTRN burbuja_asc:PROC
EXTRN burbuja_desc:PROC
EXTRN mostrar_notas_ordenadas:PROC

.data
    ; === MENSAJES DEL SISTEMA ===
    titulo db "                          ","[ BIENVENIDO A REGISTRO.CE ]$"
    linea db 13,10, "$"

    linea_fina db 196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196
            db 196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196
            db 196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196
            db 196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196
            db "$"

    linea_doble db 205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205
            db 205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205
            db 205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205
            db 205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205
            db "$"

    opciones db "     ", 62,62, "  ", "MENU PRINCIPAL", "  ", 60,60,13,10, "$"
    opcion1 db 13,10, "     ", 254, " [1] Ingresar calificaciones (max. 15)$"
    opcion2 db 13,10, "     ", 254, " [2] Mostrar estadisticas$"
    opcion3 db 13,10, "     ", 254, " [3] Buscar estudiante por posicion$"
    opcion4 db 13,10, "     ", 254, " [4] Ordenar calificaciones (Asc/Dec)$"
    opcion5 db 13,10, "     ", 254, " [5] Salir del programa$"
    opcion db " ",62,62,62, "  ", "Elija una opcion: $"

    ; === BANNER ===
    banner_l1 db "                          ",219,219,219,219,219,219,207,157,157,157,157,157,219,219,219,219,219,219,207,219,219,219,219,219,219,219,207,13,10,"$"
    banner_l2 db "                          ",219,219,201,205,205,219,219,207,157,157,157,157,219,219,201,205,205,205,205,207,219,219,201,205,205,205,205,207,13,10,"$"
    banner_l3 db "                          ",219,219,219,219,219,219,201,157,157,157,157,157,219,219,186,157,157,157,157,157,219,219,219,219,219,219,219,186,13,10,"$"
    banner_l4 db "                          ",219,219,201,205,205,219,219,186,219,219,157,157,219,219,186,157,157,157,157,157,219,219,201,205,205,205,205,186,13,10,"$"
    banner_l5 db "                          ",219,219,186,157,157,219,219,186,200,205,157,157,200,219,219,219,219,219,219,201,219,219,219,219,219,219,219,186,13,10,"$"
        
    ; === MENSAJE DE DESPEDIDA ===
    mensaje_despedida db 13,10, "                      ","[ GRACIAS POR USAR REGISTRO.CE ]", 13,10, "$"
    
    ; === MENSAJES ADICIONALES ===
    msg_ordenar db 13,10,"      ",196,196,196,196,196,196, "[ Ordenar calificaciones: (A)scendente | (D)escendente ]",196,196,196,196,196,196, "$"
    msg_ordenado db "                   ",196,196,196,196,196,196,"[ CALIFICACIONES ORDENADAS ]",196,196,196,196,196,196, "$"
    msg_promedio db 13,10, "     ", 254, "Promedio: ", "$"
    msg_max db 13,10, "     ", 254, "Maximo: ", "$"
    msg_min db 13,10, "     ", 254, "Minimo: ", "$"
    msg_aprobado db 13,10, "     ", 254, "Aprobados Cantidad: ", "$"
    msg_desaprobado db 13,10, "     ", 254, "Desaprobados Cantidad: ", "$"

    msg_no_estudiantes db "                ",196,196,196,196,196,196,"[ NO HAY ESTUDIANTES REGISTRADOS ]",196,196,196,196,196,196, 13, 10, "$"

    ; === VARIABLES DEL SISTEMA ===
    opcion_elegida db ?

    ; === MENSAJES TEMPORALES ===
    mensaje1 db 13,10, " " ,"FUNCIONALIDAD NO IMPLEMENTADA$"

; variables publicas para que subrutinas las usen
PUBLIC titulo, linea, linea_fina, linea_doble, opciones, opcion1, opcion2, opcion3, opcion4, opcion5, opcion
PUBLIC opcion_elegida, banner_l1, banner_l2, banner_l3, banner_l4, banner_l5, mensaje_despedida, mensaje1, convertir_y_mostrar_nota

.code
main proc
    ; carga la seccion de datos en el codigo
    mov ax, @data
    mov ds, ax
    ; imprime linea
    lea dx, linea_doble
    call imprimir_cadena
    ; imprime el banner
    call mostrar_banner
    ; imprime linea
    lea dx, linea_fina
    call imprimir_cadena
    call salto_linea
    ; muestra el titulo
    call mostrar_titulo
    call salto_linea
    call salto_linea
    ; imprime linea
    lea dx, linea_doble
    call imprimir_cadena

; etiqueta del menu principal
menu_principal:
    call salto_linea
    call mostrar_menu
    call salto_linea
    call mostrar_mensaje_prompt
    call leer_opcion

    ; evaluar opcion elegida
    cmp opcion_elegida, '1'
    je ingresar_estudiantes

    cmp opcion_elegida, '2'
    je mostrar_estadisticas

    cmp opcion_elegida, '3'
    je buscar_estudiante

    cmp opcion_elegida, '4'
    je ordenar_calificaciones

    cmp opcion_elegida, '5'
    je salir_programa

    call opcion_invalida
    jmp menu_principal

; etiqueta para ingresar estudiantes
ingresar_estudiantes:
    call ingresar_calificaciones
    jmp menu_principal

; etiqueta para mostrar estadisticas
mostrar_estadisticas:
    ; verificar si hay estudiantes registrados
    cmp contador_estudiantes, 0
    je no_hay_estudiantes

    ; Mostrar estadisticas   
    call promedio
    call imprimir_cadena
    call maximo
    call imprimir_cadena
    call minimo
    call imprimir_cadena
    call aprobados
    call imprimir_cadena
    call desaprobados
    call imprimir_cadena
    call salto_linea
    lea dx, linea_fina
    call imprimir_cadena
    call salto_linea
    call opcion_invalida
    jmp menu_principal

promedio:
    jmp mostrar_promedio
maximo:
    jmp mostrar_maximo
minimo:
    jmp mostrar_min
aprobados:
    jmp mostrar_aprobados
desaprobados:
    jmp mostrar_desaprobados


mostrar_promedio:
    lea dx, msg_promedio
    call imprimir_cadena

mostrar_maximo:
    lea dx, msg_max
    call imprimir_cadena

mostrar_min:
    lea dx, msg_min
    call imprimir_cadena

mostrar_aprobados:
    lea dx, msg_aprobado
    call imprimir_cadena

mostrar_desaprobados:
    lea dx, msg_desaprobado
    call imprimir_cadena


; etiqueta para buscar estudiante
buscar_estudiante:
    call buscar_estudiante_por_indice
    jmp menu_principal


; etiqueta para ordenar calificaciones
ordenar_calificaciones:
    ; verificar si hay estudiantes registrados
    cmp contador_estudiantes, 0
    je no_hay_estudiantes

    ; mostrar mensaje para elegir el tipo de ordenamiento
    lea dx, msg_ordenar
    call imprimir_cadena
    call salto_linea
    call salto_linea

    ; mostrar prompt con formato
    lea dx, signo_prompt
    call imprimir_cadena

    ; leer opcion del usuario (A/D)
    mov ah, 01h
    int 21h
    call salto_linea

    cmp al, 'A'
    je ordenar_asc

    cmp al, 'a'
    je ordenar_asc

    cmp al, 'D'
    je ordenar_desc

    cmp al, 'd'
    je ordenar_desc

    ; si no se elige A/D, volver al menu
    jmp menu_principal

; etiqueta por si no hay estudiantes registrados
no_hay_estudiantes:
    call salto_linea
    lea dx, msg_no_estudiantes
    call imprimir_cadena
    call salto_linea
    lea dx, linea_fina
    call imprimir_cadena
    jmp menu_principal

; === ORDEN ASCENDENTE ===
ordenar_asc:
    call burbuja_asc
    jmp mostrar_resultado

; === ORDEN DESCENDENTE ===
ordenar_desc:
    call burbuja_desc
    jmp mostrar_resultado

; === MOSTRAR RESULTADO DEL ORDENAMIENTO ===
mostrar_resultado:
    lea dx, msg_ordenado
    call imprimir_cadena
    call salto_linea
    call mostrar_notas_ordenadas
    call salto_linea
    lea dx, linea_fina
    call imprimir_cadena
    jmp menu_principal

; etiqueta para salir del programa
salir_programa:
    ; mostrar mensaje de despedida
    lea dx, mensaje_despedida
    call imprimir_cadena
    ; imprime linea
    call salto_linea
    lea dx, linea_doble
    call imprimir_cadena
    call salto_linea
    ; terminar programa
    mov ax, 4c00h
    int 21h

main endp

convertir_y_mostrar_nota proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 0          ; limpiar parte alta
    mov bl, 100        ; divisor para centenas
    
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
    mov bl, 10         ; divisor para decenas
    mov ah, 0          ; limpiar parte alta
    div bl             ; al = cociente (decenas), ah = residuo (unidades)
    
    mov cl, ah         ; guardar unidades en cl
    
    ; verificar si hay decenas
    cmp al, 0
    je solo_unidades
    
    ; mostrar decena
    add al, '0'        ; convertir a ASCII
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

end main
