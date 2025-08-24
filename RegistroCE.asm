; RegistroCE | Code
; Tarea 1: Paradigmas de Programacion (CE1106)   
; Autores: Steven, Allan y Javier  

.model small
.stack 200h  

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
    incorrecta db 13,10, "Opcion no valida, presione cualquier tecla para continuar...$"
    
    ; === VARIABLES DEL SISTEMA ===
    opcion_elegida db ?

.code
main proc
    ; carga el segmento de datos 
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
        
        ; opcion invalida: volver al menu
        call salto_linea
        call opcion_invalida
    
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

; ===== SUBRUTINAS =====

; subrutina para mostrar el titulo
mostrar_titulo proc
    lea dx, titulo
    call imprimir_cadena
    ret
mostrar_titulo endp

; subrutina para mostrar el menu
mostrar_menu proc
    lea dx, opciones
    call imprimir_cadena
    
    lea dx, opcion1
    call imprimir_cadena
    
    lea dx, opcion2
    call imprimir_cadena
    
    lea dx, opcion3
    call imprimir_cadena
    
    lea dx, opcion4
    call imprimir_cadena
    
    lea dx, opcion5
    call imprimir_cadena
    
    ret
mostrar_menu endp

; subrutina para saltar una linea
salto_linea proc
    lea dx, linea
    call imprimir_cadena
    ret
salto_linea endp

; subrutina para mostrar mensaje para prompt
mostrar_mensaje_prompt proc
    lea dx, opcion
    call imprimir_cadena
    ret
mostrar_mensaje_prompt endp
 
; subrutina para leer opcion
leer_opcion proc
    mov ah, 01h
    int 21h
    mov opcion_elegida, al
    ret
leer_opcion endp

; subrutina para imprimir cualquier cadena
imprimir_cadena proc
    mov ah, 09h
    int 21h
    ret
imprimir_cadena endp

; subrutina para volver al menu principal precionando cualquier tecla
opcion_invalida proc
    ; mostrar mensaje
    lea dx, incorrecta
    call imprimir_cadena    
    ; esperar cualquier tecla
    mov ah, 08h
    int 21h
    ; regresar al menu principal
    ret
opcion_invalida endp

end main