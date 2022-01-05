getNumFriends(Board,RN,CN,Turn,Friends) :-  getFriendUP(Board,RN,CN,Turn,UP),
                                            getFriendDOWN(Board,RN,CN,Turn,DOWN),
                                            getFriendLEFT(Board,RN,CN,Turn,LEFT),
                                            getFriendRIGHT(Board,RN,CN,Turn,RIGHT),
                                            Friends is UP + DOWN + LEFT + RIGHT.

getFriendUP(Board,RN,CN,Turn,Result) :- (RN > 0 -> Row is RN - 1, getValue(Board,Row,CN,ResUP),
                                            (ResUP =:= Turn -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getFriendDOWN(Board,RN,CN,Turn,Result) :- (RN < 5 -> Row is RN + 1, getValue(Board,Row,CN,ResDOWN),
                                            (ResDOWN =:= Turn -> Result is 1 ; Result is 0)
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

getNumEnemies(Board,RN,CN,Turn,Enemies) :-  getEnemiesUP(Board,RN,CN,Turn,UP),
                                            getEnemiesDOWN(Board,RN,CN,Turn,DOWN),
                                            getEnemiesLEFT(Board,RN,CN,Turn,LEFT),
                                            getEnemiesRIGHT(Board,RN,CN,Turn,RIGHT),
                                            Enemies is UP + DOWN + LEFT + RIGHT.

getEnemiesUP(Board,RN,CN,Turn,Result) :- (RN > 0 -> Row is RN - 1, getValue(Board,Row,CN,ResUP),
                                            ((ResUP =\= Turn,ResUP =\= 0)  -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getEnemiesDOWN(Board,RN,CN,Turn,Result) :- (RN < 5 -> Row is RN + 1, getValue(Board,Row,CN,ResDOWN),
                                            ((ResDOWN =\= Turn,ResDOWN =\= 0) -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getEnemiesLEFT(Board,RN,CN,Turn,Result) :- (CN > 0 -> Col is CN - 1, getValue(Board,RN,Col,ResLEFT),
                                            ((ResLEFT =\= Turn,ResLEFT =\= 0) -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getEnemiesRIGHT(Board,RN,CN,Turn,Result) :- (CN < 5 -> Col is CN + 1, getValue(Board,RN,Col,ResRIGHT),
                                            ((ResRIGHT =\= Turn,ResRIGHT =\= 0) -> Result is 1 ; Result is 0)
                                        ; Result is 0
                                        ).

getValue(Board,RN,CN,Result) :- getV(RN,Board,Row),
                                getV(CN,Row,Result).

getV(0,[X|T],X).
getV(N,[H|T],X) :-  N > 0,
                    N1 is N - 1,
                    getV(N1,T,X).