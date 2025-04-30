.syntax unified
.cpu cortex-m4
.thumb

.global vtable_kernel
.global __kernel_reset__

/*
 * Вектор переривань для ядра
 */
.section .interrupt_vector
vtable_kernel:
    .word __stack_start         // Адреса стеку
    .word __kernel_reset__ + 1   // Адреса обробника RESET з Thumb-режимом
.size vtable_kernel, .-vtable_kernel

/*
 * Рядки для виводу
 */
.section .rodata
data: .asciz "Kernel started!\n"             // Повідомлення про старт ядра
final: .asciz "Value in register #2: "        // Повідомлення перед числом

/*
 * Основна програма ядра
 */
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line          // Вивести повідомлення "Kernel started!"

    /*
     * Обчислення виразу ((6 & 3) >> 1) + 4!
     */
    push {lr}               // Зберігається LR

    // A & B
    mov r0, #6              // A = 6
    mov r1, #3              // B = 3
    and r2, r0, r1          // R2 = A & B

    // Логічний зсув вправо
    lsr r2, r2, #1          // R2 = (A & B) >> 1

    // Факторіал C
    mov r3, #4              // C = 4
    mov r4, #1              // Початкове значення факторіала
factorial_loop:
    mul r4, r4, r3          // R4 *= C
    subs r3, r3, #1         // C--
    cmp r3, #1
    bgt factorial_loop

    // Додавання результатів
    add r2, r2, r4          // R2 = (A & B) >> 1 + C!

    pop {lr}                // Відновлюється LR

    /*
     * Виведення результату в консоль
     */
    ldr r0, =final
    bl dbgput               // Вивести повідомлення "Value in register #2: "
    mov r0, r2              // Передати результат у r0 для виводу
    bl dbgput_num           // Вивести число

end:
    b end                   // Нескінченний цикл
