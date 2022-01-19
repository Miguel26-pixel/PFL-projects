:- include('game.pl').
:- include('view.pl').
:- use_module(library(random)).
:- use_module(library(system)).

/*initial_state(Board/_Turn/_Players) :-  Board = [   [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0]   ].*/

/*initial_state(Board/Turn/Players) :-  Board = [   [2,1,2,1,2,2],
                                                    [2,1,1,1,1,1],
                                                    [1,2,1,0,1,2],
                                                    [2,2,2,1,1,2],
                                                    [2,1,1,2,2,0],
                                                    [1,1,0,0,0,0]   ].*/

initial_state(Board/_Turn/_Players) :-  Board = [   [2,0,2,1,0,2],
                                                    [2,0,0,1,1,1],
                                                    [1,0,0,0,1,0],
                                                    [0,2,2,0,0,2],
                                                    [0,1,0,2,2,0],
                                                    [1,1,0,0,0,0]   ].

clear :- write('\33\[2J').

play :- clear,
        menu(Option),
        play(Option). 

menu(Option) :- display_menu,
                get_option(Option).

play(1) :- playPvP.
play(2) :- playPvC.
play(3) :- playCvP.
play(4) :- playCvC.
play(5) :- !.

playPvP :-  initial_state(Board/Turn/Players),
            Turn is 1,
            get_names(P1,P2),
            Players = P1/P2,
            clear,
            display_game(Board/Turn/Players),
            playPvP(Board/Turn/Players).

playPvP(GameState) :-   game_over(GameState,Winner),
                        Winner =\= 0,
                        quit_game(Winner,GameState),
                        wait_for_input,
                        play.

playPvP(GameState) :-   choose_move_human(GameState,Move),
                        move(GameState,Move,NewGameState),
                        clear,
                        display_game(NewGameState),
                        playPvP(NewGameState).

playPvC :-  initial_state(Board/Turn/Players),
            Turn is 1,
            get_name_computer(P),
            Players = P/"Computer",
            clear,
            display_game(Board/Turn/Players),
            playPvsC(Board/Turn/Players).

playCvP :-  initial_state(Board/Turn/Players),
            Turn is 2,
            get_name_computer(P),
            Players = P/"Computer",
            clear,
            display_game(Board/Turn/Players),
            playPvsC(Board/Turn/Players).

playPvsC(GameState) :-  game_over(GameState,Winner),
                        Winner =\= 0,
                        quit_game(Winner,GameState),
                        wait_for_input,
                        play.

playPvsC(GameState) :-  is_human(GameState),
                        choose_move_human(GameState,Move),
                        move(GameState,Move,NewGameState),
                        clear,
                        display_game(NewGameState),
                        playPvsC(NewGameState).

playPvsC(GameState) :-  choose_move(GameState, 1, Move),
                        move(GameState,Move,NewGameState),
                        sleep(0.5),
                        clear,
                        display_game(NewGameState),
                        playPvsC(NewGameState).

playCvC :-  initial_state(Board/Turn/Players),
            Turn is 1,
            Players = "Computer-1"/"Computer-2",
            clear,
            display_game(Board/Turn/Players),
            playCvsC(Board/Turn/Players).

playCvsC(GameState) :-  game_over(GameState,Winner),
                        Winner =\= 0,
                        quit_game(Winner,GameState),
                        wait_for_input,
                        play.

playCvsC(GameState) :-  choose_move(GameState, 1, Move),
                        move(GameState,Move,NewGameState),
                        sleep(0.5),
                        clear,
                        display_game(NewGameState),
                        playCvsC(NewGameState).
