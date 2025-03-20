%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% yinyangKB.lp
%% Lógica principal del puzzle Yin Yang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% -------------------------------------------------------------------
%% 1. Representación de color
%% -------------------------------------------------------------------
%% Suponemos que en domXX.lp vendrán hechos como:
%%   gridsize(N).
%%   cell(R,C,fixedBlack) / cell(R,C,fixedWhite) / cell(R,C,free).
%%   (Estos describen el tablero y celdas fijas o libres).

%% Para las celdas libres, elegimos color negro o blanco.
{ color(R,C,black) ; color(R,C,white) } :- cell(R,C,free).

%% Para celdas fijas, forzamos el color correspondiente.
color(R,C,black) :- cell(R,C,fixedBlack).
color(R,C,white) :- cell(R,C,fixedWhite).

%% -------------------------------------------------------------------
%% 2. Restricción de no 2x2 del mismo color
%% -------------------------------------------------------------------
%% Evitamos que haya un bloque 2x2 totalmente negro o totalmente blanco.
%% Sólo aplicamos la restricción en índices R,C donde R+1,C+1 sea válido.
:- gridsize(N),
   R < N, C < N,
   color(R,C,Color),
   color(R+1,C,Color),
   color(R,C+1,Color),
   color(R+1,C+1,Color).

%% -------------------------------------------------------------------
%% 3. Definición de adyacencia ortogonal
%% -------------------------------------------------------------------
%% "adj(R,C,R2,C2)" será cierto si (R2,C2) es vecino ortogonal de (R,C).
adj(R,C,R,C+1) :- gridsize(N), C < N.
adj(R,C,R,C-1) :- gridsize(N), C > 1.
adj(R,C,R+1,C) :- gridsize(N), R < N.
adj(R,C,R-1,C) :- gridsize(N), R > 1.

%% -------------------------------------------------------------------
%% 4. Conectividad de las celdas negras
%% -------------------------------------------------------------------
%% 4.1. Elegimos una "celda base" (o varias) como punto de partida.
%%     Aquí hacemos la técnica de "lexicographically first black cell".
%%     Si hay una celda negra (R,C) y no existe otra negra (R2,C2)
%%     que sea "menor" (fila menor, o misma fila y col menor),
%%     entonces la marcamos como baseBlack(R,C).
baseBlack(R,C) :-
    color(R,C,black),
    not smallerBlack(R,C).

smallerBlack(R,C) :-
    color(R2,C2,black),
    (R2 < R ; R2 == R, C2 < C).

%% 4.2. reachableBlack(R,C): celdas negras alcanzables desde la base.
reachableBlack(R,C) :- baseBlack(R,C).  % la base es alcanzable por definición

reachableBlack(R,C) :-
    reachableBlack(R2,C2),
    adj(R2,C2,R,C),
    color(R2,C2,black),
    color(R,C,black).

%% 4.3. Restricción: toda celda negra debe ser reachableBlack
:- color(R,C,black), not reachableBlack(R,C).

%% -------------------------------------------------------------------
%% 5. Conectividad de las celdas blancas
%% -------------------------------------------------------------------
%% Repetimos la misma idea para las blancas.
baseWhite(R,C) :-
    color(R,C,white),
    not smallerWhite(R,C).

smallerWhite(R,C) :-
    color(R2,C2,white),
    (R2 < R ; R2 == R, C2 < C).

reachableWhite(R,C) :- baseWhite(R,C).

reachableWhite(R,C) :-
    reachableWhite(R2,C2),
    adj(R2,C2,R,C),
    color(R2,C2,white),
    color(R,C,white).

:- color(R,C,white), not reachableWhite(R,C).

%% -------------------------------------------------------------------
%% 6. Mostrar la solución
%% -------------------------------------------------------------------
%% Para visualizar, podemos mostrar color(R,C,black/white).
%% O definimos un predicado auxiliar para decode.py
_drawcircle(R,C,black) :- color(R,C,black).
_drawcircle(R,C,white) :- color(R,C,white).

#show _drawcircle/3.
#show gridsize/1.
