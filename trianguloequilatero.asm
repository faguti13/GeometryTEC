.model small
.stack 100h      

.data  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    msj1 db 'El perimetro es de: $'
    msj2 db 'El Area es de: $'  
    
    
    ;FALTA LA FUNCION PARA QUE ESTOS VALORES SEAN LAS ENTREDAS (PASAR DE ASCII A NUM)  
    num1 dd 500; base=lado
    num2 dd 258; altura       
    
           
        
    num1ResD dd ? ; dw = 4 byte   
    num2ResH dd ? ; para formar una respuesta de 8 bytes 
    num2ResL dd ? ; para formar una respuesta de 8 bytes
     
.code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main proc 
    
    ; Inicializa el segmento de datos
    mov ax, @data
    mov ds, ax  
    
    ;call perimetroTriangulo
    call areaTriangulo
    
    ; Terminar el programa
    mov ah, 4Ch
    int 21h
     
    main endp

;Perimetro: 3*base 
perimetroTriangulo proc;
    
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

;Area del triangulo num1*num2/2   
areaTriangulo proc;   
    
    ;Preparaci[on de los registros
    mov ax, [num2ResL+2] 
    mov bx, [num2ResL]
    mov cx, [num2ResH+2]
    mov dx,[num2ResH]
    
    ;Manejo de distintas convinaciones 
    
    ;base parte baja * altura parte baja   
    mov ax, word ptr [num1]
    mov cx, word ptr [num2]
    mul cx  
    mov cx, 2
    div cx
    add [num2ResL+2], ax
    add [num2ResL], dx
    
    ;base parte alta * altura parte baja   
    xor dx, dx
    xor ax, ax
    xor cx, cx
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num2]
    mul cx
    mov cx, 2
    div cx
    add [num2ResL],ax
    add [num2ResH+2],dx
    
    ;base parte baja * altura parte alta
    mov ax, word ptr [num1]
    mov cx, word ptr [num2+2]
    mul cx
    mov cx, 2
    div cx   
    xor cx, cx ; preparar para el acarreo 
    add [num2ResL], ax 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    add [num2ResH+2], cx
    add [num2ResH+2], dx
    
    ;base parte alta * altura parte alta
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num2+2]
    mul cx 
    mov cx, 2
    div cx
    add [num2ResH], dx
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
; PROCEDIMIENTOS GENERALES 

imprimir proc
    mov ah, 09h ; 09h: imprime una cadena, imprime la dirección de DX por defecto
    int 21h
    ret
    imprimir endp 

  
  
end main  

    
 