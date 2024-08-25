.model small
.stack 100h
.data
    input db 12, 0, 12 dup(?) ; Buffer para la entrada (más largo para manejar números grandes)
    length dw 0               ; Largo del rectángulo
    width dw 0                ; Ancho del rectángulo
    temp dw 0                 ; Valor temporal para conversión
    perimeter dw 0            ; Resultado del perímetro
    has_point db 0            ; Flag para saber si hay un punto
    num_digits db 0           ; Contador de dígitos convertidos
    newline db 0Dh, 0Ah, '$'
    length_msg db 'Por favor ingrese el largo del rectangulo: $'
    width_msg db 'Por favor ingrese el ancho del rectangulo: $'
    rectangle_perimeter_result_msg db 'El perimetro del rectangulo es: $'
    
.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ; Solicitar el largo
    mov ah, 09h
    lea dx, length_msg
    int 21h
    
    call ReadNumber
    mov length, ax
    
    ; Solicitar el ancho
    mov ah, 09h
    lea dx, width_msg
    int 21h
    
    call ReadNumber
    mov width, ax
    
    ; Calcular y mostrar el perímetro
    mov ah, 09h
    lea dx, rectangle_perimeter_result_msg
    int 21h
    
    ; Cálculo del perímetro: 2 * (largo + ancho)
    mov ax, length
    add ax, width
    mov bx, 2
    mul bx  ; Resultado en DX:AX (en AX está el perímetro)
    call PrintResult
    
    mov ah, 4Ch            ; Terminar el programa
    int 21h
main endp

; Función para leer un número
ReadNumber proc
    push bx
    push cx
    push dx
    
    mov ah, 0Ah
    lea dx, input
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    xor ax, ax
    mov cl, [input + 1]
    lea si, input + 2
    mov has_point, 0
    mov num_digits, 0
    xor bx, bx  ; Inicializar BX a 0

convert_loop:
    dec cl
    js done_conversion
    lodsb
    cmp al, '.'
    je found_point
    sub al, '0'
    mov ah, 0
    mov temp, ax
    mov ax, bx
    mov bx, 10
    mul bx
    add ax, temp
    mov bx, ax
    inc num_digits
    jmp convert_loop

found_point:
    mov has_point, 1
    jmp convert_loop

done_conversion:
    mov ax, bx
    
    ; Ajuste por punto decimal
    cmp has_point, 1
    jne skip_multiply
    
    cmp num_digits, 3
    jg skip_multiply
    
    mov bx, 10
    mul bx

skip_multiply:
    pop dx
    pop cx
    pop bx
    ret
ReadNumber endp

; Función para imprimir el resultado
PrintResult proc
    push bx
    push cx
    push dx
    
    mov bx, 100
    xor dx, dx
    div bx  ; AX = cociente (parte entera), DX = residuo (parte decimal)
    
    push dx  ; Guardar el residuo para después
    
    call PrintNum  ; Ahora AX contiene la parte entera, así que esto es correcto
    
    mov dl, '.'
    mov ah, 02h
    int 21h
    
    pop ax  ; Recuperar el residuo en AX para PrintNumFixed
    mov cx, 2
    call PrintNumFixed
    
    pop dx
    pop cx
    pop bx
    ret
PrintResult endp

; Función para imprimir un número en AX
PrintNum proc
    push ax
    push bx
    push cx
    push dx

    mov cx, 0
    mov bx, 10

convert_to_string:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_to_string

print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintNum endp

; Función para imprimir un número en AX con una longitud fija en CX
PrintNumFixed proc
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    mov dx, 0
    mov si, cx
    xor cx, cx

convert_to_string_fixed:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_to_string_fixed

fill_with_zeros:
    cmp cx, si
    jge print_digits_fixed
    push 0
    inc cx
    jmp fill_with_zeros

print_digits_fixed:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits_fixed

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintNumFixed endp

end main
