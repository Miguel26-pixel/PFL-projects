:- include('game.pl').
:- include('view.pl').

/*initial_state(Board/Turn/Players) :-    get_names(P1,P2),
                                        Players = P1/P2,
                                        Turn is 1,
                                        Board = [   [2,1,2,1,2,2],
                                                    [2,1,1,1,1,1],
                                                    [1,2,1,0,1,2],
                                                    [2,2,2,1,1,2],
                                                    [2,1,1,2,2,0],
                                                    [1,1,0,0,0,0]   ].*/


initial_state(Board/Turn/Players) :-    get_names(P1,P2),
                                        Players = P1/P2,
                                        Turn is 1,
                                        Board = [   [2,0,2,1,0,2],
                                                    [2,0,0,1,1,1],
                                                    [1,0,0,0,1,0],
                                                    [0,2,2,0,0,2],
                                                    [0,1,0,2,2,0],
                                                    [1,1,0,0,0,0]   ].

play :- menu(Option),
        play(Option). 

menu(Option) :- display_menu,
                get_option(Option).

play(1) :- playPvP.
play(2) :- playPvC.
play(3) :- playCvP.
play(4) :- !.
    
playPvP :-  initial_state(GameState),
            playPvP(GameState).

playPvP(GameState) :-   display_game(GameState),
                        valid_moves(GameState,ValidGameState),
                        game_over(ValidGameState,Winner),
                        (Winner =\= 0 -> 
                            quit_game(Winner,GameState),
                            wait_for_input,
                            play
                        ;   
                            get_valid_move(ValidGameState,Move),
                            move(GameState,Move,NewGameState),
                            playPvP(NewGameState)
                        ).

playPvC :- play.

playCvP :- play.

%choose_move(Board/Turn/Players,Level,Move).
