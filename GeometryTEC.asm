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

decimal_pos dw 0 ; Posición del punto decimal en la entrada
has_point db 0  ; Flag para indicar si el número tiene punto decimal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    input db 100 dup(0)    ; Buffer para la entrada del usuario
    newline db 13, 10, '$' ; Para imprimir nueva línea
                                                                                                          
    ar_msg db 'El area es de: $'
    per_msg db ' y el perimetro es de: $'
        
    num1 dd ? 
    num2 dd ? 
    num3 dd ?
    num4 dd ?
    num5 dd ?    
            
    num1ResD dw 3 dup(0) ; dw = 4 byte   
    num2ResH dw 3 dup(0) ; para formar una respuesta de 8 bytes 
    num2ResL dw 3 dup(0) ; para formar una respuesta de 8 bytes
    num3ResH dw 3 dup(0) ; para formar una respuesta de 8 bytes 
    num3ResL dw 3 dup(0) ; para formar una respuesta de 8 bytes 
    num3ResF dw 3 dup(0) ; para formar una respuesta de 8 bytes 
    
    bufferResp1 db 10 dup('0'), '$'    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


menu_msg db 'Bienvenido a GeometryTec$', 0Dh, 0Ah, '$'
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

;Mensajes del triangulo
triangle_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del triangulo. $', 0Dh, 0Ah, '$'
triangle_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del triangulo. $', 0Dh, 0Ah, '$'

;Mensajes del rombo
rhombus_hd_msg db 'Por favor ingrese el tama', 0A4h, 'o de la diagonal mayor del rombo. $', 0Dh, 0Ah, '$'
rhombus_ld_msg db 'Por favor ingrese el tama', 0A4h, 'o de la diagonal menor del rombo. $', 0Dh, 0Ah, '$'
rhombus_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del rombo. $', 0Dh, 0Ah, '$'

;Mensajes del pentagono
pentagon_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del pentagono. ', 0Dh, 0Ah, '$'
pentagon_apo_msg db 'Por favor ingrese el tama', 0A4h, 'o de la apotema del pentagono. ', 0Dh, 0Ah, '$'

;Mensajes del hexagono
hexagon_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del hexagono. ', 0Dh, 0Ah, '$'
hexagon_apo_msg db 'Por favor ingrese el tama', 0A4h, 'o de la apotema del hexagono. ', 0Dh, 0Ah, '$'

;Mensajes del circulo
circle_rad_msg db 'Por favor ingrese el tama', 0A4h, 'o del radio del circulo. $', 0Dh, 0Ah, '$'

;Mensajes del trapecio
trapeze_hbase_msg db 'Por favor ingrese el tama', 0A4h, 'o de la base inferior del trapecio. $', 0Dh, 0Ah, '$'
trapeze_lbase_msg db 'Por favor ingrese el tama', 0A4h, 'o de la base superior del trapecio. $', 0Dh, 0Ah, '$'
trapeze_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del trapecio. $', 0Dh, 0Ah, '$'
trapeze_side_msg db 'Por favor ingrese el tama', 0A4h, 'o de los lados laterales del trapecio. $', 0Dh, 0Ah, '$'

;Mensajes del paralelogramo
parallelogram_base_msg db 'Por favor ingrese el tama', 0A4h, 'o de las bases del paralelogramo. $', 0Dh, 0Ah, '$'
parallelogram_height_msg db 'Por favor ingrese el tama', 0A4h, 'o de la altura del paralelogramo. $', 0Dh, 0Ah, '$'
parallelogram_side_msg db 'Por favor ingrese el tama', 0A4h, 'o de los lados laterales del paralelogramo. $', 0Dh, 0Ah, '$'

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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number

    call areaCuadradro
    ; Llama a la función para convertir el número de vuelta a una cadena
    call ar_result_to_string
         
    call perimetroCuadrado
    ; Llama a la función para convertir el número de vuelta a una cadena
    call per_result_to_string

    jmp end_program

rectangle_option:

    ; Mostrar prompt
    mov dx, offset rectangle_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset rectangle_height_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num2
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h


    call areaRect
    ; Llama a la función para convertir el número de vuelta a una cadena
    call ar_result_to_string
         
    call perimetroRect
    ; Llama a la función para convertir el número de vuelta a una cadena
    call per_result_to_string

    jmp end_program
    
triangle_option:

    ; Mostrar prompt
    mov dx, offset triangle_height_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset triangle_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num2
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h


    call areaTriangulo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call tri_ar_result_to_string
    call PrintPointAndNum16 
     
    call perimetroTrian
    ; Llama a la función para convertir el número de vuelta a una cadena
    call per_result_to_string

    jmp end_program

rhombus_option:
 
    ; Mostrar prompt
    mov dx, offset rhombus_hd_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset rhombus_ld_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num2
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset rhombus_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num3
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h


    call areaRombo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call tri_ar_result_to_string
    call PrintPointAndNum16 
     
    call perimetroRombo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call per_result_to_string

    jmp end_program

pentagon_option:

    ; Mostrar prompt
    mov dx, offset pentagon_apo_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset pentagon_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num3
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h

    call perimetroPent

    call areaPent
    ; Llama a la función para convertir el número de vuelta a una cadena
    lea dx, ar_msg
    call imprimir 
    
    call tri_ar_result_to_string
    call PrintPointAndNum16     
    ;call perimetroPent
    ; Llama a la función para convertir el número de vuelta a una cadena
    lea dx, per_msg
    call imprimir 
    call per_result_to_string

    jmp end_program
 
hexagon_option:  

    ; Mostrar prompt
    mov dx, offset hexagon_apo_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset hexagon_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num3
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h

    call perimetroHex

    call areaHex
    ; Llama a la función para convertir el número de vuelta a una cadena
    lea dx, ar_msg
    call imprimir 
    
    call tri_ar_result_to_string
    call PrintPointAndNum16     
    ;call perimetroPent
    ; Llama a la función para convertir el número de vuelta a una cadena
    lea dx, per_msg
    call imprimir 
    call per_result_to_string

    jmp end_program

circle_option:

    ; Mostrar prompt
    mov dx, offset circle_rad_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    call areaCirculo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call cir_ar_result_to_string
         
    call perimetroCirculo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call per_result_to_string

    
    ;jmp end_program

trapezoid_option: 

; Mostrar prompt
    mov dx, offset trapeze_height_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset trapeze_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num3
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset trapeze_hbase_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num4
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset trapeze_lbase_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num5
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h

    
    call perimetroTrapecio

    call areaTrapecio
    ; Llama a la función para convertir el número de vuelta a una cadena
    ;lea dx, ar_msg
    ;call imprimir 
    
    call tri_ar_result_to_string
    call PrintPointAndNum16     
    ;call perimetroPent
    ; Llama a la función para convertir el número de vuelta a una cadena
    lea dx, per_msg
    call imprimir 
    call tra_per_result_to_string

    jmp end_program

parallelogram_option:

    ; Mostrar prompt
    mov dx, offset parallelogram_height_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num1
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset parallelogram_base_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num2
    call ascii_to_number

    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Mostrar prompt
    mov dx, offset parallelogram_side_msg
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

    ; Convertir la cadena a número y guardar en num1
    lea si, input + 2
    lea di, num3
    call ascii_to_number
    
    mov ah, 09h
    lea dx, newline
    int 21h


    call areaParalelogramo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call ar_result_to_string
     
    call perimetroParalelogramo
    ; Llama a la función para convertir el número de vuelta a una cadena
    call par_per_result_to_string
               
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
    
    mov word ptr num3ResH, ax ; Almacena 0 en los primeros 2 bytes de num1ResD
    mov word ptr num3ResH+2, ax ; Almacena 0 en los últimos 2 bytes de num1ResD

    mov word ptr num3ResL, ax ; Almacena 0 en los primeros 2 bytes de num2ResH
    mov word ptr num3ResL+2, ax ; Almacena 0 en los últimos 2 bytes de num2ResH

    mov word ptr num3ResF, ax ; Almacena 0 en los primeros 2 bytes de num2ResL
    mov word ptr num3ResF+2, ax ; Almacena 0 en los últimos 2 bytes de num2ResL
        
    ; Resetear la posición del punto decimal
    mov byte ptr [decimal_pos], 0
    
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

; CALCULO DE AREA Y PERIEMTRO DE TODAS LAS FIGURAS GEOMETRICAS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;1. CUADRADO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
    lea dx, per_msg
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
    lea dx, ar_msg
    call imprimir
    
    ret
    areaCuadradro endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2. RECTANGULO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

perimetroRect proc ; num1= base, num2= altura
    
    call DosVecesNum1MasNum2
    
    ; El resultado ya está en num1ResD y num1ResD+2
    
    mov ax, [num1ResD] ;QUITAR DESPUES, solo es para verificar
    mov bx, [num1ResD+2] ;QUITAR DESPUES, solo es para verificar
    
    ; Imprimir el mensaje del perímetro
    lea dx, per_msg
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
    lea dx, ar_msg
    call imprimir
       
    ret
    areaRect endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3. TRIANGULO num1= altura, num2= lado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
    lea dx, per_msg
    call imprimir 
    
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
    
    ; Imprimir el mensaje del area
    lea dx, ar_msg
    call imprimir
    
    ret
    areaTriangulo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; 4. ROMBO; num1= diagonal mayor, num2= diagonal menor, num3 = a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
    lea dx, per_msg
    call imprimir 
    
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
    
    ; Imprimir el mensaje del perimetro
    lea dx, ar_msg
    call imprimir 
    
    ret
    areaRombo endp 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; 5. Pentagono num1 = apotema, num2 = perimetro, num3 = lado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
; 6. Hexagono num1 = apotema, num2 = perimetro, num3 = lado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
; 7. CIRCULO  num1 = radio
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
    
    ; Imprimir el mensaje del area
    lea dx, per_msg
    call imprimir
    
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
    lea dx, ar_msg
    call imprimir
    
    ret
    areaCirculo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; 8. Trapecio; num1= altura, num2= (B+b);  num3= lado; num4= base mayor, num5= base menor 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
    lea dx, ar_msg
    call imprimir

    mov [num2ResH], 0  ;se necesita en 0 para el result del area 
    mov [num2ResH+2], 0      
        
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
;9. PARALELOGRAMO  num1=h, num2=base , num3=a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

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
    lea dx, per_msg
    call imprimir
           
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
    
    ; Imprimir el mensaje del area
    lea dx, ar_msg
    call imprimir
    
    ret
    areaParalelogramo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PROCEDIMIENTOS GENERALES 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

DosVecesNum1MasNum2 proc ; num1= base, num2= altura
    
    ;parte baja base + parte baja altura  (b+h)
    mov ax, word ptr [num1]
    mov bx, word ptr [num2]
    xor cx, cx ; preparar para el acarreo 
    add ax, bx 
    ;manejar el acarreo. ADC (Add with Carry): suma dos operandos junto con el valor del flag de acarreo (CF).
    adc cx, 0       ; CX = 1 si CF = 1, CX = 0 si CF = 0
    mov [num1ResD+2], ax  ;parte baja 
    mov [num1ResD], cx  ;parte alta   
    
    ;parte alta base + parte alta altura  (b+h) 
    mov ax, word ptr [num1+2]
    mov cx, word ptr [num2+2]
    add ax, cx    
    add [num1ResD], ax  ;parte alta 
    
    ;parte baja * 2;  2*(b+h)
    mov ax, word ptr [num1ResD+2]
    mov cx, 2
    mul cx ; queda en DX:AX 
    mov [num1ResD+2], ax  
    mov bx, dx  
    
    ;parte alta * 2;  2*(b+h)
    mov ax, word ptr [num1ResD]
    mov cx, 2
    mul cx ; queda en DX:AX 
    add ax, bx
    mov [num1ResD], ax 
    
    ret
    DosVecesNum1MasNum2 endp  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

divNumDe64bitsEntreDos proc
    ; divide entre dos el num [num2ResH]+[num2ResH+2]+[num2ResL]+[num2ResL+2] 
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
        
        cmp dx, 0      
        je noDec   
        mov [num3ResF], 5 ; solo si DX es 1
                
        noDec:
            ret
    
    ret
    divNumDe64bitsEntreDos endp    

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

; Función para imprimir número de 48 bits con punto decimal y dígitos fraccionales
ar_result_to_string proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Limpiar el búfer de salida
    lea di, input
    mov cx, 100
    mov al, 0
    rep stosb
    
    ; Reiniciar DI al inicio del búfer
    lea di, input
    mov cx, 15

    ; Cargar el valor de result (48 bits)
    mov ax, word ptr [num2ResL+2]
    mov bx, word ptr [num2ResL]
    mov dx, word ptr [num2ResH+2]

    ; Guardar la posición inicial de la pila
    mov si, sp

    ; Contador para los dígitos
    xor bp, bp

ar_convert_to_string:
    ; Dividir el número de 48 bits por 10
    push cx
    mov cx, 10
    call div48
    pop cx

    ; Convertir el residuo en un carácter y guardarlo
    add di, '0'
    push di

    ; Incrementar el contador de dígitos
    inc bp

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

    ; Determinar la posición del punto decimal
    mov cx, [decimal_pos]
    shl cx, 1  ; Multiplicar por 2 para el resultado del área

    ; Si no hay dígitos fraccionales, no imprimimos el punto
    cmp cx, 0
    je ar_no_decimal

    ; Calcular la posición del punto decimal desde la derecha
    mov dx, bp  ; DX ahora contiene el número total de dígitos
    sub dx, cx  ; DX ahora contiene la posición del punto desde la derecha

    ; Contador para la posición actual
    xor bp, bp

ar_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je ar_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax

    ; Verificar si necesitamos insertar el punto decimal
    cmp bp, dx
    jne ar_no_decimal_point

    ; Insertar el punto decimal
    mov byte ptr [di], '.'
    inc di

ar_no_decimal_point:
    mov [di], al  ; Colocar el dígito en el búfer de salida
    inc di
    inc bp
    jmp ar_print_result_string

ar_no_decimal:
    ; Imprimir todos los dígitos sin punto decimal
    pop ax
    mov [di], al
    inc di
    cmp sp, si
    jne ar_no_decimal

ar_finish_string:
    ; Añadir terminador de cadena
    mov byte ptr [di], '$'

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
cir_ar_result_to_string proc
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
    mov ax, word ptr [num3ResL+2]
    mov bx, word ptr [num3ResL]
    mov dx, word ptr [num3ResL-4]

    ; Guardar la posición inicial de la pila
    mov si, sp

cir_ar_convert_to_string:
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
    jnz cir_ar_continue_conversion
    or bx, bx
    jnz cir_ar_continue_conversion
    or dx, dx
    jz cir_ar_done_conversion

cir_ar_continue_conversion:
    loop cir_ar_convert_to_string

cir_ar_done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

cir_ar_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je ar_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp cir_ar_print_result_string

cir_ar_finish_string:

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
cir_ar_result_to_string endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


; Funcion para printear area
tri_ar_result_to_string proc
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
    mov ax, word ptr [num3ResL+2]
    mov bx, word ptr [num3ResL]
    mov dx, word ptr [num3ResL-4]

    ; Guardar la posición inicial de la pila
    mov si, sp

tri_ar_convert_to_string:
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
    jnz tri_ar_continue_conversion
    or bx, bx
    jnz tri_ar_continue_conversion
    or dx, dx
    jz tri_ar_done_conversion

tri_ar_continue_conversion:
    loop tri_ar_convert_to_string

tri_ar_done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

tri_ar_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je tri_ar_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp tri_ar_print_result_string

tri_ar_finish_string:

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
tri_ar_result_to_string endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

; Funcion para printear area
tra_per_result_to_string proc
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
    mov ax, word ptr [num1ResD]
    mov bx, word ptr [num1ResD+2]
    mov dx, 0
    ; Guardar la posición inicial de la pila
    mov si, sp

tra_per_convert_to_string:
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
    jnz tra_per_continue_conversion
    or bx, bx
    jnz tra_per_continue_conversion
    or dx, dx
    jz tra_per_done_conversion

tra_per_continue_conversion:
    loop tra_per_convert_to_string

tra_per_done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

tra_per_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je tra_per_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp tra_per_print_result_string

tra_per_finish_string:

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
tra_per_result_to_string endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

; Funcion para printear area
par_per_result_to_string proc
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
    mov ax, word ptr [num2ResH+2]
    mov bx, word ptr [num2ResH]
    mov dx, 0
    ; Guardar la posición inicial de la pila
    mov si, sp

par_per_convert_to_string:
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
    jnz par_per_continue_conversion
    or bx, bx
    jnz par_per_continue_conversion
    or dx, dx
    jz par_per_done_conversion

par_per_continue_conversion:
    loop par_per_convert_to_string

par_per_done_conversion:
    ; Ahora, DI apunta al final de la cadena invertida
    ; Mover DI al inicio del búfer de salida
    lea di, input

par_per_print_result_string:
    ; Verificar si hemos procesado todos los caracteres
    cmp sp, si
    je par_per_finish_string

    ; Obtener el siguiente carácter (en orden inverso)
    pop ax
    mov [di], al  ; Colocarlo en el búfer de salida
    inc di
    jmp par_per_print_result_string

par_per_finish_string:
    ; Insertar el punto decimal
    ;call insert_decimal_point

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
par_per_result_to_string endp


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
; Funcion para dividir un numero de 48 bits por 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Procedimiento para convertir una cadena ASCII a numero
; Entrada: SI apunta al inicio de la cadena
;          DI apunta a la direccion de memoria donde guardar el resultado (6 bytes)
; Salida: El numero convertido se almacena en la direccion apuntada por DI (6 bytes)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

ascii_to_number proc
    push ax
    push bx
    push cx
    push dx
    push si

    ; Inicializar el resultado a 0
    mov word ptr [di], 0
    mov word ptr [di+2], 0
    mov word ptr [di+4], 0

    mov word ptr [decimal_pos], 0  ; Inicializar la posición decimal
    mov byte ptr [has_point], 0  ; Inicializar flag de punto decimal
    xor bx, bx  ; BX será nuestro contador de dígitos fraccionarios

convert_loop:
    ; Cargar el siguiente carácter
    lodsb  ; Carga un byte de [SI] en AL y aumenta SI

    ; Verificar si hemos llegado al final de la cadena
    cmp al, 0
    je done_conversion

    ; Verificar si el carácter es un punto decimal    
    cmp al, '.'
    jne not_decimal_point
    mov byte ptr [has_point], 1  ; Marcar que hemos encontrado un punto
    jmp next_char

not_decimal_point:
    ; Convertir ASCII a número
    sub al, '0'

    ; Multiplicar el resultado actual por 10
    push ax
    mov ax, 10
    call mul48_di
    pop ax

    ; Sumar el nuevo dígito
    xor ah, ah
    add [di], ax
    adc word ptr [di+2], 0
    adc word ptr [di+4], 0
    
    ; Incrementar el contador de dígitos decimales si ya pasamos el punto
    cmp byte ptr [has_point], 1
    jne next_char
    inc bx  ; Incrementar el contador de dígitos fraccionarios


next_char:
    inc cx
    jmp convert_loop

done_conversion:
    ; Si hubo punto decimal, calcular los dígitos después del punto
    cmp byte ptr [has_point], 1
    jne no_decimal_point
    sub cx, word ptr [decimal_pos]  ; cx ahora contiene el número de dígitos después del punto
    dec cx  ; Restar 1 para no contar el punto mismo
    mov word ptr [decimal_pos], bx  ; Guardar el número de dígitos fraccionarios
    
no_decimal_point:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ascii_to_number endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Versión modificada de mul48 que usa DI como puntero al resultado
mul48_di proc
    push bx
    push cx
    push dx

    mov bx, ax  ; Guardar el multiplicador

    mov ax, word ptr [di]
    mul bx
    mov word ptr [di], ax
    mov cx, dx

    mov ax, word ptr [di+2]
    mul bx
    add ax, cx
    mov word ptr [di+2], ax
    adc dx, 0
    mov cx, dx

    mov ax, word ptr [di+4]
    mul bx
    add ax, cx
    mov word ptr [di+4], ax

    pop dx
    pop cx
    pop bx
    ret
mul48_di endp

PrintPointAndNum16:
    ; Imprimir el punto
    mov dl, '.'
    mov ah, 02h
    int 21h

    ; Cargar el valor de 16 bits de num3ResF
    mov ax, [num3ResF]

    ; Imprimir el número (asumiendo que es un valor de 0 a 9999)
    call PrintAXAsDecimal

    ret

PrintAXAsDecimal:
    ; Este subproceso convierte y imprime el valor en AX como un número decimal de hasta 5 dígitos

    ; Dividir AX por 10000
    mov cx, 10000
    xor dx, dx
    div cx
    ; Imprimir dígito (si no es cero)
    cmp ax, 0
    je SkipTenThousands
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
SkipTenThousands:

    ; Dividir el resto por 1000
    mov ax, dx
    mov cx, 1000
    xor dx, dx
    div cx
    ; Imprimir dígito (si no es cero)
    cmp ax, 0
    je SkipThousands
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
SkipThousands:

    ; Dividir el resto por 100
    mov ax, dx
    mov cx, 100
    xor dx, dx
    div cx
    ; Imprimir dígito (si no es cero)
    cmp ax, 0
    je SkipHundreds
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
SkipHundreds:

    ; Dividir el resto por 10
    mov ax, dx
    mov cx, 10
    xor dx, dx
    div cx
    ; Imprimir dígito (si no es cero)
    cmp ax, 0
    je SkipTens
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
SkipTens:

    ; Imprimir la unidad
    mov ax, dx
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    ret
end main