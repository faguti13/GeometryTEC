.model small
.stack 100h

.data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    input db 100 dup(0)    ; Buffer para la entrada del usuario
    newline db 13, 10, '$' ; Para imprimir nueva línea
    
    square_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del cuadrado. $', 0Dh, 0Ah, '$'

    
    msj1 db 'El perimetro es de: $'
    msj2 db 'El area es de: $'
    
    num1 dd ? ; FALTA LA FUNCION PARA QUE ESTOS VALORES SEAN LAS ENTREDAS (PASAR DE ASCII A NUM)  
    num2 dd 37 
    num3 dd 50321    
           
        
    num1ResD dd ? ; dw = 4 byte   
    num2ResH dd ? ; para formar una respuesta de 8 bytes 
    num2ResL dd ? ; para formar una respuesta de 8 bytes

   
.code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main proc 
    
    ; Inicializa el segmento de datos
    mov ax, @data
    mov ds, ax  
       
    ; Mostrar prompt
    mov dx, offset square_side_msg
    mov ah, 9
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer entrada del usuario
    mov ah, 0Ah
    mov dx, offset input
    mov byte ptr [input], 10  ; Máximo 99 caracteres
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
    mov word ptr [num1], ax
    mov word ptr [num1+2], ax

    ; Apuntar al inicio de la cadena de entrada
    lea si, input + 2
    xor cx, cx  ; Contador de iteraciones

convert_loop:
    inc cx
    push cx
    mov ah, 9
    pop cx
    mov ax, cx

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
    mov bx, 10
    mov ax, word ptr [num1]
    mul bx
    mov word ptr [num1], ax
    push dx
    mov ax, word ptr [num1+2]
    mul bx
    pop bx
    add ax, bx
    mov word ptr [num1+2], ax

    ; Sumar el nuevo dígito
    xor ah, ah
    mov al, [si]
    sub al, '0'
    add word ptr [num1], ax
    adc word ptr [num1+2], 0

skip_dot:
    ; Avanzar al siguiente carácter
    inc si
    jmp convert_loop

done:
    
    call areaCuadradro
    ; Llama a la función para convertir el número de vuelta a una cadena
    call ar_result_to_string
         
    call perimetroCuadrado
    ; Llama a la función para convertir el número de vuelta a una cadena
    call per_result_to_string
    
        
    ; Terminar el programa
    mov ax, 4c00h
    int 21h

main endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;CUADRADO

perimetroCuadrado proc ; num1 = lado   
     
    ;parte baja  
    mov ax, word ptr [num1]
    mov cx, 4
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax
    mov [num1ResD], dx
   
    ;parte alta
    mov ax, word ptr [num1+2]
    mov cx, 4
    mul cx ; result solo queda en AX  
    add [num1ResD], ax 
    
    mov ax, [num1ResD] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar
    
    ; Imprimir el mensaje del perimetro
    lea dx, msj1
    call imprimir 
    
    ;Imprimir el perimetro calculado
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
    
    ret 
    perimetroCuadrado endp

areaCuadradro proc ; num1 = lado
    
    call productoEntrada1PorEntrada1 ; en este caso lado*lado (num1*num1)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    
    ;mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    ;mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    ;mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    ;mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar   
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
         
    ret
    areaCuadradro endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PROCEDIMIENTOS GENERALES 

imprimir proc
    mov ah, 09h ; 09h: imprime una cadena, imprime la dirección de DX por defecto
    int 21h
    ret
    imprimir endp

productoEntrada1PorEntrada1 proc  ;hace num1*num1
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
             
    ;parte baja * parte baja
    mov ax, word ptr [num1]
    mov cx, word ptr [num1]
    mul cx ; queda en DX:AX 
    add [num2ResL+2], ax
    add [num2ResL], dx
   
    ;parte alta * parte baja 
    xor dx, dx
    xor ax, ax
    xor cx, cx
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num1]
    mul cx ; result solo queda en AX  
    add [num2ResL], ax
    add [num2ResH+2], dx  
    
    ;parte baja * parte alta
    mov ax, word ptr [num1]
    mov cx, word ptr [num1+2]
    mul cx ; queda en DX:AX
    xor cx, cx ; preparar para el acarreo 
    add [num2ResL], ax 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    add [num2ResH+2], cx
    add [num2ResH+2], dx
   
    ;parte alta * parte alta
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num1+2]
    mul cx ; result solo queda en AX  
    add [num2ResH+2], ax
    add [num2ResH], dx
    
    ret
    productoEntrada1PorEntrada1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

; Funcion para printear area
ar_result_to_string proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Buffer para almacenar la cadena resultante
    lea di, input  ; Reutilizamos el buffer de entrada
    xor cx, cx     ; Contador de dígitos

    ; Cargar el valor de result
    mov ax, word ptr [num2ResL+2]
    mov dx, word ptr [num2ResL]

ar_convert_to_string:
    ; Dividir por 10
    xor dx, dx     ; Limpiar dx antes de dividir
    mov bx, 10
    div bx         ; ax = ax:dx / 10, dx = residuo

    ; Convertir el residuo en un carácter
    add dl, '0'
    mov [di], dl
    inc di
    inc cx         ; Incrementar el contador de dígitos

    ; Repetir hasta que el valor sea 0
    test ax, ax
    jnz ar_convert_to_string

    ; Añadir terminador de cadena
    mov byte ptr [di], 0

    ; Invertir la cadena
    lea si, input
    sub di, 1      ; Ajustar di al último carácter de la cadena
ar_invert_string:
    cmp si, di
    jge ar_done_invert
    mov al, [si]
    mov bl, [di]
    mov [di], al
    mov [si], bl
    inc si
    dec di
    jmp ar_invert_string

ar_done_invert:
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
ar_result_to_string endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

; Funcion para printear perimetro
per_result_to_string proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Buffer para almacenar la cadena resultante
    lea di, input  ; Reutilizamos el buffer de entrada
    xor cx, cx     ; Contador de dígitos

    ; Cargar el valor de result (16 bits)
    mov ax, word ptr [num1ResD+2]

per_convert_to_string:
    ; Dividir por 10
    xor dx, dx     ; Limpiar DX para la división
    mov bx, 10
    div bx         ; AX = AX / 10, DX = residuo

    ; Convertir el residuo en un carácter
    add dl, '0'
    mov [di], dl
    inc di
    inc cx         ; Incrementar el contador de dígitos

    ; Repetir hasta que el valor sea 0
    test ax, ax
    jnz per_convert_to_string

    ; Añadir terminador de cadena
    mov byte ptr [di], 0

    ; Invertir la cadena
    lea si, input
    sub di, 1      ; Ajustar di al último carácter de la cadena
per_invert_string:
    cmp si, di
    jge per_done_invert
    mov al, [si]
    mov bl, [di]
    mov [di], al
    mov [si], bl
    inc si
    dec di
    jmp per_invert_string

per_done_invert:
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
per_result_to_string endp
 
end main