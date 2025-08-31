; DATA.ASM - Estructura de datos para RegistroCE
; RegistroCE

.model small

.data
    ; === CONSTANTES ===
    MAX_ESTUDIANTES equ 15
    ENTRY_COMPLETO equ 100      
    NOMBRE_COMPLETO equ 60    
    NOTA_STR equ 10

    ; === ARRAYS PRINCIPALES ===
    entry_estudiantes db MAX_ESTUDIANTES * ENTRY_COMPLETO dup(0)
    nombres_completos db MAX_ESTUDIANTES * NOMBRE_COMPLETO dup(0)
    notas_str db MAX_ESTUDIANTES * NOTA_STR dup(0)
    notas_int dw MAX_ESTUDIANTES dup(0)

    ; === VARIABLES DE CONTROL ===
    contador_estudiantes db 0
    
    ; === BUFFERS TEMPORALES ===
    buffer_entrada db 100
                    db ?
                    db 100 dup(0)

    buffer_temp db 100 dup(0)

    ; === MENSAJES DE LA FUNCION INGRESAR ===
    msg_ingresar_prompt db "Ingrese su estudiante o digite 9 para salir al menu principal", 13, 10, "$"
    msg_estudiante_agregado db "Estudiante agregado correctamente.", 13, 10, "$"
    msg_limite_alcanzado db "Limite de 15 estudiantes alcanzado.", 13, 10, "$"
    msg_formato_incorrecto db "Formato incorrecto. Use: Nombre Apellido1 Apellido2 Nota", 13, 10, "$"
    msg_nota_invalida db "Nota invalida. Debe estar entre 0 y 100.", 13, 10, "$"

; === VARIABLES PUBLICAS ===
PUBLIC entry_estudiantes, nombres_completos, notas_str, notas_int
PUBLIC contador_estudiantes, buffer_entrada, buffer_temp
PUBLIC msg_ingresar_prompt, msg_estudiante_agregado, msg_limite_alcanzado
PUBLIC msg_formato_incorrecto, msg_nota_invalida
PUBLIC MAX_ESTUDIANTES, ENTRY_COMPLETO, NOMBRE_COMPLETO, NOTA_STR

end