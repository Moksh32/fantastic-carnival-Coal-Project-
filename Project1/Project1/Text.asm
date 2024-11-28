INCLUDE Irvine32.inc

.data
    board DWORD 100 DUP(0)
    check DWORD 100
    count DWORD 0
    remender DWORD ?
    dice DWORD ?
    player1_score DWORD 0
    player2_score DWORD 0
    prompt_player1 BYTE "Player 1's turn: ", 0
    prompt_player2 BYTE "Player 2's turn: ", 0
    newline BYTE 0Dh, 0Ah, 0
    snake_positions DWORD 20, 40, 60, 80, 90
    snake_endpoints DWORD 5, 15, 30, 55, 10
    ladder_positions DWORD 3, 12, 28, 45, 70
    ladder_endpoints DWORD 22, 34, 60, 75, 85
    snake_count DWORD 5
    ladder_count DWORD 5

    win_message BYTE "Player 1 wins the game!", 0
    player2_win_message BYTE "Player 2 wins the game!", 0

.code
main PROC
    call InitializeBoard
    call PrintBoard
    call turns
    exit
main ENDP

InitializeBoard PROC
    mov ebx, 100
    lea esi, board
    mov ecx, 100
fill_board:
    mov [esi], ebx
    add esi, 4
    dec ebx
    loop fill_board
    ret
InitializeBoard ENDP

PrintBoard PROC
    mov ecx, 10
    lea ebx, board
    mov edx, 0
print_row:
    mov eax, [ebx]
    call WriteDec
    cmp eax, 9
    jle l0
    cmp eax, 100
    je l100
    cmp eax, check
    jne l90
    mov al, ' '
    call WriteChar
l100:
l90:
    mov al, ' '
    call WriteChar
    add ebx, 4
    inc edx
    cmp edx, 10
    je print_newline
    jmp print_row
l0:
    mov al, ' '
    call WriteChar
    call WriteChar
    add ebx, 4
    inc edx
    cmp edx, 10
    je print_newline
    jmp print_row

print_newline:
    mov eax, check
    sub eax, 10
    mov check, eax
    call CrLf
    mov edx, 0
    loop print_row
    ret
PrintBoard ENDP

check_snakes PROC
    lea ebx, snake_positions
    lea ecx, snake_endpoints
    mov edx, [player1_score]

    mov esi, 5

check_loop_player1:
    mov eax, [ebx]
    cmp edx, eax
    je move_player1
    add ebx, 4
    add ecx, 4
    dec esi
    jnz check_loop_player1
    ret

move_player1:
    mov eax, [ecx]
    mov [player1_score], eax
    ret
check_snakes endp

check_ladders PROC
    lea ebx, ladder_positions
    lea ecx, ladder_endpoints
    mov edx, [player1_score]

    mov esi, 5

check_loop_player1_ladders:
    mov eax, [ebx]
    cmp edx, eax
    je move_player1_ladder
    add ebx, 4
    add ecx, 4
    dec esi
    jnz check_loop_player1_ladders
    ret

move_player1_ladder:
    mov eax, [ecx]
    mov [player1_score], eax
    ret
check_ladders endp

check_snakes_end PROC
    lea ebx, snake_positions
    lea ecx, snake_endpoints
    mov edx, [player2_score]

    mov esi, 5

check_loop_player2:
    mov eax, [ebx]
    cmp edx, eax
    je move_player2
    add ebx, 4
    add ecx, 4
    dec esi
    jnz check_loop_player2
    ret

move_player2:
    mov eax, [ecx]
    mov [player2_score], eax
    ret
check_snakes_end endp

check_ladders_end PROC
    lea ebx, ladder_positions
    lea ecx, ladder_endpoints
    mov edx, [player2_score]

    mov esi, 5

check_loop_player2_ladders:
    mov eax, [ebx]
    cmp edx, eax
    je move_player2_ladder
    add ebx, 4
    add ecx, 4
    dec esi
    jnz check_loop_player2_ladders
    ret

move_player2_ladder:
    mov eax, [ecx]
    mov [player2_score], eax
    ret
check_ladders_end endp

turns PROC
    inc count

    mov eax, count
    mov ebx, 2
    mov edx,0
    div ebx

    cmp edx, 0
    je user_1

    jmp user_2

user_1:
mov eax, 13
call settextcolor
 
	mov edx, offset prompt_player1
    call WriteString
    call Randomize
    mov eax, 6
    call RandomRange
    add eax, 1
    mov [dice], eax
    call WriteInt
    call CrLf

  
    mov eax, [player1_score]
    add eax, [dice]
    cmp eax, 100
    ja exceed_limit_user1    
    cmp eax, 100
    je win_user1           

    mov eax, [dice]
    add [player1_score], eax

    call check_snakes
    call check_ladders

    mov eax, [player1_score]
    mov ebx, [player2_score]
    cmp eax, ebx
    jne continue_user1
  
    mov dword ptr [player2_score], 0

continue_user1:
    mov eax, [player1_score]
    call WriteInt
    call CrLf
    call WaitMsg
    jmp turns

exceed_limit_user1:
 
    mov eax, [player1_score]
    call WriteInt
    call CrLf
    call WaitMsg
    jmp turns

win_user1:
    mov edx, offset newline
    call WriteString
    mov edx, offset prompt_player1
    call WriteString
    call WriteDec  
    call CrLf
    mov edx, offset newline
    call WriteString
    mov edx, offset win_message 
    call WriteString            
    call CrLf
    jmp end_game




user_2:
push eax
mov eax, 14
call settextcolor
pop eax
    mov edx, offset prompt_player2
    call WriteString
    call Randomize
    mov eax, 6
    call RandomRange
    add eax, 1
    mov [dice], eax
    call WriteInt
    call CrLf


    mov eax, [player2_score]
    add eax, [dice]
    cmp eax, 100
    ja exceed_limit_user2   
    cmp eax, 100
    je win_user2             

   
    mov eax, [dice]
    add [player2_score], eax

    call check_snakes_end
    call check_ladders_end

   
    mov eax, [player2_score]
    mov ebx, [player1_score]
    cmp eax, ebx
    jne continue_user2
   
    mov dword ptr [player1_score], 0

continue_user2:
    mov eax, [player2_score]
    call WriteInt
    call CrLf
    call WaitMsg
    jmp turns

exceed_limit_user2:
    
    mov eax, [player2_score]
    call WriteInt
    call CrLf
    call WaitMsg
    jmp turns

win_user2:
    mov edx, offset newline
    call WriteString
    mov edx, offset prompt_player2
    call WriteString
    call WriteDec  
    call CrLf
    mov edx, offset newline
    call WriteString
    mov edx, offset player2_win_message 
    call WriteString                   

    call CrLf
    jmp end_game




end_game:

    mov eax, [player1_score]
    call WriteInt
    call CrLf

    mov eax, [player2_score]
    call WriteInt
    call CrLf
    ret
turns ENDP

END main

 




