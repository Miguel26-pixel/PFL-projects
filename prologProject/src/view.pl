letters(0,'A').
letters(1,'B').
letters(2,'C').
letters(3,'D').
letters(4,'E').
letters(5,'F').
letters(6,'G').
letters(7,'H').
letters(8,'I').

display_game(Board, Turn, Players) :-  nl,nl,
                                write('\t'),
                                print_string("PATHWAY"),
                                nl,nl,
                                print_players(Turn,Players), 
                                nl,nl,
                                print_board(Board,0),
                                nl.

print_string([]) :- !.
print_string([H | T]) :- put_code(H),
print_string(T).

print_players(Turn,[P1,P2|[]]) :-   write('Red: '), write(P1), nl,
                                    write('Blue: '), write(P2), nl, nl,
                                    write('Turn: '), (Turn =:= 1 -> write(P1) ; write(P2)).

print_board([],_) :- print_border, print_string("       1   2   3   4   5   6").
print_board([Line | Rest], Row) :-
    print_border,
    letters(Row,Letter),
    write(Letter),
    write('   '),
    print_board_line(Line),
    nl,
    NextRow is Row + 1,
    print_board(Rest, NextRow).


print_border :- write('      '), 
                print_string("_______________________"), 
                nl, nl.

print_board_line([]) :- write(' |').
print_board_line([H | T]) :-  write(' | '),
                        (H =:= 0 -> put_char(' ') ; (H =:= 1 -> put_char('R') ; put_char('B'))),
                        print_board_line(T).

