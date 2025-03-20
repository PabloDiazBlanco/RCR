#!/usr/bin/env python3
import sys

def encode(infile, outfile):
    lines = []
    with open(infile, 'r') as f:
        for line in f:
            # Quitamos saltos de línea
            line = line.strip()
            if line:
                lines.append(line)

    # Suponiendo que el número de filas es el número de líneas
    # y el número de columnas es la longitud de cada línea
    N = len(lines)
    if N == 0:
        print("Error: fichero vacío", file=sys.stderr)
        return

    # Comprobamos que todas las líneas tienen la misma longitud
    M = len(lines[0])
    for row in lines:
        if len(row) != M:
            print("Error: filas de longitudes distintas", file=sys.stderr)
            return
    if N != M:
        print("Aviso: no es un tablero cuadrado NxN, sino N=%d, M=%d" % (N, M))

    with open(outfile, 'w') as out:
        # 1) gridsize(N)
        out.write(f"gridsize({N}).\n")

        # 2) Por cada fila/columna, escribimos un hecho cell(R,C, ...)
        #    R y C empezando en 1 (opcional, pero común en ASP)
        for r in range(N):
            for c in range(M):
                char = lines[r][c]
                if char == '.':
                    out.write(f"cell({r+1},{c+1},free).\n")
                elif char == '0':
                    out.write(f"cell({r+1},{c+1},fixedWhite).\n")
                elif char == '1':
                    out.write(f"cell({r+1},{c+1},fixedBlack).\n")
                else:
                    print(f"Advertencia: carácter desconocido '{char}' en fila {r} col {c}", file=sys.stderr)

def main():
    if len(sys.argv) != 3:
        print("Uso: python3 encode.py <input.txt> <output.lp>")
        sys.exit(1)

    infile = sys.argv[1]
    outfile = sys.argv[2]
    encode(infile, outfile)

if __name__ == "__main__":
    main()
