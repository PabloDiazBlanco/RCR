#!/usr/bin/env python3
import sys

def main():
    if len(sys.argv) < 3:
        print("Uso: python3 encode.py domXX.txt domXX.lp")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Leer líneas no vacías del archivo de instancia
    with open(input_file, 'r') as f:
        lines = [line.rstrip("\n") for line in f if line.strip() != ""]
    # Número de filas (se asume que es un tablero cuadrado)
    n_lines = len(lines)
    # La constante n se define como el máximo índice, es decir, n_lines - 1.
    max_index = n_lines - 1

    with open(output_file, 'w') as out:
        # Escribir la definición de la constante n y el tamaño del tablero (gridsize)
        out.write(f"#const n = {max_index}.\n")
        out.write(f"gridsize({n_lines}).\n")
        # Para cada celda fija, según el contenido del archivo (1 = black, 0 = white)
        for i, line in enumerate(lines):
            for j, ch in enumerate(line):
                if ch == '1':
                    out.write(f"fixed({i},{j},black).\n")
                elif ch == '0':
                    out.write(f"fixed({i},{j},white).\n")
    print(f"Instancia codificada con n = {max_index} y gridsize = {n_lines} en {output_file}.")

if __name__ == '__main__':
    main()
