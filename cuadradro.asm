.model small
.stack 100h

.data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    input db 100 dup(0)    ; Buffer para la entrada del usuario
    ;result dd ?            ; Resultado de 32 bits
    newline db 13, 10, '$' ; Para imprimir nueva línea
    ;debug_msg db 'Iteracion: $'
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
    
    ;call perimetroCuadrado
    ;call areaCuadradro 
    ;call perimetroRect 
<<<<<<< HEAD
    call areaRect
    ;cal perimetroTriangulo
    ;call areaTriangulo
    ;call perimetroRombo
    ;call areaRombo 
    ;call perimetroPent
=======
    ;call areaRect 
    ;call perimetroPen
    ;call perimetroParale
    ;call areaParale
    
>>>>>>> 14996a4055ab3dd2c0c3181820b6cf531d3667a5
    
       
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
    ;call print_number
    ;call print_newline

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

    ; Imprimir el valor actual
    ;call print_result

skip_dot:
    ; Avanzar al siguiente carácter
    inc si
    jmp convert_loop

done:
    ; Imprimir el resultado final
    ;mov dx, offset newline
    ;mov ah, 9
    ;int 21h

    
    call areaCuadradro
    ; Llama a la función para convertir el número de vuelta a una cadena
    call result_to_string
    
    
     
    call perimetroCuadrado
    ; Llama a la función para convertir el número de vuelta a una cadena
    call result_to_string
    
        
    ; Terminar el programa
    mov ax, 4c00h
    int 21h


main endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

perimetroPent proc ; num1 = lado   
     
    ;parte baja  
    mov ax, word ptr [num1]
    mov cx, 5
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax
    mov [num1ResD], dx
   
    ;parte alta
    mov ax, word ptr [num1+2]
    mov cx, 5
    mul cx ; result solo queda en AX  
    add [num1ResD], ax 
    
    mov ax, [num1ResD] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar
      
    mov [num2+2], bx ;para guardar el perimetro ya calculado en num2
    mov [num2], ax  
    ; Imprimir el mensaje del perimetro
    lea dx, msj1
    call imprimir 
    
    ;Imprimir el perimetro calculado
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
    
    ret 
    perimetroPent endp

areaPent proc ; num1 = lado; num3 = apotema; num2= perimetro 
    
    
    call productoEntrada1PorEntrada2 ; en este caso lado*altura (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
  
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar   
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    
    
    
    
    
    
    ret
    areaPent endp



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
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
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
; RECTANGULO

perimetroRect proc ; num1= base, num2= altura
    
    call DosVecesNum1MasNum2
    
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
      
    ret
    perimetroRect endp  

areaRect proc ; num1= base, num2= altura
    
    call productoEntrada1PorEntrada2 ; en este caso base*altura (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
  
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar   
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
     
    ret
<<<<<<< HEAD
    areaRect endp     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TRIANGULO EQUILATERO

perimetroTriangulo proc 
    
    ;parte baja  
    mov ax, word ptr [num1]
    mov cx, 3
    mul cx ; queda en Dx:Ax Dx parte Alta, Ax parte baja
    mov [num1ResD+2], ax ;parte baja en los 2 bytes superiores  de Ax
    mov [num1ResD], dx ;parte alta en los 2 bytes inferiores de Dx
      
    ;parte alta
    mov ax, word ptr [num1+2]
    mov cx, 3
    mul cx ; result solo queda en AX      
    add [num1ResD], ax 
    mov bx, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar   
    
    ;Mensaje del perimetro
    lea dx, msj1
    call imprimir 
    
    ;Imprimir el perimetro calculado
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
    
    ret
    
    perimetroTriangulo endp

areaTriangulo proc          
    
    ;Preparaci[on de los registros
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar  
    
    ;Manejo de distintas convinaciones 
    
    ;base parte baja * altura parte baja   
    mov ax, word ptr [num1] ;num1=999999  
    mov cx, 2 
    div cx
    mov cx, word ptr [num2] ;num2=999999
    mul cx
    add [num2ResL+2], ax  
    add [num2ResL], dx
    
    ;base parte alta * altura parte baja   
    xor dx, dx
    xor ax, ax
    xor cx, cx
    mov ax, word ptr [num1+2] 
    mov cx,2
    div cx
    mov cx, word ptr [num2]
    mul cx
    add [num2ResL],ax
    add [num2ResH+2],dx
    
    ;base parte baja * altura parte alta  
    mov ax, word ptr [num1]  
    mov cx, 2
    div cx
    mov cx, word ptr [num2+2]
    mul cx  
    xor cx, cx ; preparar para el acarreo 
    add [num2ResL], ax 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    add [num2ResH+2], cx
    add [num2ResH+2], dx
    
    ;base parte alta * altura parte alta
    mov ax, word ptr [num1+2]     
    mov cx, 2
    div cx
    mov cx, word ptr [num2+2]
    mul cx 
    add [num2ResH],dx
    add [num2ResH+2], ax 

    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    
    ;Mensaje del area
    lea dx, msj2
    call imprimir

    ; Imprimir el área calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII

    ret    
    
    areaTriangulo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ROMBO 
  
;num1=diagonal mayor,num2=diagonal menor,num3=lado 
perimetroRombo pro ; p=4*num3 
    
    ;parte baja  
    mov ax, word ptr [num3]
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
    perimetroRombo endp   

areaRombo proc ;num1*num2/2
    
    areaRombo endp
=======
    areaRect endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PARALELOGRAMO

perimetroParale proc ; num1= base, num2= altura
    
    call DosVecesNum1MasNum2
    
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
      
    ret
    perimetroParale endp


areaParale proc
    call productoEntrada1PorEntrada2
    
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar   
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
     
    ret
 
areaParale endp    
>>>>>>> 14996a4055ab3dd2c0c3181820b6cf531d3667a5
    
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

productoEntrada1PorEntrada2 proc  ;hace num1*num2
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
            
    ;parte baja * parte baja
    mov ax, word ptr [num1]
    mov cx, word ptr [num2]
    mul cx ; queda en DX:AX 
    add [num2ResL+2], ax
    add [num2ResL], dx
   
    ;parte alta * parte baja 
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num2]
    mul cx ; result solo queda en AX  
    add [num2ResL], ax
    add [num2ResH+2], dx  
    
    ;parte baja * parte alta
    mov ax, word ptr [num1]
    mov cx, word ptr [num2+2]
    mul cx ; queda en DX:AX
    xor cx, cx ; preparar para el acarreo 
    add [num2ResL], ax 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    add [num2ResH+2], cx
    add [num2ResH+2], dx
   
    ;parte alta * parte alta
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num2+2]
    mul cx ; result solo queda en AX  
    add [num2ResH+2], ax
    add [num2ResH], dx     
        
    ret
    productoEntrada1PorEntrada2 endp     



DosVecesNum1MasNum2 proc ; num1= base, num2= altura
    
    ;parte baja base + parte baja altura  (b+h)
    mov ax, word ptr [num1]
    mov bx, word ptr [num2]
    xor cx, cx ; preparar para el acarreo 
    add ax, bx 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    mov [num1ResD], ax  ;parte baja 
    mov [num1ResD+2], cx  ;parte baja   
    
    ;parte alta base + parte alta altura  (b+h) 
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num2+2]
    add ax, cx    
    add [num1ResD+2],ax  ;parte alta 
    
    ;parte baja * 2;  2*(b+h)
    mov ax, word ptr [num1ResD]
    mov cx, 2
    mul cx ; queda en DX:AX 
    mov [num2ResH+2], ax  
    mov [num2ResH], dx  
    
    ;parte alta * 2;  2*(b+h)
    mov ax, word ptr [num1ResD+2]
    mov cx, 2
    mul cx ; queda solo en AX 
    add [num2ResH], ax 
      
    ret
    DosVecesNum1MasNum2 endp 
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 



; Función para imprimir el resultado actual en hexadecimal
print_result proc
    push ax
    push dx
    mov dx, word ptr [num2ResL+2]
    call print_word
    mov dx, word ptr [num2ResL]
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

; Función para convertir el resultado a una cadena de caracteres y mostrarla
result_to_string proc
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

convert_to_string:
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
    jnz convert_to_string

    ; Añadir terminador de cadena
    mov byte ptr [di], 0

    ; Invertir la cadena
    lea si, input
    sub di, 1      ; Ajustar di al último carácter de la cadena
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