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
    notas_int db MAX_ESTUDIANTES dup(0)

    ; === VARIABLES DE CONTROL ===
    contador_estudiantes db 0
    
    ; === BUFFERS TEMPORALES ===
    buffer_entrada db 100
                    db ?
                    db 100 dup(0)

    buffer_temp db 100 dup(0)
    indices_ordenados db MAX_ESTUDIANTES dup(0)

    ; === MENSAJES DE LA FUNCION INGRESAR ===
    msg_ingresar_prompt db 196,196,196,196,196,196,196, "[ Ingrese su estudiante o digite 9 para salir al menu principal ]", 196,196,196,196,196,196,196,196, "$"
    ; === MENSJES DE AVISO ===
    msg_estudiante_agregado db "               ",196,196,196,196,196,196,"[ ESTUDIANTE AGREGADO CORRECTAMENTE ]",196,196,196,196,196,196, "$"
    msg_limite_alcanzado db "               ",196,196,196,196,196,196,"[ LIMITE DE 15 ESTUDIANTES ALCANZADO ]",196,196,196,196,196,196, 13, 10, "$"
    msg_formato_incorrecto db "    ",196,196,196,196,196,196,"[ FORMATO INCORRECTO. USE: Nombre Apellido1 Apellido2 Nota ]",196,196,196,196,196,196, 13, 10, "$"
    msg_nota_invalida db "            ",196,196,196,196,196,196,"[ NOTA INVALIDA. Debe estar entre 0 y 100 ]",196,196,196,196,196,196, 13, 10, "$"

    ; Variables para búsqueda
    msg_buscar_prompt db " ",62,62,62," ","Que estudiante desea mostrar (1-15): $"
    msg_estudiante_no_existe db "            ",196,196,196,196,196,196,"[ ESTUDIANTE NO EXISTE ]",196,196,196,196,196,196, 13, 10, "$"
    msg_indice_invalido db "         ",196,196,196,196,196,196,"[ INDICE INVALIDO. Use numeros del 1 al 15 ]",196,196,196,196,196,196, 13, 10, "$"

    buffer_indice db 3
                db ?
                db 3 dup(0)

    indice_usuario db 0

; === VARIABLES PUBLICAS ===
PUBLIC entry_estudiantes, nombres_completos, notas_str, notas_int
PUBLIC contador_estudiantes, buffer_entrada, buffer_temp
PUBLIC msg_ingresar_prompt, msg_estudiante_agregado, msg_limite_alcanzado
PUBLIC msg_formato_incorrecto, msg_nota_invalida
PUBLIC MAX_ESTUDIANTES, ENTRY_COMPLETO, NOMBRE_COMPLETO, NOTA_STR, indices_ordenados

end