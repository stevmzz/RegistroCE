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

.data
    ; === MENSAJES DEL SISTEMA ===
    titulo db "===== Bienvenido a RegistroCE =====$"
    linea db 13,10, "$"
    opciones db 13,10, "Opciones: $"
    opcion1 db 13,10, "1. Ingresar calificaciones$"
    opcion2 db 13,10, "2. Mostrar estadisticas$"
    opcion3 db 13,10, "3. Buscar estudiante por posicion$"
    opcion4 db 13,10, "4. Ordenar calificaciones$"
    opcion5 db 13,10, "5. Salir del programa$"
    opcion db 13,10, "Elija una opcion: $"
    
    ; === VARIABLES DEL SISTEMA ===
    opcion_elegida db ?

; variables publicas para que subrutinas las usen
PUBLIC titulo, linea, opciones, opcion1, opcion2, opcion3, opcion4, opcion5, opcion
PUBLIC opcion_elegida

.code
main proc
    mov ax, @data
    mov ds, ax

    call mostrar_titulo

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

    call salto_linea
    call opcion_invalida
    jmp menu_principal

; etiqueta para ingresar estudiantes: FALTA IMPLEMENTAR
ingresar_estudiantes:
    jmp menu_principal

; etiqueta para mostrar estadisticas: FALTA IMPLEMENTAR
mostrar_estadisticas:
    jmp menu_principal

; etiqueta para buscar estudiante: FALTA IMPLEMENTAR
buscar_estudiante:
    jmp menu_principal

; etiqueta para ordenar calificaciones: FALTA IMPLEMENTAR
ordenar_calificaciones:
    jmp menu_principal

; etiqueta para salir del programa
salir_programa:
    mov ax, 4c00h
    int 21h

main endp
end main