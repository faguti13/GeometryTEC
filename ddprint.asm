.model small
.stack 100h
.data
    input db 100 dup(0)    ; Buffer para la entrada del usuario
    result dw 3 dup(0)     ; Resultado de 48 bits (3 words)
    newline db 13, 10, '$' ; Para imprimir nueva línea
    debug_msg db 'Iteracion: $'
    prompt_msg db 'Ingrese un numero (max 14 digitos): $'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Mostrar prompt
    mov dx, offset prompt_msg
    mov ah, 9
    int 21h

    ; Leer entrada del usuario
    mov ah, 0Ah
    mov dx, offset input
    mov byte ptr [input], 99  ; Máximo 99 caracteres
    int 21h

    ; Agregar terminador de cadena
    mov si, offset input + 1
    mov cl, [si]  ; Longitud de la cadena
    xor ch, ch
    inc si
    add si, cx
    mov byte ptr [si], 0

    ; Inicializar el resultado a 0
    mov word ptr [result], 0
    mov word ptr [result+2], 0
    mov word ptr [result+4], 0

    ; Apuntar al inicio de la cadena de entrada
    lea si, input + 2
    xor cx, cx  ; Contador de iteraciones

convert_loop:
    ; Imprimir número de iteración
    inc cx
    push cx
    mov dx, offset debug_msg
    mov ah, 9
    int 21h
    pop cx
    mov ax, cx
    call print_number
    call print_newline

    ; Cargar el siguiente carácter
    mov al, [si]
    
    ; Verificar si hemos llegado al final de la cadena
    cmp al, 0
    je done

    ; Verificar si el carácter es un punto decimal y omitirlo
    cmp al, '.'
    je skip_dot

    ; Convertir ASCII a número
    sub al, '0'

    ; Multiplicar el resultado actual por 10
    push ax
    mov ax, 10
    call mul48
    pop ax

    ; Sumar el nuevo dígito
    xor ah, ah
    add [result], ax
    adc word ptr [result+2], 0
    adc word ptr [result+4], 0

    ; Imprimir el valor actual
    call print_result

skip_dot:
    ; Avanzar al siguiente carácter
    inc si
    jmp convert_loop

done:
    ; Imprimir el resultado final
    mov dx, offset newline
    mov ah, 9
    int 21h
    call print_result

    ; Llama a la función para convertir el número de vuelta a una cadena
    call result_to_string

    ; Terminar el programa
    mov ax, 4c00h
    int 21h

main endp

; Función para multiplicar el resultado de 48 bits por AX
mul48 proc
    push bx
    push cx
    push dx

    mov bx, ax  ; Guardar el multiplicador

    mov ax, word ptr [result]
    mul bx
    mov word ptr [result], ax
    mov cx, dx

    mov ax, word ptr [result+2]
    mul bx
    add ax, cx
    mov word ptr [result+2], ax
    adc dx, 0
    mov cx, dx

    mov ax, word ptr [result+4]
    mul bx
    add ax, cx
    mov word ptr [result+4], ax

    pop dx
    pop cx
    pop bx
    ret
mul48 endp

; Función para imprimir el resultado actual en hexadecimal
print_result proc
    push ax
    push dx
    mov dx, word ptr [result+4]
    call print_word
    mov dx, word ptr [result+2]
    call print_word
    mov dx, word ptr [result]
    call print_word
    call print_newline
    pop dx
    pop ax
    ret
print_result endp

; Función para imprimir una palabra (16 bits) en hexadecimal

print_word proc
    push ax
    push cx
    mov ax, dx
    mov cl, 12
    call print_nibble
    mov cl, 8
    call print_nibble
    mov cl, 4
    call print_nibble
    mov cl, 0
    call print_nibble
    pop cx
    pop ax
    ret
print_word endp
; Función para imprimir un nibble (4 bits)
print_nibble proc
    push ax
    push dx
    mov dx, ax
    shr dx, cl
    and dl, 0Fh
    add dl, '0'
    cmp dl, '9'
    jle print_digit
    add dl, 7
print_digit:
    mov ah, 2
    int 21h
    pop dx
    pop ax
    ret
print_nibble endp
; Función para imprimir un número decimal
print_number proc
    push ax
    push bx
    push cx
    push dx
    mov bx, 10
    xor cx, cx
convert_to_decimal:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_to_decimal
print_decimal:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop print_decimal
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp
; Función para imprimir nueva línea
print_newline proc
    push ax
    push dx
    mov dx, offset newline
    mov ah, 9
    int 21h
    pop dx
    pop ax
    ret
print_newline endp

result_to_string proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Limpiar el búfer de salida
    lea di, input
    mov cx, 100   ; Asumiendo que input tiene 100 bytes
    mov al, 0     ; Llenar con ceros
    rep stosb
    
    ; Reiniciar DI al inicio del búfer
    lea di, input
    mov cx, 15     ; Vamos a convertir hasta 15 dígitos (máximo para 48 bits)

    ; Cargar el valor de result (48 bits)
    mov ax, word ptr [result]
    mov bx, word ptr [result+2]
    mov dx, word ptr [result+4]

    ; Guardar la posición inicial de la pila
    mov si, sp

convert_to_string:
    ; Dividir el número de 48 bits por 10
    push cx
    mov cx, 10
    call div48
    pop cx

    ; Convertir el residuo en un carácter y guardarlo
    add di, '0'
    push di

    ; Verificar si el cociente es cero
    or ax, ax
    jnz continue_conversion
    or bx, bx
    jnz continue_conversion
    or dx, dx
    jz done_conversion

continue_conversion:
    loop convert_to_string

done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp print_result_string

finish_string:
    ; Añadir terminador de cadena
    mov byte ptr [di], '$'  ; Usar '$' como terminador para DOS

    ; Mostrar la cadena resultante
    lea dx, input
    mov ah, 9
    int 21h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
result_to_string endp
; Función para dividir un número de 32 bits por 10
; Entrada: DX:AX = dividendo, CX = divisor (10)
; Salida: DX:AX = cociente, BX = residuo
div32 proc
    push cx
    xor bx, bx
    mov cx, 32
div32_loop:
    shl ax, 1
    rcl dx, 1
    rcl bx, 1
    cmp bx, 10
    jb div32_skip
    sub bx, 10
    inc ax
div32_skip:
    loop div32_loop
    pop cx
    ret
div32 endp

div48 proc
    push si
    xor si, si
    mov di, 48

div48_loop:
    shl ax, 1
    rcl bx, 1
    rcl dx, 1
    rcl si, 1
    cmp si, cx
    jb div48_skip
    sub si, cx
    inc ax

div48_skip:
    dec di
    jnz div48_loop

    mov di, si  ; Residuo en DI
    and di, 0Fh  ; Asegurarse de que el residuo esté en el rango 0-9
    pop si
    ret
div48 endp