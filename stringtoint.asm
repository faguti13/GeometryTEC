
; FALTA GESTIONAR CANTIDAD DE INTS Y FLOATS, POR EJEMPLO, SABER CUANDO ES 1.21 Y 12.1 

.model small
.stack 100h
.data
    input db 8, 0, 8 dup(?)  ; Buffer para la entrada
    result dw 0              ; Resultado final
    temp dw 0                ; Valor temporal para conversión
    squared_result dw 0      ; Resultado del cuadrado
    perimeter dw 0           ; Resultado del perímetro
    remainder dw 0           ; Para almacenar el residuo de la división
    has_point db 0           ; Flag para saber si hay un punto
    num_digits db 0          ; Contador de dígitos convertidos
    newline db 0Dh, 0Ah, '$'
    square_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del cuadrado. $', 0Dh, 0Ah, '$'
    square_area_result_msg db 'El area del cuadrado es: $'
    square_perimeter_result_msg db ' y el perimetro del cuadrado es: $'
    
.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    mov ah, 09h
    lea dx, square_side_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Leer entrada del teclado
    lea dx, input      ; Cargar la dirección del buffer en DX
    mov ah, 0Ah        ; Función 0Ah - Leer cadena de caracteres
    int 21h            ; Interrupción para leer la entrada
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    mov ah, 09h
    lea dx, square_area_result_msg
    int 21h
    
    ; Convertir cadena a número ignorando el punto
    mov cl, [input + 1] ; Cargar la longitud de la cadena en CL
    lea si, input + 2   ; Cargar la dirección de la cadena en SI

    ; Inicializar contadores
    mov num_digits, 0   ; Reiniciar el contador de dígitos

convert_loop:
    dec cl              ; Decrementar CL (número de caracteres restantes)
    js done_conversion  ; Si CL es negativo, salir del bucle

    lodsb               ; Cargar el siguiente byte en AL
    cmp al, '.'         ; Verificar si el carácter es un punto
    je found_point      ; Si es un punto, marcar la flag

    sub al, '0'         ; Convertir el carácter ASCII a número
    mov ah, 0           ; Limpiar AH
    mov temp, ax        ; Guardar el valor numérico temporalmente

    ; Multiplicar el resultado actual por 10
    mov ax, result      ; Cargar el resultado actual en AX
    mov dx, 0           ; Limpiar DX
    mov bx, 10          ; Preparar BX para multiplicar por 10
    mul bx              ; AX = AX * 10
    add ax, temp        ; Sumar el número convertido al resultado
    mov result, ax      ; Guardar el nuevo resultado en result

    inc num_digits      ; Incrementar contador de dígitos
    jmp convert_loop    ; Continuar con el siguiente carácter

found_point:
    mov has_point, 1    ; Marcar que el punto ha sido encontrado
    jmp convert_loop

done_conversion:
    ; Verificar si el número es menor que 1000 y contiene un punto
    cmp has_point, 1
    jne skip_multiply   ; Si no hay punto, saltar multiplicación
    
    cmp num_digits, 2   ; Verificar si el número tiene menos de 4 dígitos
    cmp num_digits, 3   ; Verificar si el número tiene menos de 4 dígitos
    jg skip_multiply    ; Si tiene más de 3 dígitos, saltar multiplicación

    ; Multiplicar por 10 si el número es menor que 1000 y tiene punto
    mov ax, result
    mov dx, 0
    mov bx, 10
    mul bx              ; AX = AX * 10
    mov result, ax      ; Guardar el nuevo resultado

skip_multiply:
    ; Cuadrar el resultado
    mov ax, result
    mul ax              ; AX = AX * AX
    mov squared_result, ax ; Guardar el cuadrado en squared_result

    ; Si el punto fue encontrado, dividir entre 100
    cmp has_point, 1
    jne no_division     ; Si no hay punto, saltar la división

    ; Dividir el resultado cuadrado entre 100
    mov ax, squared_result ; Cargar el resultado cuadrado en AX
    mov bx, 10000            ; Divisor
    div bx                 ; Dividir: AX = AX / BX, DX = residuo
    mov squared_result, ax ; Actualizar el resultado cuadrado
    mov remainder, dx      ; Guardar el residuo en remainder

no_division:
    ; Imprimir el resultado del área
    call PrintNum          ; Imprimir el cociente (en AX)

    ; Si hay punto, imprimir el punto y el residuo
    cmp has_point, 1
    jne calculate_perimeter ; Si no hay punto, saltar al cálculo del perímetro

    ; Imprimir el punto
    mov dl, '.'            ; Carácter punto
    mov ah, 02h            ; Función 02h - Imprimir carácter
    int 21h

    ; Imprimir el residuo (en DX) con longitud fija
    mov ax, remainder      ; Cargar el residuo en AX para impresión
    mov cx, 4              ; Queremos que el residuo tenga 4 dígitos
    call PrintNumFixed     ; Llamar a la función para imprimir con ceros a la izquierda

calculate_perimeter:

    ; Imprimir el mensaje del perímetro
    mov ah, 09h
    lea dx, square_perimeter_result_msg
    int 21h
    
    ; Calcular el perímetro
    mov ax, result
    mov dx, 0
    mov bx, 4              ; Multiplicar por 4
    mul bx
    mov perimeter, ax      ; Guardar el resultado en perimeter

    ; Dividir el perímetro entre 100
    mov ax, perimeter
    mov bx, 100          ; Divisor
    div bx
    mov perimeter, ax      ; Actualizar el resultado del perímetro
    mov remainder, dx      ; Guardar el residuo en remainder



    ; Imprimir el resultado del perímetro
    call PrintNum          ; Imprimir el cociente (en AX)

    ; Imprimir el punto
    mov dl, '.'            ; Carácter punto
    mov ah, 02h            ; Función 02h - Imprimir carácter
    int 21h

    ; Imprimir el residuo (en DX) con longitud fija
    mov ax, remainder      ; Cargar el residuo en AX para impresión
    mov cx, 4              ; Queremos que el residuo tenga 4 dígitos
    call PrintNumFixed     ; Llamar a la función para imprimir con ceros a la izquierda

done_printing:
    mov ah, 4Ch            ; Terminar el programa
    int 21h
main endp

; Función para imprimir un número en AX
PrintNum proc
    push ax               ; Guardar AX
    push bx               ; Guardar BX
    push cx               ; Guardar CX
    push dx               ; Guardar DX

    mov cx, 0             ; Limpiar CX (contador de dígitos)
    mov bx, 10            ; Divisor base 10

convert_to_string:
    xor dx, dx            ; Limpiar DX antes de la división
    div bx                ; AX = AX / BX, DX = residuo (número de menor orden)
    push dx               ; Guardar el dígito en la pila
    inc cx                ; Incrementar contador de dígitos
    test ax, ax           ; Verificar si AX es 0
    jnz convert_to_string ; Si no es 0, continuar

print_digits:
    pop dx                ; Obtener el siguiente dígito
    add dl, '0'           ; Convertir el dígito a ASCII
    mov ah, 02h           ; Función 02h - Imprimir carácter
    int 21h               ; Imprimir el carácter
    loop print_digits     ; Repetir hasta que todos los dígitos se impriman

    pop dx                ; Restaurar registros
    pop cx
    pop bx
    pop ax
    ret
PrintNum endp

; Función para imprimir un número en AX con una longitud fija en CX
PrintNumFixed proc
    push ax               ; Guardar AX
    push bx               ; Guardar BX
    push cx               ; Guardar CX
    push dx               ; Guardar DX

    mov bx, 10            ; Divisor base 10
    mov dx, 0             ; Inicializar DX (residuo)
    
    ; Convertir número a string
    mov si, cx            ; Guardar la longitud deseada en SI
    xor cx, cx            ; Limpiar CX (contador de dígitos)
    
convert_to_string_fixed:
    xor dx, dx            ; Limpiar DX antes de la división
    div bx                ; AX = AX / BX, DX = residuo (número de menor orden)
    push dx               ; Guardar el dígito en la pila
    inc cx                ; Incrementar contador de dígitos
    test ax, ax           ; Verificar si AX es 0
    jnz convert_to_string_fixed ; Si no es 0, continuar

    ; Si la longitud deseada no se ha alcanzado, rellenar con ceros
fill_with_zeros:
    cmp cx, si
    jge print_digits_fixed ; Si CX >= longitud deseada, saltar al bucle de impresión
    push 0                ; Rellenar con 0
    inc cx                ; Incrementar el contador de dígitos
    jmp fill_with_zeros

print_digits_fixed:
    pop dx                ; Obtener el siguiente dígito
    add dl, '0'           ; Convertir el dígito a ASCII
    mov ah, 02h           ; Función 02h - Imprimir carácter
    int 21h               ; Imprimir el carácter
    loop print_digits_fixed ; Repetir hasta que todos los dígitos se impriman

    pop dx                ; Restaurar registros
    pop cx
    pop bx
    pop ax
    ret
PrintNumFixed endp

end main
