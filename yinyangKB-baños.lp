row(0..n).
col(0..n).
color(white;black).



1{_drawcircle(X,Y,C):color(C)}1 :- row(X);col(Y).
vecinos(X,Y,X',Y',C):- _drawcircle(X,Y,C),_drawcircle(X',Y',C),X==X',|Y-Y'|==1.
vecinos(X,Y,X',Y',C):- _drawcircle(X,Y,C),_drawcircle(X',Y',C),Y==Y',|X-X'|==1.

reach(X,Y,X,Y,C) :- _drawcircle(X,Y,C).  
reach(X,Y,X',Y',C) :- reach(X,Y,X'',Y'',C), vecinos(X'',Y'',X',Y',C).
:- _drawcircle(X,Y,C),_drawcircle(X',Y',C),not reach(X,Y,X',Y',C).
:- _drawcircle(X,Y,C), _drawcircle(X+1,Y,C), _drawcircle(X,Y+1,C), _drawcircle(X+1,Y+1,C).
:- _drawcircle(X,Y,C1), _drawcircle(X+1,Y+1,C1), _drawcircle(X+1,Y,C2), _drawcircle(X,Y+1,C2), C1 != C2.
#show _drawcircle/3.
