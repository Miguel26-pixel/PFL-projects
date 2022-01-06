letters(0,'A').
letters(1,'B').
letters(2,'C').
letters(3,'D').
letters(4,'E').
letters(5,'F').

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
                %nl,
                %print_string("4 - COMPUTER VS COMPUTER"),
                nl,nl.

display_game(Board, Turn, Players) :-  nl,nl,
                                write('\t'),
                                print_string("PATHWAY"),
                                nl,nl,
                                print_players(Turn,Players), 
                                nl,nl,
                                print_board(Board,0),
                                nl.

quit_game(1,[P1,P2|[]]) :- nl,nl,write('GAME OVER'),nl,nl,write('THE WINNER IS '),write(P1),!.
quit_game(2,[P1,P2|[]]) :- nl,nl,write('GAME OVER'),nl,nl,write('THE WINNER IS '),write(P2),!.

print_string([]) :- !.
print_string([H | T]) :- put_code(H),
print_string(T).

print_players(Turn,[P1,P2|[]]) :-   write('X: '), write(P1), nl,
                                    write('O: '), write(P2), nl, nl,
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
                        (H =:= 0 -> put_char(' ') ; (H =:= 1 -> put_char('X') ; put_char('O'))),
                        print_board_line(T).