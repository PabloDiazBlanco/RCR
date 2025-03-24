%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% yinyangKB.lp
%% Lógica principal del puzzle Yin Yang
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% --- Dominio: filas y columnas ---
row(R) :- gridsize(N), R = 1..N.
col(C) :- gridsize(N), C = 1..N.

%% -------------------------------------------------------------------
%% 1. Representación de color
{ color(R,C,black) ; color(R,C,white) } :- cell(R,C,free).
color(R,C,black) :- cell(R,C,fixedBlack).
color(R,C,white) :- cell(R,C,fixedWhite).

%% -------------------------------------------------------------------
%% 2. Restricción: Evitar que asignar blanco a una celda libre genere un bloque 2x2 blanco
%% Se revisan las cuatro orientaciones en las que la celda libre podría completar un bloque 2x2 blanco.

%% Si la celda (R,C) es la esquina inferior derecha de un bloque,
:- cell(R,C,free), gridsize(N), row(R), col(C), R > 1, C > 1,
   color(R-1,C-1,white), color(R-1,C,white), color(R,C-1,white), color(R,C,white).

%% Si la celda (R,C) es la esquina inferior izquierda,
:- cell(R,C,free), gridsize(N), row(R), col(C), R > 1, C < N,
   color(R-1,C,white), color(R-1,C+1,white), color(R,C+1,white), color(R,C,white).

%% Si la celda (R,C) es la esquina superior derecha,
:- cell(R,C,free), gridsize(N), row(R), col(C), R < N, C > 1,
   color(R,C-1,white), color(R+1,C-1,white), color(R+1,C,white), color(R,C,white).

%% Si la celda (R,C) es la esquina superior izquierda,
:- cell(R,C,free), gridsize(N), row(R), col(C), R < N, C < N,
   color(R,C+1,white), color(R+1,C,white), color(R+1,C+1,white), color(R,C,white).

%% -------------------------------------------------------------------
%% 3. Definición de adyacencia ortogonal
adj(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C + 1.
adj(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C - 1.
adj(R,C,R1,C) :- col(C), row(R), row(R1), R1 = R + 1.
adj(R,C,R1,C) :- col(C), row(R), row(R1), R1 = R - 1.

%% -------------------------------------------------------------------
%% 4. Conectividad de las celdas negras mediante un ancla
anchorBlack(R,C) :- cell(R,C,_), row(R), col(C), color(R,C,black), not existsBlackBefore(R,C).
existsBlackBefore(R,C) :- cell(R,C,_), row(R), col(C), row(R1), col(C1), color(R1,C1,black), R1 < R.
existsBlackBefore(R,C) :- cell(R,C,_), row(R), col(C), row(R1), col(C1), color(R1,C1,black), R1 = R, C1 < C.

reachableBlack(R,C) :- anchorBlack(R,C).
reachableBlack(R,C) :-
    reachableBlack(R2,C2),
    adj(R2,C2,R,C),
    color(R,C,black).

:- color(R,C,black), not reachableBlack(R,C).

%% -------------------------------------------------------------------
%% 5. Conectividad de las celdas blancas mediante un ancla
anchorWhite(R,C) :- cell(R,C,_), row(R), col(C), color(R,C,white), not existsWhiteBefore(R,C).
existsWhiteBefore(R,C) :- cell(R,C,_), row(R), col(C), row(R1), col(C1), color(R1,C1,white), R1 < R.
existsWhiteBefore(R,C) :- cell(R,C,_), row(R), col(C), row(R1), col(C1), color(R1,C1,white), R1 = R, C1 < C.

reachableWhite(R,C) :- anchorWhite(R,C).
reachableWhite(R,C) :-
    reachableWhite(R2,C2),
    adj(R2,C2,R,C),
    color(R,C,white).

:- color(R,C,white), not reachableWhite(R,C).

%% -------------------------------------------------------------------
%% 6. (No se incluyen weak constraints: se busca cualquier solución válida)

%% -------------------------------------------------------------------
%% 7. Mostrar la solución (para decode.py y display.py)
_drawcircle(R,C,black) :- color(R,C,black).
_drawcircle(R,C,white) :- color(R,C,white).

#show _drawcircle/3.
#show gridsize/1.
