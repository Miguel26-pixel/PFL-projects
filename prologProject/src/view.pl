% letters(+Row,-Letter)
% retorna a letra correspondente a cada linha do tabuleiro
letters(0,'A').
letters(1,'B').
letters(2,'C').
letters(3,'D').
letters(4,'E').
letters(5,'F').

% display_menu/0
% Imprime o menu inicial
display_menu :- nl,nl,
                write('\t'),
                print_string("PATHWAY"),
                nl,nl,
                print_string("OPTIONS"),
                nl,nl,
                print_string("1 - PLAYER VS PLAYER"),
                nl,
                print_string("2 - PLAYER VS COMPUTER"),
                nl,
                print_string("3 - COMPUTER VS PLAYER"),
                nl,
                print_string("4 - COMPUTER VS COMPUTER"),
                nl,
                print_string("5 - EXIT"),
                nl,nl.

% display_game(+GameState)
% Imprime o tabuleiro, dados sobre os jogadores e também o jogador que tem a vez atual
display_game(Board/Turn/Players) :-     nl,nl,
                                        write('\t'),
                                        print_string("PATHWAY"),
                                        nl,nl,
                                        print_players(Turn,Players), 
                                        nl,nl,
                                        print_board(Board,0),
                                        nl.

% quit_game(+Winner,+GameState)
% Imprime o resultado do jogo com informação de qual jogador ganhou
quit_game(1,_/_/(P1/_)) :- nl,nl,write('GAME OVER - PLAYER DO NOT HAVE A VALID MOVE'),nl,nl,write('THE WINNER IS '),print_string(P1),!.
quit_game(2,_/_/(_/P2)) :- nl,nl,write('GAME OVER - PLAYER DO NOT HAVE A VALID MOVE'),nl,nl,write('THE WINNER IS '),print_string(P2),!.

% print_string([])
% Imprime uma string (lista de ascii codes) no tabuleiro
print_string([]) :- !.
print_string([H | T]) :- put_code(H),
print_string(T).

% print_players(+Turn,+Players)
% Imprime o nome dos jogadores associados ao tipo de peça ('X' ou 'O') e o jogador que tem a vez atual
print_players(Turn,P1/P2) :-    write('X: '), print_string(P1), nl,
                                write('O: '), print_string(P2), nl, nl,
                                write('Turn: '), (Turn =:= 1 -> print_string(P1) ; print_string(P2)).

% print_board(+Board,+Row)
% Imprime o tabuleiro incluindo as letras que se relacionam com as linhas e os números com as várias colunas
print_board([],_) :- print_border, print_string("       1   2   3   4   5   6").
print_board([Line | Rest], Row) :-  print_border,
                                    letters(Row,Letter),
                                    write(Letter),
                                    write('   '),
                                    print_board_line(Line),
                                    nl,
                                    NextRow is Row + 1,
                                    print_board(Rest, NextRow).

% print_border/0
% Imprime a borda do tabuleiro para cada linha
print_border :- write('      '), 
                print_string("_______________________"), 
                nl, nl.

% print_board_line(+Row)
% Imprime a linha do tabuleiro
print_board_line([]) :- write(' |').
print_board_line([H | T]) :-    write(' | '),
                                (H =:= 0 -> 
                                    put_char(' ') 
                                ; H =:= 1 -> 
                                    put_char('X')
                                ; 
                                    put_char('O')
                                ),
                                print_board_line(T).

% clear/0
% limpa ecrã do SICStus Prolog
clear :- write('\33\[2J').
