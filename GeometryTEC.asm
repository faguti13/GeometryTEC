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
menu_msg db 'Bienvenido a GeometryTec$', 0Dh, 0Ah, '$'
newline db 0Dh, 0Ah, '$'
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
input db ?  

;Mensajes del cuadrado
square_side_msg db 'Por favor ingrese el tama', 0A4h, 'o del lado del cuadrado. $', 0Dh, 0Ah, '$'
square_results_msg db 'El area del cuadrado es: ','',' y su perimetro','','.', 0Dh, 0Ah, '$'

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

    ; Mostrar mensaje pidiendo el tamano del lado
    mov ah, 09h
    lea dx, square_side_msg
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
    lea dx, square_results_msg
    int 21h
    
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
end main