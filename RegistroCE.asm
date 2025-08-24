; RegistroCE | Code
; Tarea 1: Paradigmas de Programacion (CE1106)   
; Autores: Steven, Allan y Javier  

.model small
.stack 200h  

.data
    ; === MENSAJES DEL SISTEMA ===
    titulo db "===== RegistroCE =====$"
    linea db 13,10, "$"
    opciones db 13,10, "Opciones: $"
    opcion1 db 13,10, "1. Ingresar calificaciones$"
    opcion2 db 13,10, "2. Mostrar estadisticas$"
    opcion3 db 13,10, "3. Buscar estudiante por posicion$"
    opcion4 db 13,10, "4. Ordenar calificaciones$"
    opcion5 db 13,10, "5. Salir del programa$"

.code
main proc
    ; carga el segmento de datos 
    mov ax, @data
    mov ds, ax
     
    call mostrar_titulo
    call salto_linea
    call mostrar_menu
    call salto_linea
    
    ; finalizar el programa
    mov ah, 4ch
    int 21h
    
main endp

; ===== SUBRUTINAS =====

; subrutina para mostrar el titulo
mostrar_titulo proc
    lea dx, titulo
    mov ah, 09h
    int 21h
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
    mov ah, 09h
    int 21h
    ret
salto_linea endp

; subrutina para imprimir cualquier cadena
imprimir_cadena proc
    mov ah, 09h
    int 21h
    ret
imprimir_cadena endp

end main