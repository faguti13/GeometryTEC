
; FALTA GESTIONAR CANTIDAD DE INTS Y FLOATS, POR EJEMPLO, SABER CUANDO ES 1.21 Y 12.1 

.model small
.stack 100h
.data
    input db 8, 0, 8 dup(?)  ; Buffer para la entrada
    result dw 0              ; Resultado final
    temp dw 0                ; Valor temporal para conversi�n
    squared_result dw 0      ; Resultado del cuadrado
    perimeter dw 0           ; Resultado del per�metro
    remainder dw 0           ; Para almacenar el residuo de la divisi�n
    has_point db 0           ; Flag para saber si hay un punto
    num_digits db 0          ; Contador de d�gitos convertidos
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
    lea dx, input      ; Cargar la direcci�n del buffer en DX
    mov ah, 0Ah        ; Funci�n 0Ah - Leer cadena de caracteres
    int 21h            ; Interrupci�n para leer la entrada
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    mov ah, 09h
    lea dx, square_area_result_msg
    int 21h
    
    ; Convertir cadena a n�mero ignorando el punto
    mov cl, [input + 1] ; Cargar la longitud de la cadena en CL
    lea si, input + 2   ; Cargar la direcci�n de la cadena en SI

    ; Inicializar contadores
    mov num_digits, 0   ; Reiniciar el contador de d�gitos

convert_loop:
    dec cl              ; Decrementar CL (n�mero de caracteres restantes)
    js done_conversion  ; Si CL es negativo, salir del bucle

    lodsb               ; Cargar el siguiente byte en AL
    cmp al, '.'         ; Verificar si el car�cter es un punto
    je found_point      ; Si es un punto, marcar la flag

    sub al, '0'         ; Convertir el car�cter ASCII a n�mero
    mov ah, 0           ; Limpiar AH
    mov temp, ax        ; Guardar el valor num�rico temporalmente

    ; Multiplicar el resultado actual por 10
    mov ax, result      ; Cargar el resultado actual en AX
    mov dx, 0           ; Limpiar DX
    mov bx, 10          ; Preparar BX para multiplicar por 10
    mul bx              ; AX = AX * 10
    add ax, temp        ; Sumar el n�mero convertido al resultado
    mov result, ax      ; Guardar el nuevo resultado en result

    inc num_digits      ; Incrementar contador de d�gitos
    jmp convert_loop    ; Continuar con el siguiente car�cter

found_point:
    mov has_point, 1    ; Marcar que el punto ha sido encontrado
    jmp convert_loop

done_conversion:
    ; Verificar si el n�mero es menor que 1000 y contiene un punto
    cmp has_point, 1
    jne skip_multiply   ; Si no hay punto, saltar multiplicaci�n
    
    cmp num_digits, 2   ; Verificar si el n�mero tiene menos de 4 d�gitos
    cmp num_digits, 3   ; Verificar si el n�mero tiene menos de 4 d�gitos
    jg skip_multiply    ; Si tiene m�s de 3 d�gitos, saltar multiplicaci�n

    ; Multiplicar por 10 si el n�mero es menor que 1000 y tiene punto
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
    jne no_division     ; Si no hay punto, saltar la divisi�n

    ; Dividir el resultado cuadrado entre 100
    mov ax, squared_result ; Cargar el resultado cuadrado en AX
    mov bx, 10000            ; Divisor
    div bx                 ; Dividir: AX = AX / BX, DX = residuo
    mov squared_result, ax ; Actualizar el resultado cuadrado
    mov remainder, dx      ; Guardar el residuo en remainder

no_division:
    ; Imprimir el resultado del �rea
    call PrintNum          ; Imprimir el cociente (en AX)

    ; Si hay punto, imprimir el punto y el residuo
    cmp has_point, 1
    jne calculate_perimeter ; Si no hay punto, saltar al c�lculo del per�metro

    ; Imprimir el punto
    mov dl, '.'            ; Car�cter punto
    mov ah, 02h            ; Funci�n 02h - Imprimir car�cter
    int 21h

    ; Imprimir el residuo (en DX) con longitud fija
    mov ax, remainder      ; Cargar el residuo en AX para impresi�n
    mov cx, 4              ; Queremos que el residuo tenga 4 d�gitos
    call PrintNumFixed     ; Llamar a la funci�n para imprimir con ceros a la izquierda

calculate_perimeter:

    ; Imprimir el mensaje del per�metro
    mov ah, 09h
    lea dx, square_perimeter_result_msg
    int 21h
    
    ; Calcular el per�metro
    mov ax, result
    mov dx, 0
    mov bx, 4              ; Multiplicar por 4
    mul bx
    mov perimeter, ax      ; Guardar el resultado en perimeter

    ; Dividir el per�metro entre 100
    mov ax, perimeter
    mov bx, 100          ; Divisor
    div bx
    mov perimeter, ax      ; Actualizar el resultado del per�metro
    mov remainder, dx      ; Guardar el residuo en remainder



    ; Imprimir el resultado del per�metro
    call PrintNum          ; Imprimir el cociente (en AX)

    ; Imprimir el punto
    mov dl, '.'            ; Car�cter punto
    mov ah, 02h            ; Funci�n 02h - Imprimir car�cter
    int 21h

    ; Imprimir el residuo (en DX) con longitud fija
    mov ax, remainder      ; Cargar el residuo en AX para impresi�n
    mov cx, 4              ; Queremos que el residuo tenga 4 d�gitos
    call PrintNumFixed     ; Llamar a la funci�n para imprimir con ceros a la izquierda

done_printing:
    mov ah, 4Ch            ; Terminar el programa
    int 21h
main endp

; Funci�n para imprimir un n�mero en AX
PrintNum proc
    push ax               ; Guardar AX
    push bx               ; Guardar BX
    push cx               ; Guardar CX
    push dx               ; Guardar DX

    mov cx, 0             ; Limpiar CX (contador de d�gitos)
    mov bx, 10            ; Divisor base 10

convert_to_string:
    xor dx, dx            ; Limpiar DX antes de la divisi�n
    div bx                ; AX = AX / BX, DX = residuo (n�mero de menor orden)
    push dx               ; Guardar el d�gito en la pila
    inc cx                ; Incrementar contador de d�gitos
    test ax, ax           ; Verificar si AX es 0
    jnz convert_to_string ; Si no es 0, continuar

print_digits:
    pop dx                ; Obtener el siguiente d�gito
    add dl, '0'           ; Convertir el d�gito a ASCII
    mov ah, 02h           ; Funci�n 02h - Imprimir car�cter
    int 21h               ; Imprimir el car�cter
    loop print_digits     ; Repetir hasta que todos los d�gitos se impriman

    pop dx                ; Restaurar registros
    pop cx
    pop bx
    pop ax
    ret
PrintNum endp

; Funci�n para imprimir un n�mero en AX con una longitud fija en CX
PrintNumFixed proc
    push ax               ; Guardar AX
    push bx               ; Guardar BX
    push cx               ; Guardar CX
    push dx               ; Guardar DX

    mov bx, 10            ; Divisor base 10
    mov dx, 0             ; Inicializar DX (residuo)
    
    ; Convertir n�mero a string
    mov si, cx            ; Guardar la longitud deseada en SI
    xor cx, cx            ; Limpiar CX (contador de d�gitos)
    
convert_to_string_fixed:
    xor dx, dx            ; Limpiar DX antes de la divisi�n
    div bx                ; AX = AX / BX, DX = residuo (n�mero de menor orden)
    push dx               ; Guardar el d�gito en la pila
    inc cx                ; Incrementar contador de d�gitos
    test ax, ax           ; Verificar si AX es 0
    jnz convert_to_string_fixed ; Si no es 0, continuar

    ; Si la longitud deseada no se ha alcanzado, rellenar con ceros
fill_with_zeros:
    cmp cx, si
    jge print_digits_fixed ; Si CX >= longitud deseada, saltar al bucle de impresi�n
    push 0                ; Rellenar con 0
    inc cx                ; Incrementar el contador de d�gitos
    jmp fill_with_zeros

print_digits_fixed:
    pop dx                ; Obtener el siguiente d�gito
    add dl, '0'           ; Convertir el d�gito a ASCII
    mov ah, 02h           ; Funci�n 02h - Imprimir car�cter
    int 21h               ; Imprimir el car�cter
    loop print_digits_fixed ; Repetir hasta que todos los d�gitos se impriman

    pop dx                ; Restaurar registros
    pop cx
    pop bx
    pop ax
    ret
PrintNumFixed endp

end main
