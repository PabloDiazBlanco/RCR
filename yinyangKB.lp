%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% yinyangKB.lp - Knowledge Base Mejorada para el Puzzle Yin Yang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Dominio: Definir filas y columnas a partir de gridsize(N)
row(R) :- gridsize(N), R = 1..N.
col(C) :- gridsize(N), C = 1..N.

%% Representación de colores:
{ color(R,C,black); color(R,C,white) } :- cell(R,C,free).
color(R,C,black) :- cell(R,C,fixedBlack).
color(R,C,white) :- cell(R,C,fixedWhite).

%% Restricción: No se permiten bloques 2x2 homogéneos (para ambos colores)
:- row(R), col(C), gridsize(N), R < N, C < N,
   color(R,C,black), color(R,C+1,black), color(R+1,C,black), color(R+1,C+1,black).

:- row(R), col(C), gridsize(N), R < N, C < N,
   color(R,C,white), color(R,C+1,white), color(R+1,C,white), color(R+1,C+1,white).

%% Conectividad de celdas negras
%% Definir adyacencia ortogonal
adj(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C+1.
adj(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C-1.
adj(R,C,R1,C) :- row(R), col(C), row(R1), R1 = R+1.
adj(R,C,R1,C) :- row(R), col(C), row(R1), R1 = R-1.

%% Seleccionar el ancla para las celdas negras: la primera en orden lexicográfico
anchorBlack(R,C) :- color(R,C,black), not existsBlackBefore(R,C).
existsBlackBefore(R,C) :- color(R,C,black), row(R1), col(C1), color(R1,C1,black), R1 < R.
existsBlackBefore(R,C) :- color(R,C,black), row(R1), col(C1), color(R1,C1,black), R1 = R, C1 < C.

%% Propagar la conectividad: toda celda negra debe ser alcanzable desde el ancla
reachableBlack(R,C) :- anchorBlack(R,C).
reachableBlack(R,C) :- reachableBlack(R1,C1), adj(R1,C1,R,C), color(R,C,black).

:- color(R,C,black), not reachableBlack(R,C).

%% Conectividad de celdas blancas
anchorWhite(R,C) :- color(R,C,white), not existsWhiteBefore(R,C).
existsWhiteBefore(R,C) :- color(R,C,white), row(R1), col(C1), color(R1,C1,white), R1 < R.
existsWhiteBefore(R,C) :- color(R,C,white), row(R1), col(C1), color(R1,C1,white), R1 = R, C1 < C.

reachableWhite(R,C) :- anchorWhite(R,C).
reachableWhite(R,C) :- reachableWhite(R1,C1), adj(R1,C1,R,C), color(R,C,white).

:- color(R,C,white), not reachableWhite(R,C).

%% Salida: Definir _drawcircle/3 para que decode.py lo use
_drawcircle(R,C,black) :- color(R,C,black).
_drawcircle(R,C,white) :- color(R,C,white).

#show _drawcircle/3.
#show gridsize/1.
