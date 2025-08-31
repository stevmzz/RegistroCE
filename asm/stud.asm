; STUD.ASM - Subrutinas para manejo de estudiantes
; RegistroCE

.model small
.stack 100h

; === VARIABLES EXTERNAS ===
EXTRN MAX_ESTUDIANTES:ABS
EXTRN ENTRY_COMPLETO:ABS
EXTRN NOMBRE_COMPLETO:ABS
EXTRN NOTA_STR:ABS

EXTRN entry_estudiantes:BYTE
EXTRN nombres_completos:BYTE
EXTRN notas_str:BYTE
EXTRN notas_int:WORD

EXTRN buffer_entrada:BYTE
EXTRN buffer_temp:BYTE

EXTRN contador_estudiantes:BYTE

EXTRN msg_ingresar_prompt:BYTE
EXTRN msg_estudiante_agregado:BYTE
EXTRN msg_limite_alcanzado:BYTE
EXTRN msg_formato_incorrecto:BYTE
EXTRN msg_nota_invalida:BYTE

EXTRN linea_fina:BYTE
EXTRN linea_doble:BYTE

; === SUBRUTINAS EXTERNAS ===
EXTRN imprimir_cadena:PROC
EXTRN salto_linea:PROC
EXTRN opcion_invalida:PROC
EXTRN presionar_continuar:PROC

.data
    exito db 13,10, "Registrado exitosamente$"
    signo_prompt db 62,62,62," ","$"

.code
PUBLIC ingresar_calificaciones

; subrutina para ingresar calificaciones
ingresar_calificaciones proc

; etiqueta de inicio del bucle
bucle_ingreso:
    mov al, contador_estudiantes ; cargar contador de estudiantes
    cmp al, MAX_ESTUDIANTES ; compara lo que esta en el al con el maximo de estudiantes
    jae limite_alcanzado ; saltar si es igual o mayor al limite

    ; mostrar mensaje de ingreso
    call salto_linea
    lea dx, msg_ingresar_prompt
    call imprimir_cadena
    call salto_linea

    ; leer linea de entrada
    mov ah, 0Ah
    lea dx, buffer_entrada
    int 21h
    call salto_linea

    ; revisar si se presiono 9 para salir
    mov al, [buffer_entrada + 2]
    cmp al, '9'
    je salir

    ; separar el entry del usuario
    call separar_nombre_nota

    ; incrementar contador
    inc byte ptr [contador_estudiantes]

    ; mostrar mensaje de exito de guardado
    lea dx, exito
    call imprimir_cadena
    call presionar_continuar

    ; repetir hasta alcanzar el limite
    jmp bucle_ingreso

; etiqueta de salida
salir:
    lea dx, linea_fina
    call imprimir_cadena
    call presionar_continuar
    ret

; etiqueta de limite alcanzado
limite_alcanzado:
    call salto_linea
    lea dx, msg_limite_alcanzado
    call imprimir_cadena
    call presionar_continuar
    ret
    
ingresar_calificaciones endp

; subrutina para separar el entry
separar_nombre_nota proc
    ; guardar registros en la pila
    push si
    push di
    push cx
    push bx
    push ax

; === VALIDAR FORMATO ===

    lea si, buffer_entrada+2 ; apunta al primer caracter de la cadena ingresada
    mov cl, [buffer_entrada+1] ; longitud de la cadena
    mov ch, 0 ; contador de caracteres
    mov bl, 0 ; inicializa contador auxiliar

; valida que se ingrese una oración con 3 espacion
validar_espacios:
    ; si no se ingreso nada
    cmp cl, 0
    je fin_validacion

    ; verifica si el caracter es un espacio
    mov al, [si]
    cmp al, ' '
    jne siguiente
    inc bl ; si hay un espacio suma 1 (verificar si son 3)

; pasar al siguiente caracter de la cadena   
siguiente:
    inc si ; incrementa al siguiente caracter de la cadena
    dec cl ; decrementa la longitud de la cadena
    jmp validar_espacios

; fin de la validacion de caracteres
fin_validacion:
    cmp bl, 3
    je formato_ok
    lea dx, msg_formato_incorrecto
    call imprimir_cadena
    call presionar_continuar
    jmp fin_sep

; === EXTRER NOMBRE Y NOTA ===

; si el formato es correcto
formato_ok:
    lea si, buffer_entrada+2 ; cadena original
    mov cl, [buffer_entrada+1] ; longitud total
    mov ch, 0
    lea di, buffer_temp ; destino para el nombre
    mov bl, 0 ; contador de espacios

; copiar caracteres hasta encontrar el 3er espacio
extraer_nombre:
    cmp cl, 0 ; verificar si se llegó al final
    je fin_extraccion
    mov al, [si] ; cargar caracter actual

    ; verificar si es un espacio, sino copiar nombre
    cmp al, ' '
    jne copiar_caracter_nombre
    ; si es espacio incrementar contador
    inc bl
    cmp bl, 3
    je iniciar_nota ; si hay 3 espacios empezar a extraer la nota

; copiar caracter del nombre
copiar_caracter_nombre:
    mov [di], al ; copiar caracteres
    inc di ; avanzar

continuar_nombre:
    inc si
    dec cl
    jmp extraer_nombre

; === EXTRAER NOTA ===

; iniciar a extraer la nota
iniciar_nota:
    ; saltar el 3er espacio
    inc si
    dec cl
    ; poner terminador null en el nombre
    mov byte ptr [di], 0
    ; preparar para extraer nota
    lea di, buffer_temp + 61 ; usar la parte del buffer para la nota

; extraer la nota
extraer_nota:
    cmp cl, 0 ; verificar si se llegó al final
    je fin_extraccion
    mov al, [si] ; cargar caracter actual
    mov [di], al ; copiarlo
    inc si ; avanzar cadena
    inc di
    dec cl ; decrementar contador
    jmp extraer_nota ; seguir copiando

; finalizar extraccion
fin_extraccion:
    ; poner terminador null en la nota
    mov byte ptr [di], 0
    ; almacenar estudiante en arrays
    call almacenar_estudiante

; fin de la separacion
fin_sep:
    pop ax
    pop bx
    pop cx
    pop di
    pop si

    ret
separar_nombre_nota endp

; subrutina para almacenar estudiante en array
almacenar_estudiante proc
    push si
    push di
    push ax
    push bx
    push cx

    ; === 1. ALMACENAR NOMBRE COMPLETO ===

    ; calcular posicion en array nombres_completos
    ; formula: posicion = contador_estudiantes * NOMBRE_COMPLETO
    mov al, contador_estudiantes ; indice actual
    xor ah, ah ; limpiar la parte alta
    mov bx, NOMBRE_COMPLETO ; tamaño de entrada de 60
    mul bx ; ax = indice * 60

    ; copiar nombre desde buffer_temp a nombres_completos
    lea si, buffer_temp
    lea di, nombres_completos
    add di, ax
    ; copiar 60 char hasta encontrar null
    mov cx, NOMBRE_COMPLETO
    
; loop para copiar el nombre completo
copiar_nombre_loop:
    cmp cx, 0 ; verificar si llegó al limite
    je nombre_copiado ; si: nombre copiado
    
    mov al, [si] ; cargar caracter en al
    cmp al, 0 ; verificar si terminamos null
    je llenar_espacios_nombre ; si: llenar con espacios
    
    ; copiar char y avanzar
    mov [di], al
    inc si                         
    inc di                          
    dec cx

    jmp copiar_nombre_loop

; llenar nombre con espacios: "nombre apellido apellido                  "
llenar_espacios_nombre:
    mov al, ' '
rellenar_nombre:
    cmp cx, 0 ; verificar si termina
    je nombre_copiado
    mov [di], al ; poner espacio
    ; avanzar
    inc di
    dec cx
    jmp rellenar_nombre

; al finalizar de copiar nombre
nombre_copiado:

    ; === 2. ALMACENAR NOTA COMO STRING ===

    ; calcular posicion en array notas_str
    ; formula: posicion = contador_estudiantes * NOTA_STR
    mov al, contador_estudiantes
    xor ah, ah
    mov bx, NOTA_STR
    mul bx

    ; copiar nota string desde buffer_temp+61 a notas_str
    lea si, buffer_temp + 61
    lea di, notas_str
    add di, ax

    ; copiar hasta 10 caracteres o hasta encontrar null
    mov cx, NOTA_STR

; bucle para copiar toda la nota
copiar_nota_str_loop:
    cmp cx, 0 ; verificar si termina
    je nota_str_copiada
    
    mov al, [si]              
    cmp al, 0                    
    je llenar_espacios_nota       
    cmp al, 13                   
    je llenar_espacios_nota
    cmp al, 10                   
    je llenar_espacios_nota
    
    ; copiar y avanzar
    mov [di], al                   
    inc si                         
    inc di                          
    dec cx                       
    jmp copiar_nota_str_loop

; rellenar con espacios
llenar_espacios_nota:
    mov al, ' '
rellenar_nota:
    cmp cx, 0
    je nota_str_copiada
    mov [di], al               
    inc di                         
    dec cx                         
    jmp rellenar_nota

; al finalizar de copiar la nota
nota_str_copiada:
    pop cx
    pop bx
    pop ax
    pop di
    pop si

    ret
almacenar_estudiante endp

end
