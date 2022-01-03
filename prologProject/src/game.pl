:- include('view.pl').
:- include('adjacencies.pl').

getNames(P1,P2) :- getName(P1), getName(P2).

getName(P) :- read(P).

valid_moves(Board,Turn,Moves) :- valid_moves(Board,Board,0,Turn,[],Moves).

valid_moves(_,[],_,_,_,Moves,Moves).
valid_moves(Board,[R | T],RN,Turn,Acc,Moves) :- valid_moves_row(Board,R,RN,CN,Turn,[],Row),
                                                append(Acc,[Row],New),
                                                NewRow is RN+1,
                                                valid_moves(Board,T,NewRow,0,Turn,New,Moves).

valid_moves_row(_,[],_,_,_,Row,Row).
valid_moves_row(Board,[H | T],RN,CN,Turn,Acc,Row) :-    valid_move(Board,RN,CN,Turn,Result),
                                                        append(Acc,[Result],New),
                                                        NewCol is CN+1,
                                                        valid_moves_row(Board,T,RN,NewCol,Turn,New,Row).

valid_move(Board,RN,CN,Turn,Result).