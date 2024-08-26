.model small
.stack 100h

.data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    msj1 db 'El perimetro es de: $'
    msj2 db 'El area es de: $'
    
    num1 dd 999999 ; FALTA LA FUNCION PARA QUE ESTOS VALORES SEAN LAS ENTREDAS (PASAR DE ASCII A NUM)  
    num2 dd 50321 
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
    call areaRect
    ;cal perimetroTriangulo
    ;call areaTriangulo
    ;call perimetroRombo
    ;call areaRombo 
    ;call perimetroPent
    
       
    ; Terminar el programa
    mov ah, 4Ch
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
    areaCuadradro endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RECTANGULO

perimetroRect proc ; num1= base, num2= altura
    
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
  
 
end main  


