#!/usr/bin/env python3
import sys

def encode(infile, outfile):
    lines = []
    # Leemos el archivo de entrada y eliminamos líneas vacías
    try:
        with open(infile, 'r') as f:
            for line in f:
                line = line.strip()
                if line:
                    lines.append(line)
    except Exception as e:
        print("Error al leer el archivo:", e, file=sys.stderr)
        sys.exit(1)

    N = len(lines)
    if N == 0:
        print("Error: fichero vacío", file=sys.stderr)
        sys.exit(1)

    M = len(lines[0])
    for idx, row in enumerate(lines):
        if len(row) != M:
            print("Error: filas de longitudes distintas en la línea", idx+1, file=sys.stderr)
            sys.exit(1)
    if N != M:
        print("Aviso: no es un tablero cuadrado NxN, sino N={} y M={}".format(N, M), file=sys.stderr)

    # Escribimos el dominio en el archivo de salida
    try:
        with open(outfile, 'w') as out:
            out.write(f"gridsize({N}).\n")
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
            out.write(f"#const n = {N-1}.\n")
    except Exception as e:
        print("Error al escribir el archivo:", e, file=sys.stderr)
        sys.exit(1)

def main():
    if len(sys.argv) != 3:
        print("Uso: python3 encode.py <input.txt> <output.lp>")
        sys.exit(1)
    infile = sys.argv[1]
    outfile = sys.argv[2]
    encode(infile, outfile)

if __name__ == "__main__":
    main()
