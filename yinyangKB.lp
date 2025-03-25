% yinyangKB.lp

% Definir los dominios de filas y columnas basándose en la dimensión.
row(X) :- gridsize(N), X = 0..(N-1).
col(Y) :- gridsize(N), Y = 0..(N-1).

% Si la celda es fija, se impone su color.
color(X,Y,C) :- fixed(X,Y,C).

% Para las celdas no fijas se escoge un color (exactamente uno).
{ color(X,Y,black); color(X,Y,white) } = 1 :- row(X), col(Y), not fixed(X,Y,_).

% Definir la relación de adyacencia (movimientos verticales y horizontales)
adjacent(X,Y,X1,Y) :- row(X), row(X1), col(Y), X1 = X + 1.
adjacent(X,Y,X1,Y) :- row(X), row(X1), col(Y), X1 = X - 1.
adjacent(X,Y,X,Y1) :- row(X), col(Y), col(Y1), Y1 = Y + 1.
adjacent(X,Y,X,Y1) :- row(X), col(Y), col(Y1), Y1 = Y - 1.

% Conectividad para celdas negras
% Se escoge una "raíz" negra: la de menor orden lexicográfico.
blackRoot(X,Y) :- color(X,Y,black), not exists_black_lower(X,Y).

exists_black_lower(X,Y) :- row(X), col(Y), color(U,V,black), U < X.
exists_black_lower(X,Y) :- row(X), col(Y), color(U,V,black), U = X, V < Y.

% Una celda negra es alcanzable si es la raíz o es adyacente a una ya alcanzable.
blackReach(X,Y) :- blackRoot(X,Y).
blackReach(X2,Y2) :- blackReach(X1,Y1), adjacent(X1,Y1,X2,Y2), color(X2,Y2,black).

% Cada celda negra debe ser alcanzable.
:- color(X,Y,black), not blackReach(X,Y).

% Conectividad para celdas blancas (análogo)
whiteRoot(X,Y) :- color(X,Y,white), not exists_white_lower(X,Y).

exists_white_lower(X,Y) :- row(X), col(Y), color(U,V,white), U < X.
exists_white_lower(X,Y) :- row(X), col(Y), color(U,V,white), U = X, V < Y.

whiteReach(X,Y) :- whiteRoot(X,Y).
whiteReach(X2,Y2) :- whiteReach(X1,Y1), adjacent(X1,Y1,X2,Y2), color(X2,Y2,white).

:- color(X,Y,white), not whiteReach(X,Y).

% Restricción para evitar bloques 2x2 del mismo color.
:- row(X), col(Y), row(X1), col(Y1), X1 = X + 1, Y1 = Y + 1,
   color(X,Y,C), color(X1,Y,C), color(X,Y1,C), color(X1,Y1,C).

% Generar los átomos para la salida, que serán usados por decode.py y display.py.
_drawcircle(X,Y,C) :- color(X,Y,C).

% Mostrar el tamaño de la cuadrícula y los átomos de dibujo.
#show gridsize/1.
#show _drawcircle/3.