:- include('game.pl').
:- include('view.pl').
:- use_module(library(random)). % para utilização de random_member/2
:- use_module(library(system)). % para utilização de sleep/1


% predicado que retorna o tabuleiro inicial para o GameState
% initial_state(+Size, -GameState)
initial_state(Board/_Turn/_Players) :-  Board = [   [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0],
                                                    [0,0,0,0,0,0]   ].

% Alguns estados de tabuleiros para testes
/*initial_state(Board/Turn/Players) :-  Board = [   [2,1,2,1,2,2],
                                                    [2,1,1,1,1,1],
                                                    [1,2,1,0,1,2],
                                                    [2,2,2,1,1,2],
                                                    [2,1,1,2,2,0],
                                                    [1,1,0,0,0,0]   ].*/

/*initial_state(Board/_Turn/_Players) :-  Board = [   [2,0,2,1,0,2],
                                                    [2,0,0,1,1,1],
                                                    [1,0,0,0,1,0],
                                                    [0,2,2,0,0,2],
                                                    [0,1,0,2,2,0],
                                                    [1,1,0,0,0,0]   ].*/

% função inicial do jogo que mostra menu e começa o jogo dependendo da opção obtida
% play/0
play :- clear,
        menu(Option),
        play(Option). 

% mostra o tabuleiro e obtém uma opção de menu válida
% menu(-Option)
menu(Option) :- display_menu,
                get_option(Option).

% começa o jogo dependendo do modo escolhido pelo utilizador
% play(+Option)
play(1) :- playPvP. %Player vs Player
play(2) :- playPvC. %Player vs Computer
play(3) :- playCvP. %Computer vs Player 
play(4) :- playCvC. %Computer vs Computer
play(5) :- !. %Exit

% playPvP/0
% obtém a Board inicial, nomes de ambos os jogadores e é escolhido o jogador 1 como primeiro a jogar que em conjunto formam o GameState e iniciam o jogo
playPvP :-  initial_state(Board/Turn/Players),
            Turn is 1,
            get_names(P1,P2),
            Players = P1/P2,
            clear,
            display_game(Board/Turn/Players),
            playPvP(Board/Turn/Players).

% playPvP(+GameState)
% verifica se existe possibilidades de continuação de jogo e caso não exista, o jogo é terminado
playPvP(GameState) :-   game_over(GameState,Winner),
                        Winner =\= 0,
                        quit_game(Winner,GameState),
                        wait_for_input,
                        play.

% playPvP(+GameState)
% escolha de uma jogada válida por parte de um jogador e é feita a jogada
playPvP(GameState) :-   choose_move_human(GameState,Move),
                        move(GameState,Move,NewGameState),
                        clear,
                        display_game(NewGameState),
                        playPvP(NewGameState).

% playPvC/0
% obtém a Board inicial, nomes de apenas 1 jogador visto que o outro é o computador e é escolhido o jogador 1 como primeiro a jogar que em conjunto formam o GameState e iniciam o jogo
playPvC :-  initial_state(Board/Turn/Players),
            Turn is 1,
            get_name_computer(P),
            Players = P/"Computer",
            clear,
            display_game(Board/Turn/Players),
            playPvsC(Board/Turn/Players).

% playCvP/0
% obtém a Board inicial, nomes de apenas 1 jogador visto que o outro é o computador e é escolhido o jogador 2 como primeiro a jogar que em conjunto formam o GameState e iniciam o jogo
playCvP :-  initial_state(Board/Turn/Players),
            Turn is 2,
            get_name_computer(P),
            Players = P/"Computer",
            clear,
            display_game(Board/Turn/Players),
            playPvsC(Board/Turn/Players).

% playPvP(+GameState)
% verifica se existe possibilidades de continuação de jogo e caso não exista, o jogo é terminado
playPvsC(GameState) :-  game_over(GameState,Winner),
                        Winner =\= 0,
                        quit_game(Winner,GameState),
                        wait_for_input,
                        play.

% playPvsC(+GameState)
% verificação se é a vez do jogador (que não é o computador) com o objetivo de escolha de uma jogada válida e é feita a jogada
playPvsC(GameState) :-  is_human(GameState),
                        choose_move_human(GameState,Move),
                        move(GameState,Move,NewGameState),
                        clear,
                        display_game(NewGameState),
                        playPvsC(NewGameState).

% playPvsC(+GameState)
% computador escolhe uma jogada válida e é feita a jogada
playPvsC(GameState) :-  choose_move(GameState, 1, Move),
                        move(GameState,Move,NewGameState),
                        sleep(0.5),
                        clear,
                        display_game(NewGameState),
                        playPvsC(NewGameState).

% playCvC/0
% obtém a Board inicial,  e é escolhido o computador 1 como primeiro a jogar que em conjunto formam o GameState e iniciam o jogo
playCvC :-  initial_state(Board/Turn/Players),
            Turn is 1,
            Players = "Computer-1"/"Computer-2",
            clear,
            display_game(Board/Turn/Players),
            playCvsC(Board/Turn/Players).

% playCvsC(+GameState)
% verifica se existe possibilidades de continuação de jogo e caso não exista, o jogo é terminado
playCvsC(GameState) :-  game_over(GameState,Winner),
                        Winner =\= 0,
                        quit_game(Winner,GameState),
                        wait_for_input,
                        play.

% playCvsC(+GameState)
% escolha de uma jogada válida por parte de um jogador e é feita a jogada
playCvsC(GameState) :-  choose_move(GameState, 1, Move),
                        move(GameState,Move,NewGameState),
                        sleep(0.5),
                        clear,
                        display_game(NewGameState),
                        playCvsC(NewGameState).
