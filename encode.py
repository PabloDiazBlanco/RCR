#!/usr/bin/env python3
import sys

def encode(infile, outfile):
    lines = []
    with open(infile, 'r') as f:
        for line in f:
            line = line.strip()
            if line:
                lines.append(line)

    N = len(lines)
    if N == 0:
        print("Error: fichero vacío", file=sys.stderr)
        return

    M = len(lines[0])
    for row in lines:
        if len(row) != M:
            print("Error: filas de longitudes distintas", file=sys.stderr)
            return
    if N != M:
        print("Aviso: no es un tablero cuadrado NxN, sino N=%d, M=%d" % (N, M))

    with open(outfile, 'w') as out:
        # Escribimos gridsize
        out.write(f"gridsize({N}).\n")
        # Para cada celda, generamos un hecho cell(R,C,Tipo)
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
                    print(f"Advertencia: carácter desconocido '{char}' en fila {r+1} columna {c+1}", file=sys.stderr)

def main():
    if len(sys.argv) != 3:
        print("Uso: python3 encode.py <input.txt> <output.lp>")
        sys.exit(1)
    infile = sys.argv[1]
    outfile = sys.argv[2]
    encode(infile, outfile)

if __name__ == "__main__":
    main()
