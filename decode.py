#!/usr/bin/env python3
import sys
import re

def decode(kbfile, domainfile, outfile):
    """
    Ejemplo: invoca clingo y parsea su salida,
    luego genera un solXX.txt con la cuadrícula final.
    """
    import subprocess

    # Llamada a clingo
    cmd = ["clingo", kbfile, domainfile, "--outf=2", "--quiet=1"]
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print("Error al ejecutar clingo:", result.stderr, file=sys.stderr)
        return

    # Vamos a buscar en la salida JSON las ocurrencias de _drawcircle(R,C,Color)
    # Podríamos parsear JSON con 'json' en Python, pero para ser más simple
    # hacemos un 'grep' con regex. OJO, esto es muy rudimentario.
    # Lo ideal: usar json.loads(...) y buscar los predicados.
    pattern = r"_drawcircle\((\d+),(\d+),(black|white)\)"
    found = re.findall(pattern, result.stdout)

    # Necesitamos también gridsize(N)
    patternN = r"gridsize\((\d+)\)"
    foundN = re.findall(patternN, result.stdout)
    if not foundN:
        print("No se encontró gridsize(N) en la solución.", file=sys.stderr)
        return
    N = int(foundN[0])

    # Creamos una matriz NxN inicial de None
    matrix = [[None for _ in range(N)] for _ in range(N)]

    # Rellenamos con 0/1
    # Suponemos black -> '1', white -> '0'
    for (r_str, c_str, color) in found:
        r = int(r_str) - 1  # si en ASP empieza en 1
        c = int(c_str) - 1
        matrix[r][c] = '1' if color == 'black' else '0'

    # Si alguna celda quedó None, significa que no recibió color
    # (podría ser un puzzle mal planteado, o sin solución)
    for r in range(N):
        for c in range(N):
            if matrix[r][c] is None:
                matrix[r][c] = '0'  # o error, o lo que quieras

    # Guardamos en outfile
    with open(outfile, 'w') as out:
        for r in range(N):
            out.write("".join(matrix[r]) + "\n")


def main():
    if len(sys.argv) != 4:
        print("Uso: python3 decode.py <yinyangKB.lp> <domXX.lp> <solXX.txt>")
        sys.exit(1)

    kbfile = sys.argv[1]
    domainfile = sys.argv[2]
    outfile = sys.argv[3]
    decode(kbfile, domainfile, outfile)

if __name__ == "__main__":
    main()
