:- include('game.pl').
:- include('view.pl').

initial_state(B) :- B = [   [2,0,2,1,0,2],
                            [2,0,0,1,1,1],
                            [1,0,0,0,1,0],
                            [0,2,2,0,0,2],
                            [0,1,0,2,2,0],
                            [1,1,0,0,0,0]   ].

play :- playPvP(Board,1,[p1,p2]).

playPvP(Board,Turn,Players) :-  /*getNames(P1,P2),*/
                                initial_state(Board),
                                display_game(Board,Turn,Players),
                                valid_moves(Board,Turn,Moves),
                                display_game(Moves,Turn,Players).

move(Board,Turn,Move,ResultBoard) :- !.

game_over(Board,Turn,Result) :- !.

choose_move(Board,Turn,Level,Move) :- !.

test :- testMoves(Board,1).

testMoves(Board,Turn) :-    initial_state(Board),
                            valid_moves(Board,Turn,Moves),
                            display_game(Moves, Turn, [p1,p2]).