getNumFriends(Board,RN,CN,Turn,Friends) :-  getFriendUP(Board,RN,CN,Turn,UP), write(UP),
                                            getFriendDOWN(Board,RN,CN,Turn,DOWN), write(DOWN),
                                            getFriendLEFT(Board,RN,CN,Turn,LEFT), write(LEFT),
                                            getFriendRIGHT(Board,RN,CN,Turn,RIGHT), write(RIGHT),
                                            Friends is UP + DOWN + LEFT + RIGHT.

getFriendUP(Board,RN,CN,Turn,Result) :- (RN > 0 -> Row is RN - 1, getValue(Board,Row,CN,ResUP),
                                            (ResUP =:= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getFriendDOWN(Board,RN,CN,Turn,Result) :- (RN < 5 -> Row is RN + 1, getValue(Board,Row,CN,ResUP),
                                            (ResUP =:= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getFriendLEFT(Board,RN,CN,Turn,Result) :- (CN > 0 -> Col is CN - 1, getValue(Board,RN,Col,ResLEFT),
                                            (ResLEFT =:= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getFriendRIGHT(Board,RN,CN,Turn,Result) :- (CN < 5 -> Col is CN + 1, getValue(Board,RN,Col,ResRIGHT),
                                            (ResRIGHT =:= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getNumEnemies(Board,RN,CN,Turn,Enemies) :-  getEnemiesUP(Board,RN,CN,Turn,UP), write(UP),
                                            getEnemiesDOWN(Board,RN,CN,Turn,DOWN), write(DOWN),
                                            getEnemiesLEFT(Board,RN,CN,Turn,LEFT), write(LEFT),
                                            getEnemiesRIGHT(Board,RN,CN,Turn,RIGHT), write(RIGHT),
                                            Enemies is UP + DOWN + LEFT + RIGHT.

getEnemiesUP(Board,RN,CN,Turn,Result) :- (RN > 0 -> Row is RN - 1, getValue(Board,Row,CN,ResUP),
                                            (ResUP =\= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getEnemiesDOWN(Board,RN,CN,Turn,Result) :- (RN < 5 -> Row is RN + 1, getValue(Board,Row,CN,ResUP),
                                            (ResUP =\= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getEnemiesLEFT(Board,RN,CN,Turn,Result) :- (CN > 0 -> Col is CN - 1, getValue(Board,RN,Col,ResLEFT),
                                            (ResLEFT =\= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getEnemiesRIGHT(Board,RN,CN,Turn,Result) :- (CN < 5 -> Col is CN + 1, getValue(Board,RN,Col,ResRIGHT),
                                            (ResRIGHT =\= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getValue(Board,RN,CN,Result) :- getV(RN,Board,Row),
                                getV(CN,Row,Result).

getV(0,[X|T],X).
getV(N,[H|T],X) :-  N > 0,
                    N1 is N - 1,
                    getV(N1,T,X).