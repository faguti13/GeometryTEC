.model small
.stack 100h

.data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    msj1 db 'El perimetro es de: $'
    
    num1 dw 12 ; FALTA LA FUNCION PARA QUE ESTOS VALORES SEAN LAS ENTREDAS (PASAR DE ASCII A NUM)  
    num2 dw 5 
    num1Res dw ? ; dw = un byte  
    num2Res dw ? 
    num3Res dd ? ; dd = dos bytes


.code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main proc 
    
    ; Inicializa el segmento de datos
    mov ax, @data
    mov ds, ax  
    
    ;call perimetroCuadrado
    call areaCuadradro
    
    ; Terminar el programa
    mov ah, 4Ch
    int 21h
     
    main endp  

perimetroCuadrado proc ; num1.num2 = lado   
      
    ;parte entera 
    mov ax, num1
    mov cx, 4
    mul cx 
    mov num1Res, ax ; en num1Res está el perimetro de la parte entera
    
    ;parte decimal
    mov ax, num2
    mov cx, 4
    mul cx 
    mov num2Res, ax ; en num2Res está el perimetro de la parte decimal
    
    ; ajuste entre parte decimal y entera
    mov bx, num1Res 
    mov ax, num2Res 
    call ajusEntDec  
    add num1Res, ax ;en num1Res queda la parte entera ya ajustada
    mov num2Res, dx ;en num2Res queda la parte entera ya ajustada 
    
    mov ax, num1Res ;QUITAR DESPUES, solo es para verificar
    mov bx, num2Res ;QUITAR DESPUES, solo es para verificar
    
    ; Imprimir el mensaje del perimetro
    lea dx, msj1
    call imprimir 
    
    ;Imprimir el perimetro calculado
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
    
    ret 
    
    perimetroCuadrado endp

areaCuadradro proc  ; num1.num2 = lado  
    

    ;parte entera 
    mov ax, 10
    mov cx, num1
    mul cx ; el resul queda en DX:AX
    add ax, num2
    mul ax
    ;mov bx, 10000 ; Valor divisor
    ;div bx ; Divide el resultado

    ;parte decimal
    ;mov ax, num2
    ;mov cx, num2
    ;mul cx ; el resul queda en AX (no excede 16 bits) 
    ;mov num1Res, ax 
        
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
    ;mov cx, 100
    ;idiv cx 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    mov [num3Res], dx
    mov [num3Res+2], ax  
    
    ; ajuste entre parte decimal y entera  
    xor ax, ax
    xor dx, dx
    mov ax, num1Res ;fracción  
    call ajusEntDec 
    add [num3Res+2], ax
    mov num1Res, dx
    
    mov ax, [num3Res] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3Res+2] ;QUITAR DESPUES, solo es para verificar 
    mov cx, num1Res ;QUITAR DESPUES, solo es para verificar
    
    ; IMPRIMIR NUM3.num1
      
    ret
    areaCuadradro endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; PROCEDIMIENTOS GENERALES 

imprimir proc
    mov ah, 09h ; 09h: imprime una cadena, imprime la dirección de DX por defecto
    int 21h
    ret
    imprimir endp 

ajusEntDec proc ;necesita que en AX este el dividendo 
    mov cx, 100
    div cx ; deja en AX el cociente, en DX el residuo
    
    ret 
    ajusEntDec endp

end main
 