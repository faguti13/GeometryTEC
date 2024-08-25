.model small
.stack 100h
.data
    input db 12, 0, 12 dup(?) ; Buffer para la entrada (tamano suficiente para manejar numeros grandes)
    length dw 0               ; Largo del rectangulo
    width dw 0                ; Ancho del rectangulo
    temp dw 0                 ; Valor temporal para conversion
    perimeter dw 0            ; Resultado del perimetro
    has_point db 0            ; Flag para saber si hay un punto decimal
    num_digits db 0           ; Contador de digitos convertidos
    newline db 0Dh, 0Ah, '$' ; Secuencia de salto de linea
    length_msg db 'Por favor ingrese el largo del rectangulo: $' ; Mensaje para largo
    width_msg db 'Por favor ingrese el ancho del rectangulo: $' ; Mensaje para ancho
    rectangle_perimeter_result_msg db 'El perimetro del rectangulo es: $' ; Mensaje para el resultado del perimetro
    
.code
main proc
    ; Inicializar segment registers
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ; Solicitar el largo del rectangulo
    mov ah, 09h
    lea dx, length_msg
    int 21h
    
    ; Leer el largo del rectangulo
    call ReadNumber
    mov length, ax
    
    ; Solicitar el ancho del rectangulo
    mov ah, 09h
    lea dx, width_msg
    int 21h
    
    ; Leer el ancho del rectangulo
    call ReadNumber
    mov width, ax
    
    ; Mostrar el mensaje del perimetro
    mov ah, 09h
    lea dx, rectangle_perimeter_result_msg
    int 21h
    
    ; Calcular el perimetro: 2 * (largo + ancho)
    mov ax, length   ; Cargar el largo en AX
    add ax, width    ; Sumar el ancho a AX
    mov bx, 2        ; Cargar el valor 2 en BX
    mul bx           ; Multiplicar AX por BX (2 * (largo + ancho))
    call PrintResult ; Imprimir el resultado
    
    ; Terminar el programa
    mov ah, 4Ch
    int 21h
main endp

; Funcion para leer un numero desde la entrada
ReadNumber proc
    push bx           ; Guardar registro BX
    push cx           ; Guardar registro CX
    push dx           ; Guardar registro DX
    
    mov ah, 0Ah       ; Funcion 0Ah - Leer cadena de caracteres
    lea dx, input     ; Cargar la direccion del buffer de entrada en DX
    int 21h           ; Interrupcion para leer la entrada
    
    ; Salto de linea
    mov ah, 09h
    lea dx, newline
    int 21h
    
    xor ax, ax        ; Limpiar AX
    mov cl, [input + 1] ; Cargar la longitud de la cadena en CL
    lea si, input + 2 ; Cargar la direccion de la cadena en SI
    mov has_point, 0  ; Inicializar el flag de punto decimal
    mov num_digits, 0 ; Inicializar el contador de digitos
    xor bx, bx        ; Inicializar BX a 0

convert_loop:
    dec cl            ; Decrementar CL (numero de caracteres restantes)
    js done_conversion ; Si CL es negativo, salir del bucle
    lodsb             ; Cargar el siguiente byte en AL
    cmp al, '.'       ; Verificar si el caracter es un punto decimal
    je found_point    ; Si es un punto, marcar el flag
    sub al, '0'       ; Convertir el caracter ASCII a numero
    mov ah, 0         ; Limpiar AH
    mov temp, ax      ; Guardar el valor numerico temporalmente
    mov ax, bx        ; Cargar el resultado actual en AX
    mov bx, 10        ; Preparar BX para multiplicar por 10
    mul bx            ; AX = AX * 10
    add ax, temp      ; Sumar el numero convertido al resultado
    mov bx, ax        ; Guardar el nuevo resultado en BX
    inc num_digits    ; Incrementar el contador de digitos
    jmp convert_loop  ; Continuar con el siguiente caracter

found_point:
    mov has_point, 1  ; Marcar que el punto ha sido encontrado
    jmp convert_loop  ; Continuar con el siguiente caracter

done_conversion:
    mov ax, bx        ; Mover el resultado final a AX
    
    ; Ajuste por punto decimal
    cmp has_point, 1
    jne skip_multiply ; Si no hay punto, saltar multiplicacion
    
    cmp num_digits, 3 ; Verificar si el numero tiene menos de 4 digitos
    jg skip_multiply  ; Si tiene mas de 3 digitos, saltar multiplicacion

    mov bx, 10        ; Preparar para multiplicar por 10
    mul bx            ; Multiplicar el resultado por 10 para ajustar el punto decimal

skip_multiply:
    pop dx            ; Recuperar registro DX
    pop cx            ; Recuperar registro CX
    pop bx            ; Recuperar registro BX
    ret
ReadNumber endp

; Funcion para imprimir el resultado en AX
PrintResult proc
    push bx           ; Guardar registro BX
    push cx           ; Guardar registro CX
    push dx           ; Guardar registro DX
    
    mov bx, 100       ; Divisor para la parte decimal
    xor dx, dx        ; Limpiar DX
    div bx            ; Dividir AX por 100 (parte entera en AX, parte decimal en DX)
    
    push dx           ; Guardar el residuo (parte decimal) para imprimirlo despues
    
    call PrintNum     ; Imprimir la parte entera del resultado
    
    ; Imprimir el punto decimal
    mov dl, '.'       ; Carácter punto decimal
    mov ah, 02h       ; Funcion 02h - Imprimir carácter
    int 21h
    
    ; Imprimir la parte decimal del resultado
    pop ax            ; Recuperar el residuo (parte decimal)
    mov cx, 2         ; Longitud fija de 2 digitos para la parte decimal
    call PrintNumFixed ; Llamar a la funcion para imprimir con longitud fija
    
    pop dx            ; Recuperar registro DX
    pop cx            ; Recuperar registro CX
    pop bx            ; Recuperar registro BX
    ret
PrintResult endp

; Funcion para imprimir un numero en AX
PrintNum proc
    push ax           ; Guardar registro AX
    push bx           ; Guardar registro BX
    push cx           ; Guardar registro CX
    push dx           ; Guardar registro DX

    mov cx, 0         ; Limpiar CX (contador de digitos)
    mov bx, 10        ; Divisor base 10

convert_to_string:
    xor dx, dx        ; Limpiar DX antes de la division
    div bx            ; Dividir AX por 10, residuo en DX
    push dx           ; Guardar el digito en la pila
    inc cx            ; Incrementar contador de digitos
    test ax, ax       ; Verificar si AX es 0
    jnz convert_to_string ; Si no es 0, continuar

print_digits:
    pop dx            ; Obtener el siguiente digito
    add dl, '0'       ; Convertir el digito a ASCII
    mov ah, 02h       ; Funcion 02h - Imprimir carácter
    int 21h           ; Imprimir el carácter
    loop print_digits ; Repetir hasta imprimir todos los digitos

    pop dx            ; Recuperar registro DX
    pop cx            ; Recuperar registro CX
    pop bx            ; Recuperar registro BX
    pop ax            ; Recuperar registro AX
    ret
PrintNum endp

; Funcion para imprimir un numero en AX con longitud fija en CX
PrintNumFixed proc
    push ax           ; Guardar registro AX
    push bx           ; Guardar registro BX
    push cx           ; Guardar registro CX
    push dx           ; Guardar registro DX

    mov bx, 10        ; Divisor base 10
    mov dx, 0         ; Inicializar DX (residuo)
    mov si, cx        ; Guardar la longitud deseada en SI
    xor cx, cx        ; Limpiar CX (contador de digitos)
    
convert_to_string_fixed:
    xor dx, dx        ; Limpiar DX antes de la division
    div bx            ; Dividir AX por 10, residuo en DX
    push dx           ; Guardar el digito en la pila
    inc cx            ; Incrementar contador de digitos
    test ax, ax       ; Verificar si AX es 0
    jnz convert_to_string_fixed ; Si no es 0, continuar

fill_with_zeros:
    cmp cx, si        ; Comparar el contador con la longitud deseada
    jge print_digits_fixed ; Si CX >= longitud deseada, saltar al bucle de impresion
    push 0            ; Rellenar con 0
    inc cx            ; Incrementar contador de digitos
    jmp fill_with_zeros ; Continuar rellenando con 0

print_digits_fixed:
    pop dx            ; Recuperar el siguiente digito de la pila
    add dl, '0'       ; Convertir el digito a ASCII
    mov ah, 02h       ; Funcion 02h - Imprimir caracter
    int 21h           ; Imprimir el carácter
    loop print_digits_fixed ; Repetir hasta imprimir todos los digitos

    pop dx            ; Recuperar registro DX (residuo)
    pop cx            ; Recuperar registro CX (contador de digitos)
    pop bx            ; Recuperar registro BX (divisor)
    pop ax            ; Recuperar registro AX (resultado)
    ret               ; Retornar de la funcion
PrintNumFixed endp

end main