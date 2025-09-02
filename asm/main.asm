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
    opcion4 db 13,10, "     ", 254, " [4] Ordenar calificaciones$"
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
    msg_ordenar db 13,10, "Ordenar calificaciones en (A)scendente o (D)escendente? $"
    msg_ordenado db 13,10, "Las calificaciones han sido ordenadas.$"

    ; === VARIABLES DEL SISTEMA ===
    opcion_elegida db ?

    ; === MENSAJES TEMPORALES ===
    mensaje1 db 13,10, "FUNCIONALIDAD NO IMPLEMENTADA$"

; variables publicas para que subrutinas las usen
PUBLIC titulo, linea, linea_fina, linea_doble, opciones, opcion1, opcion2, opcion3, opcion4, opcion5, opcion
PUBLIC opcion_elegida, banner_l1, banner_l2, banner_l3, banner_l4, banner_l5, mensaje_despedida, mensaje1

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
    lea dx, mensaje1
    call imprimir_cadena
    call opcion_invalida
    jmp menu_principal

; etiqueta para buscar estudiante
buscar_estudiante:
    lea dx, mensaje1
    call imprimir_cadena
    call opcion_invalida
    jmp menu_principal

; etiqueta para ordenar calificaciones
ordenar_calificaciones:
    ; mostrar mensaje para elegir el tipo de ordenamiento
    lea dx, msg_ordenar
    call imprimir_cadena

    ; leer opcion del usuario (A/D)
    mov ah, 01h
    int 21h

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

; =========================================================
; SUBRUTINAS DE ORDENAMIENTO - ALGORITMO BURBUJA
; =========================================================

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

end main
