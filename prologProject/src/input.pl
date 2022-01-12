row(65,0).
row(66,1).
row(67,2).
row(68,3).
row(69,4).
row(70,5).
row(_,-1).

col(1,0).
col(2,1).
col(3,2).
col(4,3).
col(5,4).
col(6,5).
col(_,-1).

menu_option(1).
menu_option(2).
menu_option(3).
menu_option(4).
menu_option(_) :- fail.

get_names(P1,P2) :- write('Name of Player 1: '),get_name(P1),nl,write('Name of Player 2: '), get_name(P2).

get_name(P) :- read_string(P).

get_move(Row,Col) :- get_row(Row), get_col(Col).

empty_string([]).

get_row(RN) :- write('Row: '), read_string([Row|T]), empty_string(T), row(Row,RN), RN =\= -1.
get_row(RN) :- write('ERROR: Invalid Input'),nl,get_row(RN).

get_col(CN) :- write('Column: '), read_number(Col), col(Col,CN), CN =\= -1.
get_col(CN) :- write('ERROR: Invalid Input'), nl, get_col(CN).

get_option(Option) :- write('Option: '), read_number(Option), menu_option(Option).
get_option(Option) :- write('ERROR: Invalid Input'), nl, get_option(Option).

read_string(X) :- read_string(X,[]).
read_string(X,X) :- peek_code(10),!,skip_line.
read_string(X,Acc) :-   get_code(Char),
                        append(Acc,[Char],Next),
                        read_string(X,Next).

read_number(X) :-   read_number(X,0).
read_number(X,X) :- peek_code(10), !, skip_line.
read_number(X,Acc) :-   get_code(Char),
                        char_code('0',Zero),
                        N is Char - Zero,
                        Next is Acc * 10 + N,
                        read_number(X,Next).

wait_for_input :- skip_line.
