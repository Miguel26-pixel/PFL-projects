:- include('adjacencies.pl').
:- include('input.pl').

% get_new_turn(+Old,-New)
% predicado que a partir da vez Old retorna a vez New (próximo jogador a fazer movimento)
get_new_turn(1,2).
get_new_turn(2,1).

% get_valid_pos(+Pos)
% factos que indicam todas as posições válidas para Row e para Col 
get_valid_pos(0).
get_valid_pos(1).
get_valid_pos(2).
get_valid_pos(3).
get_valid_pos(4).
get_valid_pos(5).

% game_over(+GameState, -Winner)
% verifica se existe algum movimento possível, caso exista, Winner = 0, caso não exista o Winner = Turn e significa que o jogo acabou e o jogador da Turn ganhou
game_over(Board/Turn/_Players,Winner) :-    valid_moves(Board/Turn/_Players,ListOfMoves),
                                            (length(ListOfMoves, 0) ->
                                                Winner is Turn
                                            ;
                                                Winner is 0
                                            ).

% valid_moves(+GameState, -ListOfMoves)
% obtém uma lista com todos os movimentos válidos dependendo do estado atual do jogo
valid_moves(Board/Turn/_,ListOfMoves) :- findall(Move, try_move(Board,Turn,Move), ListOfMoves).

% try_move(+Board, +Turn, +Move)
% função 'Goal' utilizada no findall para obter todos os movimentos válidos
try_move(Board,Turn,Move) :-    get_valid_pos(RN),
                                get_valid_pos(CN),
                                getValue(Board,RN,CN,Value), 
                                valid_move(Board,Value,RN,CN,Turn,Result), 
                                Result =:= 1, 
                                Move = RN/CN.

% valid_move(+Board,+Value,+RN,+CN,+Turn,-Result)
% verifica se um movimento é válido a partir da Board atual e obtém o Result (1 caso seja válido, 2 caso não seja válido)
valid_move(Board,Value,RN,CN,Turn,Result) :-    getNumFriends(Board,RN,CN,Turn,Friends),
                                                getNumEnemies(Board,RN,CN,Turn,Enemies),
                                                validate_check(Friends,Enemies,Value,Result).

% validate_check(+Friends,+Enemies,+Value,-Result)
% verifica, através das FriendConnections e das EnemiesConnections (Ver Descrição do jogo) se a jogada é válida ou não 
validate_check(Friends,Enemies,Value,Result) :- ( Value =\= 0 -> 
                                                    Result is 0
                                                ; (Friends =:= 0, Enemies =:= 0) ->
                                                    Result is 1
                                                ; Friends =:= 1 ->
                                                    Result is 1
                                                ; 
                                                    Result is 0
                                                ).

% check_move(+ListOfMoves,+RN,+CN,-Valid)
% verifica se um movimento está presenta na Lista de movimentos dada
check_move(ListOfMoves,RN,CN,Valid) :-  append(_L, [RN/CN | _L1], ListOfMoves),
                                        Valid is 1.
check_move(_,_,_,0).

% choose_move_human(+GameState,-Move)
% obtém do jogador um movimento (Row/Col) válido dependendo do GameState
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

% move(+GameState, +Move, -NewGameState).
% faz a execução de uma jogada retornando um GameState novo com a jogada já feita
move(Board/Turn/Players,Row/Col,NewGameState) :-    move_row(Board,Turn,Row,Col,[],ResultBoard), 
                                                    get_new_turn(Turn,New),
                                                    NewGameState = ResultBoard/New/Players.

% move_row(+Board,+Turn,+Row,+Col,+BoardAccumulator,-ResultBoard)
% percorre a board até estar na fila correta onde foi feito o movimento
move_row([H | T],Turn,0,Col,Acc,ResultBoard) :- move_col(H,Turn,Col,[],Result),
                                                append(Acc,[Result],B1),
                                                append(B1,T,ResultBoard).

move_row([H | T],Turn,Row,Col,Acc,ResultBoard) :-   append(Acc,[H],New),
                                                    RN is Row - 1,
                                                    move_row(T,Turn,RN,Col,New,ResultBoard).

% move_col(+Row,+Turn,+Col,+BoardAccumulator,+Result)
% percorre a fila até estar na coluna certa e altera o valor da posição para a Turn, altera a board de modo a executar jogada
move_col([_|T],Turn,0,Acc,Result) :-    append(Acc,[Turn],Row),
                                        append(Row,T,Result).

move_col([H|T],Turn,Col,Acc,Result) :-  append(Acc,[H],Row),
                                        CN is Col - 1,
                                        move_col(T,Turn,CN,Row,Result).

% is_humen(+GameState)
% factos que indica se o jogador que tem a vez é 1, ou seja, é um jogador que não é um computador
is_human(_/1/_).

% choose_move(+GameState, +Level, -Move)
% Escolha da jogada a efetuar pelo computador. O nível é ignorado pois apenas está implementado o nível 1 (devolve jogada válida aleatória)
choose_move(GameState,_,Move) :-    valid_moves(GameState, ListOfMoves),
                                    random_member(Move, ListOfMoves).
                                        
