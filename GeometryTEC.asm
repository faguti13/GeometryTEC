;    ******************************************************************************************************************************
;	 Instituto Tecnologico de Costa Rica
;    Ingenieria en Computadores
;    Curso: CE1106 Paradigmas de programacion
;    Lenguaje: Ensamblador 8086
;    Primer tarea programada, GeometryTEC
;    Programadores: Fabian Gutierrez Jimenez, Emmanuel Calvo Mora, Asly Barahona Maroto y Joaquin Ramirez Sequeira
;    Version: 1.0
;    Descripcion: App que permita calcular el area y perimetro de las principales figuras geometricas:
;    Cuadrado, Rectangulo, Triangulo, Rombo, Pentagono, Hexagono, Circulo, Trapecio y Paralelogramo.
;    El rango de numeros a utilizar es de 0 a 9999.99 
;    ******************************************************************************************************************************

.model small
.stack 100h

;Segmento de datos
.data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    input db 100 dup(0)    ; Buffer para la entrada del usuario
    newline db 13, 10, '$' ; Para imprimir nueva línea
                                                                                                          
    msj1 db ' y el perimetro es de: $'
    msj2 db 'El area es de: $'
    
    num1 dd ? 
    num2 dd ? 
    num3 dd ?    
            
    num1ResD dw 3 dup(0) ; dw = 4 byte   
    num2ResH dw 3 dup(0) ; para formar una respuesta de 8 bytes 
    num2ResL dw 3 dup(0) ; para formar una respuesta de 8 bytes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


menu_msg db 'Bienvenido a GeometryTec$', 0Dh, 0Ah, '$'
;newline db 0Dh, 0Ah, '$'
prompt_msg db 'Por favor indique a que figura desea calcular su area y perimetro:$', 0Dh, 0Ah, '$'
option1 db '1. Para Cuadrado.$', 0Dh, 0Ah, '$'
option2 db '2. Para Rectangulo.$', 0Dh, 0Ah, '$'
option3 db '3. Para Triangulo Equilatero.$', 0Dh, 0Ah, '$'
option4 db '4. Para Rombo.$', 0Dh, 0Ah, '$'
option5 db '5. Para Pentagono.$', 0Dh, 0Ah, '$'
option6 db '6. Para Hexagono.$', 0Dh, 0Ah, '$'
option7 db '7. Para Circulo.$', 0Dh, 0Ah, '$'
option8 db '8. Para Trapecio.$', 0Dh, 0Ah, '$'
option9 db '9. Para Paralelogramo.$', 0Dh, 0Ah, '$'
invalid_msg db 'Opcion invalida. Por favor seleccione una opcion valida.$', 0Dh, 0Ah, '$'

; Mensajes para opciones seleccionadas
      
;Buffer y entrada
buffer db 8
;input db ?  

;Mensajes del cuadrado
square_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del cuadrado. $', 0Dh, 0Ah, '$'

;Mensajes del rectangulo
rectangle_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del rectangulo. $', 0Dh, 0Ah, '$'
rectangle_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del rectangulo. $', 0Dh, 0Ah, '$'
rectangle_results_msg db 'El area del rectangulo es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del triangulo
triangle_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del triangulo. $', 0Dh, 0Ah, '$'
triangle_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del triangulo. $', 0Dh, 0Ah, '$'
triangle_results_msg db 'El area del triangulo es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del rombo
rhombus_hd_msg db 'Por favor ingrese el tama', 0A4h, 'o de la diagonal mayor del rombo. $', 0Dh, 0Ah, '$'
rhombus_ld_msg db 'Por favor ingrese el tama', 0A4h, 'o de la diagonal menor del rombo. $', 0Dh, 0Ah, '$'
rhombus_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del rombo. $', 0Dh, 0Ah, '$'
rhombus_results_msg db 'El area del rombo es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del pentagono
pentagon_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del pentagono. ', 0Dh, 0Ah, '$'
pentagon_apo_msg db 'Por favor ingrese el tama', 0A4h, 'o de la apotema del pentagono. ', 0Dh, 0Ah, '$'
pentagon_results_msg db 'El area del pentagono es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del hexagono
hexagon_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del hexagono. ', 0Dh, 0Ah, '$'
hexagon_apo_msg db 'Por favor ingrese el tama', 0A4h, 'o de la apotema del hexagono. ', 0Dh, 0Ah, '$'
hexagon_results_msg db 'El area del hexagono es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del circulo
circle_rad_msg db 'Por favor ingrese el tama', 0A4h, 'o del radio del circulo. $', 0Dh, 0Ah, '$'
circle_results_msg db 'El area del circulo es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del trapecio
trapeze_hbase_msg db 'Por favor ingrese el tama', 0A4h, 'o de la base inferior del trapecio. $', 0Dh, 0Ah, '$'
trapeze_lbase_msg db 'Por favor ingrese el tama', 0A4h, 'o de la base superior del trapecio. $', 0Dh, 0Ah, '$'
trapeze_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del trapecio. $', 0Dh, 0Ah, '$'
trapeze_side_msg db 'Por favor ingrese el tama', 0A4h, 'o de los lados laterales del trapecio. $', 0Dh, 0Ah, '$'
trapeze_results_msg db 'El area del trapecio es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Mensajes del paralelogramo
parallelogram_base_msg db 'Por favor ingrese el tama', 0A4h, 'o de las bases del paralelogramo. $', 0Dh, 0Ah, '$'
parallelogram_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del paralelogramo. $', 0Dh, 0Ah, '$'
parallelogram_side_msg db 'Por favor ingrese el tama', 0A4h, 'o de los lados laterales del paralelogramo. $', 0Dh, 0Ah, '$'
parallelogram_results_msg db 'El area del paralelogramo es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

;Menu para continuar o salir    
continue_msg db 'Por favor presione:$', 0Dh, 0Ah, '$'
option_continue db '1. Para Continuar.$', 0Dh, 0Ah, '$'
option_exit db '2. Para Salir.$', 0Dh, 0Ah, '$'
thanks_msg db 'Gracias por utilizar GeometryTec.', 0Dh, 0Ah, '$'


.code
main proc
    ; Inicializa el segmento de datos
    mov ax, @data
    mov ds, ax  
    
    ; Mostrar mensaje de bienvenida
    mov ah, 09h
    lea dx, menu_msg
    int 21h
start:

    ; Mostrar salto de linea despues del mensaje de bienvenida
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Mostrar prompt
    mov ah, 09h
    lea dx, prompt_msg
    int 21h

    ; Mostrar salto de linea antes de las opciones del menú
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Mostrar opciones del menu con saltos de linea
    mov ah, 09h
    lea dx, option1
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option2
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option3
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option4
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option5
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option6
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option7
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option8
    int 21h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, option9
    int 21h
    lea dx, newline
    int 21h

    ; Leer opcion del usuario
    mov ah, 01h       ; Funcion para leer un carácter del teclado
    int 21h
    mov bl, al        ; Guardar el caracter leido en BL

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Manejo de opcion
    cmp bl, '1'
    je square_option
    cmp bl, '2'
    je rectangle_option
    cmp bl, '3'
    je triangle_option
    cmp bl, '4'
    je rhombus_option
    cmp bl, '5'
    je pentagon_option
    cmp bl, '6'
    je hexagon_option
    cmp bl, '7'
    je circle_option
    cmp bl, '8'
    je trapezoid_option
    cmp bl, '9'
    je parallelogram_option

    ; Opcion invalida
    mov ah, 09h
    lea dx, invalid_msg
    int 21h
    ; Salto de linea
    mov ah, 09h
    lea dx, newline
    int 21h
    je start

square_option:

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
    mov word ptr [num1], 0
    mov word ptr [num1+2], 0
    mov word ptr [num1+4], 0

    ; Apuntar al inicio de la cadena de entrada
    lea si, input + 2
    xor cx, cx  ; Contador de iteraciones

convert_loop:
    ; Imprimir número de iteración
    inc cx
    push cx
    ;mov dx, offset debug_msg
    mov ah, 9
    ;int 21h
    pop cx
    mov ax, cx
    ;call print_number
    ;call print_newline

    ; Cargar el siguiente carácter
    mov al, [si]
    
    ; Verificar si hemos llegado al final de la cadena
    cmp al, 0
    je done

    ; Verificar si el carácter es un punto decimal    
    cmp al, '.'
    jne not_decimal_point
    inc cl
    jmp skip_dot

not_decimal_point:    
    ;je skip_dot

    ; Convertir ASCII a número
    sub al, '0'

    ; Multiplicar el resultado actual por 10
    push ax
    mov ax, 10
    call mul48
    pop ax

    ; Sumar el nuevo dígito
    xor ah, ah
    add [num1], ax
    adc word ptr [num1+2], 0
    adc word ptr [num1+4], 0

    ; Imprimir el valor actual
    ;call print_result

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

    jmp end_program


rectangle_option:

    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, rectangle_side_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, rectangle_height_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; calculos

    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, rectangle_results_msg
    int 21h
        
    jmp end_program
 
 
triangle_option:

    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, triangle_side_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, triangle_height_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, triangle_results_msg
    int 21h
        
    jmp end_program

rhombus_option:
 
    ; Mostrar mensaje pidiendo la diagonal mayor
    mov ah, 09h
    lea dx, rhombus_hd_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, rhombus_ld_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, rhombus_side_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
   
    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, rhombus_results_msg
    int 21h
    
    jmp end_program

pentagon_option:

    ; Mostrar mensaje pidiendo el lado del pentagono
    mov ah, 09h
    lea dx, pentagon_side_msg
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano de la apotema
    mov ah, 09h
    lea dx, pentagon_apo_msg
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
   
    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, pentagon_results_msg
    int 21h
    
    jmp end_program

hexagon_option:  

    ; Mostrar mensaje pidiendo el lado
    mov ah, 09h
    lea dx, hexagon_side_msg
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano de la apotema
    mov ah, 09h
    lea dx, hexagon_apo_msg
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
   
    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, hexagon_results_msg
    int 21h
    
    jmp end_program

circle_option:

    ; Mostrar mensaje pidiendo el tamano del radio
    mov ah, 09h
    lea dx, circle_rad_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h 

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h

    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, circle_results_msg
    int 21h
    
    jmp end_program

trapezoid_option: 

    ; Mostrar mensaje pidiendo la base superior del trapecio
    mov ah, 09h
    lea dx, trapeze_hbase_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo la base inferior del trapecio
    mov ah, 09h
    lea dx, trapeze_lbase_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano de la altura
    mov ah, 09h
    lea dx, trapeze_height_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, trapeze_side_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
   
    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, trapeze_results_msg
    int 21h
    
    jmp end_program

parallelogram_option:

    ; Mostrar mensaje pidiendo la base
    mov ah, 09h
    lea dx, parallelogram_base_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h 
                 
    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo la altura
    mov ah, 09h
    lea dx, parallelogram_height_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
                 
    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, parallelogram_side_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Leer input del usuario
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Mostrar salto de linea despues de leer la opcion
    mov ah, 09h
    lea dx, newline
    int 21h
   
    ; calculos
    
    ; Mostrar mensaje de los resultados
    mov ah, 09h
    lea dx, parallelogram_results_msg
    int 21h
    
    jmp end_program

end_program:

    ; Asumimos que estas variables están definidas en la sección .data
    ; num1ResD, num2ResH, num2ResL se inicializarán a 0

    mov ax, 0       ; Carga 0 en AX
    mov word ptr num1ResD, ax ; Almacena 0 en los primeros 2 bytes de num1ResD
    mov word ptr num1ResD+2, ax ; Almacena 0 en los últimos 2 bytes de num1ResD

    mov word ptr num2ResH, ax ; Almacena 0 en los primeros 2 bytes de num2ResH
    mov word ptr num2ResH+2, ax ; Almacena 0 en los últimos 2 bytes de num2ResH

    mov word ptr num2ResL, ax ; Almacena 0 en los primeros 2 bytes de num2ResL
    mov word ptr num2ResL+2, ax ; Almacena 0 en los últimos 2 bytes de num2ResL
    
    
    ;salto de linea
    mov ah, 09h
    lea dx, newline
    int 21h 
    
    ; Mostrar opciones de continuar o salir
    mov ah, 09h
    lea dx, continue_msg
    int 21h  
    
    ;salto de linea
    mov ah, 09h
    lea dx, newline
    int 21h 

    mov ah, 09h
    lea dx, option_continue
    int 21h
    
    ;salto de linea
    mov ah, 09h
    lea dx, newline
    int 21h 

    mov ah, 09h
    lea dx, option_exit
    int 21h
    
    ;salto de linea
    mov ah, 09h
    lea dx, newline
    int 21h 
    
    ; Leer opcion del usuario
    mov ah, 01h       ; Funcion para leer un caracter del teclado
    int 21h
    mov bl, al        ; Guardar el caracter leido en BL

    ; Manejar opcion seleccionada
    cmp bl, '1'
    je start           ; Si presiona '1', volver al menu inicial
    cmp bl, '2'
    mov ah, 09h
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    lea dx, thanks_msg
    int 21h
    je exit_program   ; Si presiona '2', salir del programa

    ; Opcion invalida, volver a preguntar
    jmp end_program

exit_program:
    ; Termina el programa
    mov ah, 4Ch
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
        
    ret 
    perimetroCuadrado endp

areaCuadradro proc ; num1 = lado
    
    call productoEntrada1PorEntrada1 ; en este caso lado*lado (num1*num1)
    ;el resultado queda en [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2]
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    
    ; Imprimir el mensaje del area
    lea dx, msj2
    call imprimir
    
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


; Función para multiplicar el resultado de 48 bits por AX
mul48 proc
    push bx
    push cx
    push dx

    mov bx, ax  ; Guardar el multiplicador

    mov ax, word ptr [num1]
    mul bx
    mov word ptr [num1], ax
    mov cx, dx

    mov ax, word ptr [num1+2]
    mul bx
    add ax, cx
    mov word ptr [num1+2], ax
    adc dx, 0
    mov cx, dx

    mov ax, word ptr [num1+4]
    mul bx
    add ax, cx
    mov word ptr [num1+4], ax

    pop dx
    pop cx
    pop bx
    ret
mul48 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


; Funcion para printear area
ar_result_to_string proc
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
    mov ax, word ptr [num2ResL+2]
    mov bx, word ptr [num2ResL]
    mov dx, word ptr [num2ResL-4]

    ; Guardar la posición inicial de la pila
    mov si, sp

ar_convert_to_string:
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
    jnz ar_continue_conversion
    or bx, bx
    jnz ar_continue_conversion
    or dx, dx
    jz ar_done_conversion

ar_continue_conversion:
    loop ar_convert_to_string

ar_done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

ar_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je ar_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp ar_print_result_string

ar_finish_string:
    
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
ar_result_to_string endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


; Funcion para printear area
per_result_to_string proc
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
    mov ax, word ptr [num1ResD+2]
    mov bx, word ptr [num1ResD]
    mov dx, 0
    ; Guardar la posición inicial de la pila
    mov si, sp

per_convert_to_string:
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
    jnz per_continue_conversion
    or bx, bx
    jnz per_continue_conversion
    or dx, dx
    jz per_done_conversion

per_continue_conversion:
    loop per_convert_to_string

per_done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

per_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je per_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp per_print_result_string

per_finish_string:
    
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
per_result_to_string endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

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

end main
