#!/usr/bin/env python3
import sys
import re
import json

def decode(kbfile, domainfile, outfile):
    """
    Invoca clingo para obtener la solución y la decodifica en un fichero de salida.
    Se usa el modo JSON (--outf=2) para parsear la salida.
    """
    import subprocess

    cmd = ["clingo", kbfile, domainfile, "--outf=2", "--quiet=1"]
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print("Error al ejecutar clingo:", result.stderr, file=sys.stderr)
        return

    # Intentamos parsear la salida JSON
    try:
        output_json = json.loads(result.stdout)
    except json.JSONDecodeError as e:
        print("Error al parsear JSON:", e, file=sys.stderr)
        return

    # Extraemos la solución (asumimos que hay al menos un answer set)
    if "Call" not in output_json or not output_json["Call"]:
        print("No se encontró ninguna llamada en la salida de clingo.", file=sys.stderr)
        return

    answer_sets = output_json["Call"][0]["Witnesses"]
    if not answer_sets:
        print("No se encontró ninguna solución (answer set).", file=sys.stderr)
        return

    # Tomamos el primer answer set
    atoms = answer_sets[0]["Value"]

    # Extraemos gridsize
    gridsize_pattern = r"gridsize\((\d+)\)"
    N = None
    for atom in atoms:
        m = re.match(gridsize_pattern, atom)
        if m:
            N = int(m.group(1))
            break
    if N is None:
        print("No se encontró gridsize(N) en la solución.", file=sys.stderr)
        return

    # Creamos una matriz N x N inicial con '0' por defecto.
    matrix = [['0' for _ in range(N)] for _ in range(N)]
    
    # Procesamos los átomos _drawcircle(R,C,Color)
    draw_pattern = r"_drawcircle\((\d+),(\d+),(black|white)\)"
    for atom in atoms:
        m = re.match(draw_pattern, atom)
        if m:
            r = int(m.group(1)) - 1  # Ajustamos a índice 0-based
            c = int(m.group(2)) - 1
            matrix[r][c] = '1' if m.group(3) == 'black' else '0'
    
    # Escribimos la matriz en el fichero de salida.
    with open(outfile, 'w') as out:
        for row in matrix:
            out.write("".join(row) + "\n")

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
