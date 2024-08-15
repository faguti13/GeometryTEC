.model small
.stack 100h

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
square_msg db 'Has seleccionado Cuadrado.$', 0Dh, 0Ah, '$'
rectangle_msg db 'Has seleccionado Rectangulo.$', 0Dh, 0Ah, '$'
triangle_msg db 'Has seleccionado Triangulo Equilatero.$', 0Dh, 0Ah, '$'
rhombus_msg db 'Has seleccionado Rombo.$', 0Dh, 0Ah, '$'
pentagon_msg db 'Has seleccionado Pentagono.$', 0Dh, 0Ah, '$'
hexagon_msg db 'Has seleccionado Hexagono.$', 0Dh, 0Ah, '$'
circle_msg db 'Has seleccionado Circulo.$', 0Dh, 0Ah, '$'
trapezoid_msg db 'Has seleccionado Trapecio.$', 0Dh, 0Ah, '$'
parallelogram_msg db 'Has seleccionado Paralelogramo.$', 0Dh, 0Ah, '$'

.code
main proc
    ; Inicializa el segmento de datos
    mov ax, @data
    mov ds, ax

    ; Mostrar mensaje de bienvenida
    mov ah, 09h
    lea dx, menu_msg
    int 21h
    ; Mostrar salto de línea después del mensaje de bienvenida
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Mostrar prompt
    mov ah, 09h
    lea dx, prompt_msg
    int 21h

    ; Mostrar salto de línea antes de las opciones del menú
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Mostrar opciones del menú con saltos de línea
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

    ; Leer opción del usuario
    mov ah, 01h       ; Función para leer un carácter del teclado
    int 21h
    mov bl, al        ; Guardar el carácter leído en BL

    ; Mostrar salto de línea después de leer la opción
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Manejo de opción
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

    ; Opción inválida
    mov ah, 09h
    lea dx, invalid_msg
    int 21h
    ; Salto de línea
    mov ah, 09h
    lea dx, newline
    int 21h
    jmp end_program

square_option:
    mov ah, 09h
    lea dx, square_msg
    int 21h
    jmp end_program

rectangle_option:
    mov ah, 09h
    lea dx, rectangle_msg
    int 21h
    jmp end_program

triangle_option:
    mov ah, 09h
    lea dx, triangle_msg
    int 21h
    jmp end_program

rhombus_option:
    mov ah, 09h
    lea dx, rhombus_msg
    int 21h
    jmp end_program

pentagon_option:
    mov ah, 09h
    lea dx, pentagon_msg
    int 21h
    jmp end_program

hexagon_option:
    mov ah, 09h
    lea dx, hexagon_msg
    int 21h
    jmp end_program

circle_option:
    mov ah, 09h
    lea dx, circle_msg
    int 21h
    jmp end_program

trapezoid_option:
    mov ah, 09h
    lea dx, trapezoid_msg
    int 21h
    jmp end_program

parallelogram_option:
    mov ah, 09h
    lea dx, parallelogram_msg
    int 21h
    jmp end_program

end_program:
    ; Termina el programa
    mov ah, 4Ch
    int 21h
main endp
end main
