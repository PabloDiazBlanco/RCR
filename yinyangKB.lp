%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% yinyangKB.lp
%% Lógica principal del puzzle Yin Yang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% --- Dominio: filas y columnas ---
row(R) :- gridsize(N), R = 1..N.
col(C) :- gridsize(N), C = 1..N.

%% -------------------------------------------------------------------
%% 1. Representación de color
%% -------------------------------------------------------------------
%% Se asume que en el dominio (domXX.lp) vienen hechos:
%%   gridsize(N).
%%   cell(R,C,fixedBlack) / cell(R,C,fixedWhite) / cell(R,C,free).

%% Para celdas libres se decide entre negro o blanco.
{ color(R,C,black) ; color(R,C,white) } :- cell(R,C,free).

%% Para celdas fijas, se fuerza el color.
color(R,C,black) :- cell(R,C,fixedBlack).
color(R,C,white) :- cell(R,C,fixedWhite).

%% -------------------------------------------------------------------
%% 2. Restricción: No se permiten bloques 2x2 del mismo color
%% -------------------------------------------------------------------
:- gridsize(N), row(R), col(C), R < N, C < N,
   color(R,C,Color),
   color(R+1,C,Color),
   color(R,C+1,Color),
   color(R+1,C+1,Color).

%% -------------------------------------------------------------------
%% 3. Definición de adyacencia ortogonal
%% -------------------------------------------------------------------
adj(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C+1.
adj(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C-1.
adj(R,C,R1,C) :- col(C), row(R), row(R1), R1 = R+1.
adj(R,C,R1,C) :- col(C), row(R), row(R1), R1 = R-1.

%% -------------------------------------------------------------------
%% 4. Conectividad de las celdas negras
%% -------------------------------------------------------------------
%% Se selecciona la "celda base" negra (la primera en orden lexicográfico).
baseBlack(R,C) :-
    row(R), col(C),
    color(R,C,black),
    not smallerBlack(R,C).

%% Para hacer seguras las variables R y C, incluimos row(R) y col(C) en el cuerpo.
smallerBlack(R,C) :- row(R), col(C), color(R2,C2,black), row(R2), col(C2), R2 < R.
smallerBlack(R,C) :- row(R), col(C), color(R2,C2,black), row(R2), col(C2), R = R2, C2 < C.

%% Celdas negras alcanzables desde la base.
reachableBlack(R,C) :- baseBlack(R,C).
reachableBlack(R,C) :-
    reachableBlack(R2,C2),
    adj(R2,C2,R,C),
    color(R,C,black).

%% Restricción: toda celda negra debe ser alcanzable.
:- color(R,C,black), not reachableBlack(R,C).

%% -------------------------------------------------------------------
%% 5. Conectividad de las celdas blancas
%% -------------------------------------------------------------------
baseWhite(R,C) :-
    row(R), col(C),
    color(R,C,white),
    not smallerWhite(R,C).

smallerWhite(R,C) :- row(R), col(C), color(R2,C2,white), row(R2), col(C2), R2 < R.
smallerWhite(R,C) :- row(R), col(C), color(R2,C2,white), row(R2), col(C2), R = R2, C2 < C.

reachableWhite(R,C) :- baseWhite(R,C).
reachableWhite(R,C) :-
    reachableWhite(R2,C2),
    adj(R2,C2,R,C),
    color(R,C,white).

:- color(R,C,white), not reachableWhite(R,C).

%% -------------------------------------------------------------------
%% 6. Mostrar la solución (para decode.py y display.py)
%% -------------------------------------------------------------------
_drawcircle(R,C,black) :- color(R,C,black).
_drawcircle(R,C,white) :- color(R,C,white).

#show _drawcircle/3.
#show gridsize/1.
