% Dominios: filas y columnas (n se define en domXX.lp generado por encode.py)
row(0..n).
col(0..n).

% Definir colores en una única línea
color(black;white).

% Asignación libre de color a cada celda
1{ cell(R,C,black); cell(R,C,white) }1 :- row(R), col(C).

% Vecinos inmediatos (4-adjacent)
nbr(R,C,R1,C) :- row(R), row(R1), col(C), R1 = R+1.
nbr(R,C,R1,C) :- row(R), row(R1), col(C), R1 = R-1.
nbr(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C+1.
nbr(R,C,R,C1) :- row(R), col(C), col(C1), C1 = C-1.

% neighboord: vecinos inmediatos que tienen el mismo color
neighboord(R,C,R1,C1) :- nbr(R,C,R1,C1), cell(R,C,Color), cell(R1,C1,Color).

% Conectividad: se define la celda "menor" (lower) para determinar la raíz (root)
1 { root(Color,R,C) : cell(R,C,Color) } 1 :- color(Color).

% Caso base y recursivo: la raíz es alcanzable
reachable(Color,R,C) :- root(Color,R,C).
reachable(Color,R,C) :- reachable(Color,R1,C1), nbr(R1,C1,R,C), cell(R,C,Color).

% Restricción: toda celda debe ser alcanzable desde la raíz de su color
:- row(R), col(C), cell(R,C,Color), not reachable(Color,R,C).

% Restricción: no se permiten bloques 2x2 de celdas del mismo color
:- row(R), col(C), row(R1), col(C1), R1 = R+1, C1 = C+1,
   cell(R,C,Color), cell(R1,C,Color), cell(R,C1,Color), cell(R1,C1,Color).

% Para el dibujo: cada celda genera un único círculo con su color asignado
_drawcircle(R,C,Color) :- cell(R,C,Color).

#show _drawcircle/3.
