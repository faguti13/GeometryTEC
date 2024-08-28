.model small
.stack 100h

.data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    msj1 db 'El perimetro es de: $'
    msj2 db 'El area es de: $'
    
    num1 dd 999999; FALTA LA FUNCION PARA QUE ESTOS VALORES SEAN LAS ENTREDAS (PASAR DE ASCII A NUM)  
    num2 dd 200
    num3 dd 14520
    num4 dd 208956
    num5 dd 10584
           
    num1ResD dd ? ;   
    num2ResH dd ? ; para formar una respuesta de 8 bytes 
    num2ResL dd ? ; para formar una respuesta de 8 bytes 
    num3ResH dd ? ; para formar una respuesta de 8 bytes 
    num3ResL dd ? ; para formar una respuesta de 8 bytes 
    num3ResF dw ?
    
    bufferResp1 db 10 dup('0'), '$'    
    ;bufferResp1 db 11 dup('$')  ; Reserva en 11 byte, cabe un num de 32 bits 

   
.code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main proc 
    
    ; Inicializa el segmento de datos
    mov ax, @data
    mov ds, ax  
    
    ;call perimetroCuadrado
    ;call areaCuadradro 
    ;call perimetroRect 
    ;call areaRect 
    ;call perimetroPent ;llama automaticamente al area tambien 
    ;call perimetroHex ;llama automaticamente al area tambien
    ;call perimetroTrapecio 
    ;call perimetroCirculo 
    ;call areaCirculo
    ;call perimetroParalelogramo
    ;call areaParalelogramo
    ;call perimetroTrian
    ;call areaTriangulo
    ;call perimetroRombo
    call areaRombo
       
    ; Terminar el programa
    mov ah, 4Ch
    int 21h
     
    main endp 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Rombo; num1= diagonal mayor, num2= diagonal menor, num3 = a

perimetroRombo proc  ; a = num3
    
    ;parte baja  
    mov ax, word ptr [num3]
    mov cx, 4
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax
    mov [num1ResD], dx
   
    ;parte alta
    mov ax, word ptr [num3+2]
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
 
 
areaRombo proc   ; num1= diagonal mayor, num2= diagonal menor
     
    ; diagonal mayor* menor
    call productoEntrada1PorEntrada2 ; en este caso diagonal mayor* menor(num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
      
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    
    ; dividir entre dos (D*d)/2 
    call divNumDe64bitsEntreDos ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    ; el result queda en [num3ResH]+[num3ResH+2]+[num3ResL]+[num3ResL+2] y la parte fraccional en [num3ResF]
    
    mov ax, [num3ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num3ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num3ResL+2] ;QUITAR DESPUES, solo es para verificar
    mov ax, [num3ResF] ;QUITAR DESPUES, solo es para verificar
    
    ret
    areaRombo endp 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; TRIANGULO; num1= altura, num2= lado

perimetroTrian proc  ; lado = num2
    
    ;parte baja  
    mov ax, word ptr [num2]
    mov cx, 3
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax
    mov [num1ResD], dx
   
    ;parte alta
    mov ax, word ptr [num2+2]
    mov cx, 3
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
    perimetroTrian endp
 
 
areaTriangulo proc 
     
    ; lado * altura
    call productoEntrada1PorEntrada2 ; en este caso altura * altura (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
      
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    
    ; dividir entre dos (l*h)/2 
    call divNumDe64bitsEntreDos ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    ; el result queda en [num3ResH]+[num3ResH+2]+[num3ResL]+[num3ResL+2] y la parte fraccional en [num3ResF]
    
    mov ax, [num3ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num3ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num3ResL+2] ;QUITAR DESPUES, solo es para verificar
    mov ax, [num3ResF] ;QUITAR DESPUES, solo es para verificar
    
    ret
    areaTriangulo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Trapecio; num1= altura, num2= (B+b);  num3= lado; num4= base mayor, num5= base menor 

perimetroTrapecio proc  ; num4= base mayor, num5= base menor; num3= lado;  B+b+l+l
     
    ;B+B
    ;parte baja Base + parte baja base  (B+b)
    mov ax, word ptr [num4]
    mov bx, word ptr [num5]
    xor cx, cx ; preparar para el acarreo 
    add ax, bx 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    mov [num1ResD], ax  ;parte baja 
    mov [num1ResD+2], cx  ;parte baja   
    
    ;parte alta Base + parte alta base  (B+B) 
    mov ax, word ptr [num4+2]
    mov cx, word ptr [num5+2]
    add ax, cx    
    add [num1ResD+2],ax  ;parte alta 
    
    mov ax, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD] ;QUITAR DESPUES, solo es para verificar 
    
    mov [num2+2], ax  ; guarda en num2 el resul de B+h (num4+num5)(esta parte se necesita en el area tambien)
    mov [num2], bx 
    
    mov cx, [num2] ;;;;;;;;; VER
    mov dx, [num2+2]
    
    ;l+l = l*2  ; l=num3
    ;parte baja * 2;  2*(l)
    mov ax, word ptr [num3]
    mov cx, 2
    mul cx ; queda en DX:AX 
    mov [num2ResH+2], ax  
    mov [num2ResH], dx  
    
    ;parte alta * 2;  2*(l)
    mov ax, word ptr [num3+2]
    mov cx, 2
    mul cx ; queda solo en AX 
    add [num2ResH], ax 
    
    mov ax, [num2ResH+2] ; QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    
    ;(B+B)+(l*2)
    ;parte baja (B+B) + parte (l*2) 
    mov ax, word ptr [num2]
    mov bx, word ptr [num2ResH+2]
    xor cx, cx ; preparar para el acarreo 
    add ax, bx 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    mov [num1ResD], ax  ;parte baja 
    mov [num1ResD+2], cx  ;parte baja   
    
    ;parte alta (B+b) + parte alta (l*2)  (B+B) 
    mov ax, word ptr [num2+2]
    mov cx, word ptr [num2ResH]
    add ax, cx    
    add [num1ResD+2],ax  ;parte alta 
    
    mov ax, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD] ;QUITAR DESPUES, solo es para verificar 
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
     
     
     
    mov [num2ResH], 0  ;se necesita en 0 para el result del area 
    mov [num2ResH+2], 0      
    
    call areaTrapecio
    
    ret
    perimetroTrapecio endp

areaTrapecio proc  ;num1= altura, num2= (B+b)
; antes de llamar a areaTrapecio se tiene que llamar a perimetroPent, para tener el valor de num2  
     
    ; (B+b) * altura h
    call productoEntrada1PorEntrada2 ; en este caso altura*(B+b) (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
      
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    
    ; dividir entre dos (p*a)/2 
    call divNumDe64bitsEntreDos ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    ; el result queda en [num3ResH]+[num3ResH+2]+[num3ResL]+[num3ResL+2] y la parte fraccional en [num3ResF]
    
    mov ax, [num3ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num3ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num3ResL+2] ;QUITAR DESPUES, solo es para verificar
    mov ax, [num3ResF] ;QUITAR DESPUES, solo es para verifica  
      
    ret
    areaTrapecio endp  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Hexagono num1 = apotema, num2 = perimetro, num3 = lado

perimetroHex proc ; num3 = lado    
     
    ;parte baja  
    mov ax, word ptr [num3]
    mov cx, 6
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax
    mov [num1ResD], dx
   
    ;parte alta
    mov ax, word ptr [num3+2]
    mov cx, 6
    mul cx ; result solo queda en AX  
    add [num1ResD], ax 
    
    mov ax, [num1ResD] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar  
    
    mov [num2+2], ax  ; guarda en num2 el resul del perimetro (necesario para el area)
    mov [num2], bx 
    
    mov cx, [num2] ;;;;;;;;; VER
    mov dx, [num2+2]
    
    ; Imprimir el mensaje del perimetro
    lea dx, msj1
    call imprimir 
    
    ;Imprimir el perimetro calculado
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
    
    call areaHex
    
    ret 
    
    perimetroHex endp

areaHex proc  ;num1 = apotema, num2 = perimetro, num3 = lado
    ; antes de llamar a areaPent se tiene que llamar a perimetroPent, para tener el valor de num2  
     
    ; perimetro * apotema
    call productoEntrada1PorEntrada2 ; en este caso apotema*perimetro (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
      
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    
    ; dividir entre dos (p*a)/2 
    call divNumDe64bitsEntreDos ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    ; el result queda en [num3ResH]+[num3ResH+2]+[num3ResL]+[num3ResL+2] y la parte fraccional en [num3ResF]
    
    mov ax, [num3ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num3ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num3ResL+2] ;QUITAR DESPUES, solo es para verificar
    mov ax, [num3ResF] ;QUITAR DESPUES, solo es para verifica  
    
    ret
    areaHex endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PARALELOGRAMO  num1=h, num2=base , num3=a

perimetroParalelogramo proc  
     
    ;parte baja base + parte baja altura  (b+a)
    mov ax, word ptr [num3]
    mov bx, word ptr [num2]
    xor cx, cx ; preparar para el acarreo 
    add ax, bx 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    mov [num1ResD], ax  ;parte baja 
    mov [num1ResD+2], cx  ;parte baja   
    
    ;parte alta base + parte alta altura  (b+h) 
    mov ax, word ptr [num3+2]
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
    perimetroParalelogramo endp

areaParalelogramo proc ; num1 = h, num2=  base 
          
    ; h*base 
    call productoEntrada1PorEntrada2 ; en este caso h*base (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
      
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    ret
    areaParalelogramo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CIRCULO  num1 = radio

perimetroCirculo proc ;num1 = radio  
    
    ;parte baja * 2;  2*r
    mov ax, word ptr [num1]
    mov cx, 2
    mul cx ; queda en DX:AX 
    mov [num2ResH+2], ax  
    mov [num2ResH], dx  
    
    ;parte alta * 2;  2*r
    mov ax, word ptr [num1+2]
    mov cx, 2
    mul cx ; queda solo en AX 
    add [num2ResH], ax 
    
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] 
    
    ;parte baja * 314 / se toma 3.14 como entero despues en el result se divide 
    mov ax, word ptr [num2ResH+2]
    mov cx, 314
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax  
    mov [num1ResD], dx 
    
    ;parte alta * 314 / se toma 3.14 como entero despues en el result se divide  
    mov ax, word ptr [num2ResH]
    mov cx, 314
    mul cx ; queda en DX:AX 
    add [num1ResD], ax
    
    mov ax, [num1ResD] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD+2]
    
    ret
    perimetroCirculo endp


areaCirculo proc ; num1= radio 
    
    ;hacer r*r   
    call productoEntrada1PorEntrada1 ; en este caso radio*radio (num1*num1)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar  
    
    ;hacer 3.14 * (l*l)
    ;parte baja * 314 / se toma 3.14 como entero despues en el result se divide 
    mov ax, word ptr [num2ResL+2]
    mov cx, 314
    mul cx ; queda en DX:AX 
    mov [num3ResL+2], ax  
    mov [num3ResL], dx 
    
    ;parte alta * 314 / se toma 3.14 como entero despues en el result se divide  
    mov ax, word ptr [num2ResL]
    mov cx, 314
    mul cx ; queda en DX:AX 
    add [num3ResL], ax
    mov [num3ResH+2], bx
    
    ;parte baja * 314 / se toma 3.14 como entero despues en el result se divide 
    mov ax, word ptr [num2ResH+2]
    mov cx, 314
    mul cx ; queda en DX:AX 
    add [num3ResH+2], ax  
    mov [num3ResH], dx 
    
    ;parte alta * 314 / se toma 3.14 como entero despues en el result se divide  
    mov ax, word ptr [num2ResH]
    mov cx, 314
    mul cx ; queda en DX:AX 
    add [num3ResH], ax
    
    mov ax, [num3ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num3ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num3ResL+2] ;QUITAR DESPUES, solo es para verificar 
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
    ;Imprimir el area calculada
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
   
    ret
    areaCirculo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Pentagono num1 = apotema, num2 = perimetro, num3 = lado

perimetroPent proc ; num3 = lado    
     
    ;parte baja  
    mov ax, word ptr [num3]
    mov cx, 5
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax
    mov [num1ResD], dx
   
    ;parte alta
    mov ax, word ptr [num3+2]
    mov cx, 5
    mul cx ; result solo queda en AX  
    add [num1ResD], ax 
    
    mov ax, [num1ResD] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar  
    
    mov [num2+2], ax  ; guarda en num2 el resul del perimetro (necesario para el area)
    mov [num2], bx 
    
    mov cx, [num2] ;;;;;;;;; VER
    mov dx, [num2+2]
    
    ; Imprimir el mensaje del perimetro
    lea dx, msj1
    call imprimir 
    
    ;Imprimir el perimetro calculado
    ; FALTA LA FUNCION PARA PASAR DE NUMERO A ASCII
    
    call areaPent
    
    ret 
    
    perimetroPent endp

areaPent proc  ;num1 = apotema, num2 = perimetro, num3 = lado
    ; antes de llamar a areaPent se tiene que llamar a perimetroPent, para tener el valor de num2  
     
    ; perimetro * apotema
    call productoEntrada1PorEntrada2 ; en este caso apotema*perimetro (num1*num2)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
      
    mov ax, [num2ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num2ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num2ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num2ResL+2] ;QUITAR DESPUES, solo es para verificar
    
    ; dividir entre dos (p*a)/2 
    call divNumDe64bitsEntreDos ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    ; el result queda en [num3ResH]+[num3ResH+2]+[num3ResL]+[num3ResL+2] y la parte fraccional en [num3ResF]
    
    mov ax, [num3ResH] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num3ResH+2] ;QUITAR DESPUES, solo es para verificar
    mov cx, [num3ResL] ;QUITAR DESPUES, solo es para verificar
    mov dx, [num3ResL+2] ;QUITAR DESPUES, solo es para verificar
    mov ax, [num3ResF] ;QUITAR DESPUES, solo es para verifica  
    
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
; PROCEDIMIENTOS GENERALES 

imprimir proc
    mov ah, 09h ; 09h: imprime una cadena, imprime la direcci?n de DX por defecto
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

divNumDe64bitsEntreDos proc ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2] 
    ; el result queda en [num3ResH]+[num3ResH+2]+[num3ResL]+[num3ResL+2] y la parte fraccional en [num3ResF]
    
    xor dx, dx
    mov ax, [num2ResH]
    mov cx, 2 ; AX=cociente, dX=residuo
    div cx
    mov [num3ResH], ax
    cmp dx, 0
    jz acarreo ; si no hay 'acarreo' (cuando DX=0)
    
    ;multiplicar para ajustar 
    mov ax, 8
    mov cx, 1000h
    mul cx ;producto solo en AX
    mov [num3ResH+2], ax  
     
    acarreo: 
        xor dx, dx
        mov ax, [num2ResH+2]
        mov cx, 2 ; AX=cociente, dX=residuo
        div cx
        add [num3ResH+2], ax
        
        cmp dx, 0h
        jz acarreoDos ; si no hay 'acarreo' (cuando DX=0)
        
        ;multiplicar para ajustar 
        mov ax, 8 
        mov cx, 1000h
        mul cx ;producto solo en AX
        mov [num3ResL], ax
         
    acarreoDos:
        xor dx, dx
        mov ax, [num2ResL]
        mov cx, 2 ; AX=cociente, dX=residuo
        div cx
        add [num3ResL], ax  
        
        cmp dx, 0
        jz acarreoTres ; si no hay 'acarreo' (cuando DX=0)
        
        ;multiplicar para ajustar 
        mov ax, 8
        mov cx, 1000h
        mul cx ;producto solo en AX
        mov [num3ResL+2], ax
    
    acarreoTres:
        xor dx, dx
        mov ax, [num2ResL+2]
        mov cx, 2 ; AX=cociente, dX=residuo
        div cx
        add [num3ResL+2], ax
        
        mov bx, [num3ResL+2]
        
        mov [num3ResF], dx
    
    ret
    divNumDe64bitsEntreDos endp
    
  
 
end main  

