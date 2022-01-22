% row(+Code, -Row)
% a partir de um código ascii equivalente a uma letra (A-F) é retornado a Row correta do tabuleiro
row(65,0).
row(66,1).
row(67,2).
row(68,3).
row(69,4).
row(70,5).
row(_,-1).

% col(+Code, -Col)
% a partir de um código ascii equivalente ao número dado pelo utilizador é retornado a Col correta do tabuleiro
col(1,0).
col(2,1).
col(3,2).
col(4,3).
col(5,4).
col(6,5).
col(_,-1).

% menu_option(+Option)
% verificação que foi dado uma opção válida para o menu
menu_option(1).
menu_option(2).
menu_option(3).
menu_option(4).
menu_option(5).
menu_option(_) :- fail.

% get_names(-Player1,-Player2)
% obtenção dos nomes dos dois jogadores dado pelos utilizadores
get_names(P1,P2) :- write('Name of Player 1: '),get_name(P1),nl,write('Name of Player 2: '), get_name(P2).

% get_name_computer(-Player)
% obtenção dos nomes dos dois jogadores dado pelos utilizadores
get_name_computer(P) :- write('Name of Player 1: '), get_name(P).

% get_name(-Player)
% chama uma função que lê uma string equivalente ao nome do player
get_name(P) :- read_string(P).

% get_move(-Row,-Col)
% chama uma função que lê uma Linha e uma Coluna que formam uma posição do tabuleiro
get_move(Row,Col) :- get_row(Row), get_col(Col).

% empty_string(+List)
% verifica se uma lista dada está vazia
empty_string([]).

% get_row(-Row)
% obtenção e validação de uma Linha do tabuleiro dada pelo utilizador
get_row(RN) :- write('Row: '), read_string([Row|T]), empty_string(T), row(Row,RN), RN =\= -1.
get_row(RN) :- write('ERROR: Invalid Input'),nl,get_row(RN).

% get_col(-Col)
% obtenção e validação de uma Coluna do tabuleiro dada pelo utilizador
get_col(CN) :- write('Column: '), read_number(Col), col(Col,CN), CN =\= -1.
get_col(CN) :- write('ERROR: Invalid Input'), nl, get_col(CN).

% get_option(-Option)
% obtenção e validação de uma Opção do menu dada pelo utilizador
get_option(Option) :- write('Option: '), read_number(Option), menu_option(Option).
get_option(Option) :- write('ERROR: Invalid Input'), nl, get_option(Option).

% read_string(-String)
% obtenção de uma string dada pelo utilizador (feita nos exercicios das TPs)
read_string(X) :- read_string(X,[]).
read_string(X,X) :- peek_code(10),!,skip_line.
read_string(X,Acc) :-   get_code(Char),
                        append(Acc,[Char],Next),
                        read_string(X,Next).

% read_number(-String)
% obtenção de um número dado pelo utilizador (feita nos exercicios das TPs)
read_number(X) :-   read_number(X,0).
read_number(X,X) :- peek_code(10), !, skip_line.
read_number(X,Acc) :-   get_code(Char),
                        char_code('0',Zero),
                        N is Char - Zero,
                        Next is Acc * 10 + N,
                        read_number(X,Next).

% wait_for_input/0
% espera que o utilizador escreva um '\n' para prosseguir
wait_for_input :- write('Input enter to continue'), skip_line.
