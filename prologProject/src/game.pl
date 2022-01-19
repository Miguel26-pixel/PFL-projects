:- include('adjacencies.pl').
:- include('input.pl').

get_new_turn(1,2).
get_new_turn(2,1).

get_valid_pos(0).
get_valid_pos(1).
get_valid_pos(2).
get_valid_pos(3).
get_valid_pos(4).
get_valid_pos(5).

move(Board/Turn/Players,Row/Col,NewGameState) :-    move_row(Board,Turn,Row,Col,[],ResultBoard), 
                                                    get_new_turn(Turn,New),
                                                    NewGameState = ResultBoard/New/Players.

game_over(Board/Turn/_Players,Winner) :-    valid_moves(Board/Turn/_Players,ListOfMoves),
                                            (length(ListOfMoves, 0) ->
                                                Winner is Turn
                                            ;
                                                Winner is 0
                                            ).

valid_moves(Board/Turn/_,ListOfMoves) :- findall(Move, try_move(Board,Turn,Move), ListOfMoves).

try_move(Board,Turn,Move) :-    get_valid_pos(RN),
                                get_valid_pos(CN),
                                getValue(Board,RN,CN,Value), 
                                valid_move(Board,Value,RN,CN,Turn,Result), 
                                Result =:= 1, 
                                Move = RN/CN.

valid_move(Board,Value,RN,CN,Turn,Result) :-    getNumFriends(Board,RN,CN,Turn,Friends),
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

check_move(ListOfMoves,RN,CN,Valid) :-  append(_L, [RN/CN | _L1], ListOfMoves),
                                        Valid is 1.
check_move(_,_,_,0).

choose_move_human(GameState,Row/Col) :- valid_moves(GameState,ListOfMoves),
                                        get_move(R,C), 
                                        check_move(ListOfMoves,R,C,Valid),
                                        ( Valid =:= 0 -> 
                                            write('ERROR: Invalid Move'), nl,
                                            choose_move_human(GameState,Row/Col)
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

is_human(_/1/_).

choose_move(GameState,_,Move) :-    valid_moves(GameState, ListOfMoves),
                                    random_member(Move, ListOfMoves).
                                        
