#!/usr/bin/env python3
import sys

def main():
    if len(sys.argv) < 3:
        print("Uso: python3 encode.py domXX.txt domXX.lp")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Leer las líneas no vacías del archivo de entrada
    with open(input_file, 'r') as f:
        lines = [line.rstrip("\n") for line in f if line.strip() != ""]
    n = len(lines)
    
    # Comprobar que cada línea tenga la misma longitud que el número total de líneas
    for line in lines:
        if len(line) != n:
            print("Error: todas las líneas deben tener longitud igual al número total de líneas.")
            sys.exit(1)

    with open(output_file, 'w') as out:
        # Escribir la dimensión del tablero
        out.write(f"gridsize({n}).\n")
        # Para cada celda fija, generar el hecho correspondiente
        # Se usa índice 0 para la primera fila y la primera columna.
        for i, line in enumerate(lines):
            for j, ch in enumerate(line):
                if ch == '1':
                    out.write(f"fixed({i},{j},black).\n")
                elif ch == '0':
                    out.write(f"fixed({i},{j},white).\n")
    print(f"Instancia codificada con grid size {n} en {output_file}.")

if __name__ == '__main__':
    main()
