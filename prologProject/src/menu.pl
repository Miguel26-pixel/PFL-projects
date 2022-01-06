:- include('view.pl').

option('1',1).
option('2',2).
option('3',3).
option(_,-1).

menu(Option) :- display_menu,
                get_option(Option).

get_option(Option) :- write('Option: '), get_char(O), option(O,Option), skip_line, Option =\= -1.
get_option(Option) :- write('ERROR: Invalid Input'), nl, get_option(Option).
