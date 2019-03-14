global    _main
extern _putchar
extern _puts

section   .text
_main:
push rbx
lea rdi, [rel disablecursorstring]
call _puts
pop rbx

mov byte [rel verticalposition], 0
mov byte [rel horizontalposition], 0

render:
call spacefillbuffer
call updateplayerposition
call drawplatforms
call drawplayer
call displayframe



mov rcx, 1000000
delay:
pause
loop delay

jmp render

ret

spacefillbuffer:
lea r10, [rel framebuffer]
lea r11, [rel framebuffer]
add r11, qword [rel framebufferlength]
spacefillloopstart:
mov byte [r10], ' '
inc r10
cmp r10, r11
jl spacefillloopstart
ret

drawplatforms:
lea r10, [rel framebuffer]
lea r11, [rel framebuffer]

movzx r12, byte [rel framewidth]

add r11, r12

drawloop:
mov byte [r10], '-'
inc r10
cmp r10, r11
jl drawloop

ret

displayframe:

lea r10, [rel framebuffer]
lea r11, [rel framebuffer]
add r11, qword [rel framebufferlength]

displayframeloopstart:
movzx rdi, byte [r10]
push r10
push r11
call _putchar
pop r11
pop r10

mov rax, r10
mov rbx, r11
sub rbx, qword [rel framebufferlength]
sub rax, rbx
cmp rax, 0
je increment

movzx rbx, byte [rel framewidth]
inc rax
div rbx
cmp rdx, 0
jne increment

lea rdi, [rel newlinestring]
push r10
push r11
call _puts
pop r11
pop r10

increment:
inc r10
cmp r10, r11
jl displayframeloopstart

lea rdi, [rel resetcursorpositionstring]
call _puts

ret

drawplayer:
lea r10, [rel framebuffer]

movzx rax, word [rel framewidth]
mov r12, qword [rel horizontalposition]
mov r13, qword [rel verticalposition]

mul r13
add rax, r12

mov byte [r10 + rax], 'X'

ret

updateplayerposition:

mov r12, qword [rel horizontalposition]
mov r13, qword [rel verticalposition]
movzx r14, word [rel framewidth]
movzx r15, word [rel frameheight]

cmp r12, r14
jge incrementvertical

inc r12

jmp commitplayerpositionchanges

incrementvertical:
cmp r13, r15
jge resetposition

inc r13
mov r12, 0

jmp commitplayerpositionchanges

resetposition:

mov r12, 0
mov r13, 0

commitplayerpositionchanges:

mov qword [rel verticalposition], r13
mov qword [rel horizontalposition], r12
ret

section   .data
framewidth:     dw    160
frameheight:    dw    48
framebufferlength: dq 7680
newlinestring:  db    0
disablecursorstring: db `\033[?25l`
resetcursorpositionstring: db `\033[H`, 0

section .bss
framebuffer:  resb 7680
verticalposition: resq 1
horizontalposition: resq 1
