read_string(X) :- read_string(X,[]).

read_string(X,X) :- peek_code(10), !, skip_line.

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

getV(0,[X|T],X).
getV(N,[H|T],X) :-  N > 0,
                    N1 is N - 1,
                    getV(N1,T,X).