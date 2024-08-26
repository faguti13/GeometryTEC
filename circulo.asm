.model small
.stack 100h
.data
    msj1 db 'El perimetro es de: $' ; Mensaje para el perimetro
    msj2 db 'El area es de: $' ; Mensaje para el area
    
    radio dw 144 ; Radio del circulo (valor de entrada)
    pi dw 314 ; Valor de pi * 100 (3.14 * 100 = 314)
    
    resPerimetroL dw ? ; Parte baja del resultado del perimetro
    resPerimetroH dw ? ; Parte alta del resultado del perimetro
    resAreaL dw ? ; Parte baja del resultado del area
    resAreaH dw ? ; Parte alta del resultado del area

.code
main proc 
    mov ax, @data ; Inicializar segmento de datos
    mov ds, ax  
    
    ;call perimetroCirculo ; Llamar al procedimiento para calcular el perimetro
    call areaCirculo ; Llamar al procedimiento para calcular el area (comentado)
    
    mov ah, 4Ch ; Salida del programa
    int 21h
    
main endp

perimetroCirculo proc
    ; Calculo del perimetro = 2 * pi * radio
    mov ax, radio ; Cargar el valor del radio en AX
    mov bx, pi ; Cargar el valor de pi en BX
    mul bx ; Multiplicar AX por BX, resultado en DX:AX (radio * pi)
    
    ; Multiplicar por 2 para obtener el perimetro
    add ax, ax ; Sumar AX consigo mismo (AX = AX * 2)
    adc dx, dx ; Sumar con acarreo en DX (DX = DX * 2)
    
    ; Verificar valores en DX:AX (usado para prueba)
    ; QUITAR DESPUES - solo para verificar
    mov bx, ax ; Copiar AX a BX
    mov cx, dx ; Copiar DX a CX
    
    ; Dividir por 100 para ajustar la escala de pi
    mov bx, 100 ; Cargar 100 en BX
    div bx ; Dividir DX:AX por BX (AX = cociente, DX = residuo)
    
    ; Verificacion final del resultado (usado para prueba)
    ; QUITAR DESPUES - solo para verificar
    mov bx, ax ; Copiar AX a BX
    mov cx, dx ; Copiar DX a CX
    
    mov resPerimetroL, ax ; Guardar la parte baja del resultado
    mov resPerimetroH, dx ; Guardar la parte alta del resultado
    
    ; Imprimir el mensaje del perimetro
    lea dx, msj1 ; Cargar la direccion de msj1 en DX
    call imprimir ; Llamar al procedimiento de impresion
    
    ; Aqui iria la funcion para convertir el resultado a ASCII e imprimirlo
    
    ret 
perimetroCirculo endp

areaCirculo proc
    ; Calculo del area = pi * radio^2
    mov ax, [radio] ; Cargar el valor del radio en AX
    mul ax ; Multiplicar AX por AX, resultado en DX:AX (radio^2)
    
    mov bx, [pi] ; Cargar el valor de pi en BX
    mul bx ; Multiplicar DX:AX por BX (resultado en DX:AX)
    
    ; Dividir por 100 para ajustar la escala de pi
    mov bx, 100 ; Cargar 100 en BX
    div bx ; Dividir DX:AX por BX (AX = cociente, DX = residuo)
    
    mov [resAreaL], ax ; Guardar la parte baja del resultado
    mov [resAreaH], dx ; Guardar la parte alta del resultado
    
    ; Imprimir el mensaje del area
    lea dx, msj2 ; Cargar la direccion de msj2 en DX
    call imprimir ; Llamar al procedimiento de impresion
    
    ; Aqui iria la funcion para convertir el resultado a ASCII e imprimirlo
    
    ret
areaCirculo endp

imprimir proc
    mov ah, 09h ; Funcion DOS para imprimir cadena de caracteres
    int 21h ; Llamada a interrupcion
    ret
imprimir endp

end main
