.syntax unified
.cpu cortex-m4
.thumb

.global bootload

.section .rodata
image: .incbin "kernel.bin"
end_of_image:

str_boot_start: .asciz "Bootloader started!"
str_boot_end:   .asciz "Bootloader finished!"

.section .text
bootload:
    ldr r0, =str_boot_start    
    bl dbgput_line              // Вивід стартового повідомлення

    ldr r1, =image              // r1 = початок ядра
    ldr r2, =end_of_image       // r2 = кінець ядра
    subs r3, r2, r1             // r3 = розмір у байтах
    mov r6, #1
    lsr r3, r3, r6              // r3 = кількість півслів (розмір / 2)

    ldr r4, =_ram_start         // r4 = база копіювання в RAM
    mov r7, #1                  // регістр для зсуву

loop:
    subs r3, r3, #1
    blt done_copy

    // регістровий зсув: r3 << r7 (тобто *2)
    lsl r5, r3, r7
    ldrh r6, [r1, r5]           // завантажити півслово з образу
    strh r6, [r4, r5]           // записати в RAM

    b loop

done_copy:
    ldr r0, =str_boot_end
    bl dbgput_line

    ldr r2, =_ram_start
    add r2, r2, #4
    ldr r0, [r2]
    bx r0

bootload_end:
    b bootload_end

