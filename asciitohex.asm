.model small
.stack 100h
.data
    input db 100 dup(0)    ; Buffer para la entrada del usuario
    result dd ?            ; Resultado de 32 bits
    newline db 13, 10, '$' ; Para imprimir nueva l�nea
    debug_msg db 'Iteracion: $'
    prompt_msg db 'Ingrese un numero (max 9 digitos): $'

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
    mov byte ptr [input], 99  ; M�ximo 99 caracteres
    int 21h

    ; Agregar terminador de cadena
    mov si, offset input + 1
    mov cl, [si]  ; Longitud de la cadena
    xor ch, ch
    inc si
    add si, cx
    mov byte ptr [si], 0

    ; Inicializar el resultado a 0
    xor ax, ax
    mov word ptr [result], ax
    mov word ptr [result+2], ax

    ; Apuntar al inicio de la cadena de entrada
    lea si, input + 2
    xor cx, cx  ; Contador de iteraciones

convert_loop:
    ; Imprimir n�mero de iteraci�n
    inc cx
    push cx
    mov dx, offset debug_msg
    mov ah, 9
    int 21h
    pop cx
    mov ax, cx
    call print_number
    call print_newline

    ; Cargar el siguiente car�cter
    mov al, [si]
    
    ; Verificar si hemos llegado al final de la cadena
    cmp al, 0
    je done

    ; Verificar si el car�cter es un punto decimal y omitirlo
    cmp al, '.'
    je skip_dot

    ; Convertir ASCII a n�mero
    sub al, '0'

    ; Multiplicar el resultado actual por 10
    mov bx, 10
    mov ax, word ptr [result]
    mul bx
    mov word ptr [result], ax
    push dx
    mov ax, word ptr [result+2]
    mul bx
    pop bx
    add ax, bx
    mov word ptr [result+2], ax

    ; Sumar el nuevo d�gito
    xor ah, ah
    mov al, [si]
    sub al, '0'
    add word ptr [result], ax
    adc word ptr [result+2], 0

    ; Imprimir el valor actual
    call print_result

skip_dot:
    ; Avanzar al siguiente car�cter
    inc si
    jmp convert_loop

done:
    ; Imprimir el resultado final
    mov dx, offset newline
    mov ah, 9
    int 21h
    call print_result

    ; Llama a la funci�n para convertir el n�mero de vuelta a una cadena
    call result_to_string

    ; Terminar el programa
    mov ax, 4c00h
    int 21h


main endp
; Funci�n para imprimir el resultado actual en hexadecimal
print_result proc
    push ax
    push dx
    mov dx, word ptr [result+2]
    call print_word
    mov dx, word ptr [result]
    call print_word
    call print_newline
    pop dx
    pop ax
    ret
print_result endp
; Funci�n para imprimir una palabra (16 bits) en hexadecimal
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
; Funci�n para imprimir un nibble (4 bits)
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
; Funci�n para imprimir un n�mero decimal
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
; Funci�n para imprimir nueva l�nea
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

; Funci�n para convertir el resultado a una cadena de caracteres y mostrarla
result_to_string proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Buffer para almacenar la cadena resultante
    lea di, input  ; Reutilizamos el buffer de entrada
    xor cx, cx     ; Contador de d�gitos

    ; Cargar el valor de result
    mov ax, word ptr [result+2]
    mov dx, word ptr [result]

convert_to_string:
    ; Dividir por 10
    xor dx, dx     ; Limpiar dx antes de dividir
    mov bx, 10
    div bx         ; ax = ax:dx / 10, dx = residuo

    ; Convertir el residuo en un car�cter
    add dl, '0'
    mov [di], dl
    inc di
    inc cx         ; Incrementar el contador de d�gitos

    ; Repetir hasta que el valor sea 0
    test ax, ax
    jnz convert_to_string

    ; A�adir terminador de cadena
    mov byte ptr [di], 0

    ; Invertir la cadena
    lea si, input
    sub di, 1      ; Ajustar di al �ltimo car�cter de la cadena
invert_string:
    cmp si, di
    jge done_invert
    mov al, [si]
    mov bl, [di]
    mov [di], al
    mov [si], bl
    inc si
    dec di
    jmp invert_string

done_invert:
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

end main