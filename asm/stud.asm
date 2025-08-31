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
    signo_prompt db " ",62,62,62," ","$"
    nota_temporal db 10 dup(0)     ; buffer temporal para la nota

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

    ; mostrar prompt con formato
    lea dx, signo_prompt
    call imprimir_cadena

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

    ; verificar si el formato fue correcto
    cmp al, 0FFh ; codigo de error
    je bucle_ingreso ; si hay error, repetir

    ; incrementar contador solo si todo fue exitoso
    inc byte ptr [contador_estudiantes]

    ; mostrar mensaje de estudiante agregado correctamente
    call salto_linea
    lea dx, msg_estudiante_agregado
    call imprimir_cadena
    call salto_linea

    ; repetir hasta alcanzar el limite
    jmp bucle_ingreso

; etiqueta de salida
salir:
    call salto_linea
    lea dx, linea_fina
    call imprimir_cadena
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
    push dx

    ; inicializar codigo de retorno como exito
    mov al, 0

; === VALIDAR FORMATO ===

    lea si, buffer_entrada+2 ; apunta al primer caracter de la cadena ingresada
    mov cl, [buffer_entrada+1] ; longitud de la cadena
    mov ch, 0 ; contador de caracteres
    mov bl, 0 ; inicializa contador auxiliar

; valida que se ingrese una oración con 3 espacios
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
    call salto_linea
    lea dx, msg_formato_incorrecto
    call imprimir_cadena
    mov al, 0FFh ; codigo de error
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

; === EXTRAER Y VALIDAR NOTA ===

; iniciar a extraer la nota
iniciar_nota:
    ; saltar el 3er espacio
    inc si
    dec cl
    ; poner terminador null en el nombre
    mov byte ptr [di], 0
    
    ; preparar para extraer y validar nota
    lea di, nota_temporal ; usar buffer temporal para la nota
    mov bx, 0 ; limpiar contador

; extraer la nota a buffer temporal
extraer_nota:
    cmp cl, 0 ; verificar si se llegó al final
    je validar_nota_extraida
    mov al, [si] ; cargar caracter actual
    
    ; verificar que solo sean digitos (0-9)
    cmp al, '0'
    jb caracter_invalido
    cmp al, '9'
    ja caracter_invalido
    
    ; caracter valido, copiarlo
    mov [di], al ; copiarlo
    inc si ; avanzar cadena
    inc di
    inc bx ; incrementar contador de caracteres en nota
    dec cl ; decrementar contador
    jmp extraer_nota ; seguir copiando

; caracter no valido en la nota
caracter_invalido:
    call salto_linea
    lea dx, msg_nota_invalida
    call imprimir_cadena
    mov al, 0FFh ; codigo de error
    jmp fin_sep

; validar la nota extraida
validar_nota_extraida:
    ; poner terminador null en la nota
    mov byte ptr [di], 0
    
    ; verificar que la nota no este vacia
    cmp bx, 0
    je nota_vacia
    
    ; convertir string de nota a numero y validar rango
    call convertir_y_validar_nota
    cmp al, 0FFh ; verificar codigo de error
    je fin_sep ; si hay error, salir
    
    ; si llegamos aqui, todo es valido, almacenar estudiante
    call almacenar_estudiante
    mov al, 0 ; codigo de exito
    jmp fin_sep

; nota vacia
nota_vacia:
    lea dx, msg_nota_invalida
    call imprimir_cadena
    call presionar_continuar
    mov al, 0FFh ; codigo de error
    jmp fin_sep

; finalizar extraccion (no deberia llegar aqui normalmente)
fin_extraccion:
    lea dx, msg_formato_incorrecto
    call imprimir_cadena
    call presionar_continuar
    mov al, 0FFh ; codigo de error

; fin de la separacion
fin_sep:
    pop dx
    pop bx
    pop cx
    pop di
    pop si
    ret
separar_nombre_nota endp

; subrutina para convertir a string y validar rango
convertir_y_validar_nota proc
    push si
    push bx
    push cx
    push dx

    lea si, nota_temporal ; apuntar al inicio de la nota
    mov bx, 0 ; acumulador para el numero
    
; convertir cada digito
convertir_digito:
    mov al, [si] ; cargar caracter actual
    cmp al, 0 ; verificar fin de cadena
    je validar_rango
    
    ; convertir caracter a numero
    sub al, '0'
    mov ah, 0 ; limpiar parte alta
    
    ; verificar overflow antes de multiplicar
    cmp bx, 999 ; si ya es muy grande, error
    ja numero_muy_grande
    
    ; multiplicar acumulador por 10
    push ax
    mov ax, bx
    mov cx, 10
    mul cx
    mov bx, ax
    pop ax
    
    ; sumar nuevo digito
    add bx, ax
    
    ; verificar que no exceda 32767 (limite de word)
    cmp bx, 32767
    ja numero_muy_grande
    
    inc si ; avanzar al siguiente caracter
    jmp convertir_digito

; validar que el numero este en rango 0-100
validar_rango:
    ; verificar rango 0 <= nota <= 100
    cmp bx, 0
    jb nota_fuera_rango
    cmp bx, 100
    ja nota_fuera_rango
    
    ; numero valido, guardarlo
    mov dx, bx ; guardar el numero convertido
    mov al, 0 ; codigo de exito
    jmp fin_conversion

; numero demasiado grande durante conversion
numero_muy_grande:
    lea dx, msg_nota_invalida
    call imprimir_cadena
    call presionar_continuar
    mov al, 0FFh ; codigo de error
    jmp fin_conversion

; nota fuera del rango 0-100
nota_fuera_rango:
    lea dx, msg_nota_invalida
    call imprimir_cadena
    call presionar_continuar
    mov al, 0FFh ; codigo de error

fin_conversion:
    pop dx
    pop cx
    pop bx
    pop si
    ret
convertir_y_validar_nota endp

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

; llenar nombre con espacios
llenar_espacios_nombre:
    mov al, ' '
rellenar_nombre:
    cmp cx, 0 ; verificar si termina
    je nombre_copiado
    mov [di], al ; poner espacio
    inc di
    dec cx
    jmp rellenar_nombre

; al finalizar de copiar nombre
nombre_copiado:

    ; === 2. ALMACENAR NOTA COMO STRING ===

    ; calcular posicion en array notas_str
    mov al, contador_estudiantes
    xor ah, ah
    mov bx, NOTA_STR
    mul bx

    ; copiar nota string desde nota_temporal a notas_str
    lea si, nota_temporal
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
    
    ; === 3. ALMACENAR NOTA COMO ENTERO (PARA CALCULOS) ===
    ; convertir la nota ya validada a entero
    
    call convertir_nota_a_entero
    
    ; almacenar en array notas_int
    mov al, contador_estudiantes
    xor ah, ah
    mov bx, 2 ; cada entrada son 2 bytes (word)
    mul bx
    mov si, ax ; guardar offset
    
    ; dx contiene el numero convertido de convertir_nota_a_entero
    mov bx, si
    mov word ptr [notas_int + bx], dx

    pop cx
    pop bx
    pop ax
    pop di
    pop si
    ret
almacenar_estudiante endp

; subrutina para convertir nota string a entero
convertir_nota_a_entero proc
    push si
    push bx
    push cx
    push ax

    lea si, nota_temporal ; apuntar al inicio de la nota
    mov bx, 0 ; acumulador para el numero
    
; convertir cada digito a numero
convertir_loop:
    mov al, [si] ; cargar caracter actual
    cmp al, 0 ; verificar fin de cadena
    je conversion_terminada
    
    ; convertir caracter a numero
    sub al, '0'
    mov ah, 0 ; limpiar parte alta
    
    ; multiplicar acumulador por 10
    push ax
    mov ax, bx
    mov cx, 10
    mul cx
    mov bx, ax
    pop ax
    
    ; sumar nuevo digito
    add bx, ax
    
    inc si ; avanzar al siguiente caracter
    jmp convertir_loop

conversion_terminada:
    mov dx, bx ; retornar resultado en dx

    pop ax
    pop cx
    pop bx
    pop si
    ret
convertir_nota_a_entero endp

end