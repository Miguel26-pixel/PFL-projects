:- include('game.pl').
:- include('menu.pl').

initial_state(B) :- B = [   [2,0,2,1,0,2],
                            [2,0,0,1,1,1],
                            [1,0,0,0,1,0],
                            [0,2,2,0,0,2],
                            [0,1,0,2,2,0],
                            [1,1,0,0,0,0]   ].

play :- menu(Option),
        play(Option). 

play(1) :- playPvP.
play(2) :- playPvC.
play(3) :- playCvP.
play(4) :- !.
    
playPvP :-  initial_state(Board),
            playPvP(Board,1).

playPvP(Board,Turn) :-  get_names(P1,P2),
                        playPvP(Board,Turn,[P1,P2]).

playPvP(Board,Turn,Players) :-  display_game(Board,Turn,Players),
                                valid_moves(Board,Turn,Moves),
                                game_over(Moves,Turn,Winner),
                                (Winner =\= 0 -> 
                                    quit_game(Winner,Players),
                                    wait_for_input,
                                    play
                                ;   
                                    get_valid_move(Moves,Row,Col),
                                    move(Board,Turn,Row,Col,Res),
                                    get_new_turn(Turn,New),
                                    playPvP(Res,New,Players)
                                ).

playPvC :- play.

playCvP :- play.

move(Board,Turn,Row,Col,ResultBoard) :- move_row(Board,Turn,Row,Col,[],ResultBoard).

game_over([],Turn,Winner) :- get_new_turn(Turn,Winner).

game_over([Row | T],Turn,Winner) :- game_over_row(Row,Res),
                                    (Res =:= 0 -> 
                                        Winner is 0 
                                    ; 
                                        game_over(T,Turn,Winner)
                                    ).

choose_move(Board,Turn,Level,Move).
