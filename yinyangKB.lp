% Dominios: filas C columnas (n se define en domRR.lp generado por encode.pC)
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

% Caso base C recursivo: la raíz es alcanzable
reachable(Color,R,C) :- root(Color,R,C).
reachable(Color,R,C) :- reachable(Color,R1,C1), nbr(R1,C1,R,C), cell(R,C,Color).

% Restricción: toda celda debe ser alcanzable desde la raíz de su color
:- row(R), col(C), cell(R,C,Color), not reachable(Color,R,C).

% Restricción: no se permiten bloques 2R2 de celdas del mismo color
:- row(R), col(C), row(R1), col(C1), R1 = R+1, C1 = C+1,
   cell(R,C,Color), cell(R1,C,Color), cell(R,C1,Color), cell(R1,C1,Color).

%Lema1: impedimos cruces en un bloque 2R2:
:- row(R), col(C), row(R1), col(C1), R1 = R+1, C1 = C+1, cell(R,C,Color1), cell(R1,C1,Color1), cell(R1,C,Color2), cell(R,C1,Color2), Color1 != Color2.

% Para el dibujo: cada celda genera un único círculo con su color asignado
_drawcircle(R,C,Color) :- cell(R,C,Color).

#show _drawcircle/3.

% 1. Define which cells are on the border.
border(R,C) :- row(R), col(C), R = 0.
border(R,C) :- row(R), col(C), R = n.
border(R,C) :- row(R), col(C), C = 0.
border(R,C) :- row(R), col(C), C = n.

% 2. Define when two border cells are neighbors and have the same color.
border_neighbor(R,C,R1,C1,Color) :-
    border(R,C), border(R1,C1),
    nbr(R,C,R1,C1),
    cell(R,C,Color), cell(R1,C1,Color).

% 3. Choose a "base" cell on the border for each color.
border_base(R,C,Color) :-
    cell(R,C,Color),
    border(R,C),
    not not_border_base(R,C,Color).

% Auxiliary predicate: true if two cells have the same coordinates.
same_coords(R,C,R1,C1) :- row(R), col(C), row(R1), col(C1), R = R1, C = C1.

% 4. Prevent multiple bases in the same contiguous group.
not_border_base(R,C,Color) :-
    cell(R,C,Color), border(R,C),
    border_base(R1,C1,Color),
    not same_coords(R,C,R1,C1).

% 5. Define border reachability:
border_reachable(R,C,Color) :- border_base(R,C,Color).
border_reachable(R,C,Color) :-
    border_reachable(R1,C1,Color), border_neighbor(R1,C1,R,C,Color).

% 6. Constraint: every border cell must be reachable (i.e., part of a single contiguous block per color).
:- cell(R,C,Color), border(R,C), not border_reachable(R,C,Color).
