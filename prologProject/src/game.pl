:- include('adjacencies.pl').
:- include('input.pl').

get_new_turn(1,2).
get_new_turn(2,1).

valid_moves(Board,Turn,Moves) :- valid_moves(Board,Board,0,Turn,[],Moves).

valid_moves(_,[],_,_,Moves,Moves).
valid_moves(Board,[R | T],RN,Turn,Acc,Moves) :- valid_moves_row(Board,R,RN,0,Turn,[],Row),
                                                append(Acc,[Row],New),
                                                NewRow is RN+1,
                                                valid_moves(Board,T,NewRow,Turn,New,Moves).

valid_moves_row(_,[],_,_,_,Row,Row).
valid_moves_row(Board,[V | T],RN,CN,Turn,Acc,Row) :-    valid_move(Board,V,RN,CN,Turn,Result),
                                                        append(Acc,[Result],New),
                                                        NewCol is CN+1,
                                                        valid_moves_row(Board,T,RN,NewCol,Turn,New,Row).

valid_move(Board,Value,RN,CN,Turn,Result) :-  getNumFriends(Board,RN,CN,Turn,Friends),
                                        getNumEnemies(Board,RN,CN,Turn,Enemies),
                                        validate_check(Friends,Enemies,Value,Result).

validate_check(Friends,Enemies,Value,Result) :- ( Value =\= 0 -> 
                                                    Result is 0
                                                ; (Friends =:= 0, Enemies =:= 0) ->
                                                    Result is 1
                                                ; Friends =:= 1 ->
                                                    Result is 1
                                                ; 
                                                    Result is 0
                                                ).

check_move(Moves,RN,CN,Valid) :- getValue(Moves,RN,CN,Valid).

get_valid_move(Moves,Row,Col) :-    get_move(R,C), 
                                    check_move(Moves,R,C,Valid),
                                    ( Valid =:= 0 -> 
                                        write('ERROR: Invalid Move'),
                                        nl,
                                        get_valid_move(Moves,Row,Col)
                                    ; 
                                        Row is R,
                                        Col is C
                                    ).

move_row([H | T],Turn,0,Col,Acc,ResultBoard) :- move_col(H,Turn,Col,[],Result),
                                                append(Acc,[Result],B1),
                                                append(B1,T,ResultBoard).

move_row([H | T],Turn,Row,Col,Acc,ResultBoard) :-   append(Acc,[H],New),
                                                    RN is Row - 1,
                                                    move_row(T,Turn,RN,Col,New,ResultBoard).

move_col([_|T],Turn,0,Acc,Result) :-    append(Acc,[Turn],Row),
                                        append(Row,T,Result).

move_col([H|T],Turn,Col,Acc,Result) :-  append(Acc,[H],Row),
                                        CN is Col - 1,
                                        move_col(T,Turn,CN,Row,Result).

game_over_row([],1).
game_over_row([H|T],Res) :- H =:= 0, game_over_row(T,Res).
game_over_row([H|_],Res) :- H =\= 0, Res is 0.
