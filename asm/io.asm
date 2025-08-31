; IO.ASM - Subrutinas de Entrada/Salida
; RegistroCE

.model small

; === VARIABLES EXTERNAS ===
EXTRN opcion_elegida:BYTE
EXTRN titulo:BYTE
EXTRN linea:BYTE
EXTRN linea_fina:BYTE
EXTRN linea_doble:BYTE
EXTRN opciones:BYTE
EXTRN opcion1:BYTE
EXTRN opcion2:BYTE
EXTRN opcion3:BYTE
EXTRN opcion4:BYTE
EXTRN opcion5:BYTE
EXTRN opcion:BYTE
EXTRN banner_l1:BYTE
EXTRN banner_l2:BYTE
EXTRN banner_l3:BYTE
EXTRN banner_l4:BYTE
EXTRN banner_l5:BYTE

.data
    incorrecta db 13,10," ", "Opcion no valida, presione cualquier tecla para continuar...$"
    continuar db 13,10," ", "Presione cualquier tecla para continuar...$"

.code
PUBLIC imprimir_cadena
PUBLIC salto_linea
PUBLIC leer_opcion
PUBLIC opcion_invalida
PUBLIC mostrar_titulo
PUBLIC mostrar_menu
PUBLIC mostrar_mensaje_prompt
PUBLIC mostrar_banner
PUBLIC presionar_continuar

; === SUBRUTINAS ===

; subrutina para imprimir cualquier cadena
imprimir_cadena proc
    mov ah, 09h
    int 21h
    ret
imprimir_cadena endp

; subrutina para saltar una linea
salto_linea proc
    lea dx, linea
    call imprimir_cadena
    ret
salto_linea endp

; subrutina para leer opcion
leer_opcion proc
    mov ah, 01h
    int 21h
    mov opcion_elegida, al
    call salto_linea
    call salto_linea
    ; imprime linea
    lea dx, linea_fina
    call imprimir_cadena
    ret
leer_opcion endp

; subrutina para volver al menu principal precionando cualquier tecla
opcion_invalida proc
    ; mostrar mensaje
    lea dx, incorrecta
    call imprimir_cadena
    ; esperar cualquier tecla
    mov ah, 08h
    int 21h
    call salto_linea
    call salto_linea
    ; mostrar linea
    lea dx, linea_fina
    call imprimir_cadena
    ret
opcion_invalida endp

; subrutina para volver al menu principal precionando cualquier tecla
presionar_continuar proc
    ; mostrar mensaje
    lea dx, continuar
    call imprimir_cadena
    ; esperar cualquier tecla
    mov ah, 08h
    int 21h
    call salto_linea
    call salto_linea
    ; mostrar linea
    lea dx, linea_fina
    call imprimir_cadena
    ret
presionar_continuar endp

; subrutina para mostrar titulo
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

    call salto_linea
    call salto_linea

    lea dx, linea_fina
    call imprimir_cadena

    ret
mostrar_menu endp

; subrutina para mostrar mensaje para prompt
mostrar_mensaje_prompt proc
    lea dx, opcion
    call imprimir_cadena
    ret
mostrar_mensaje_prompt endp

; subrutina para mostrar el banner del programa
mostrar_banner proc
    call salto_linea
    lea dx, banner_l1
    call imprimir_cadena
    lea dx, banner_l2
    call imprimir_cadena
    lea dx, banner_l3
    call imprimir_cadena
    lea dx, banner_l4
    call imprimir_cadena
    lea dx, banner_l5
    call imprimir_cadena
    call salto_linea
    ret
mostrar_banner endp

end