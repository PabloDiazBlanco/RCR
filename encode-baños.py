import sys
def abrir_archivo(archivo):
    try:
        with open(archivo) as f:
            text = f.read()
            partes = text.split("\n")
            fichas = []
            fila = 0
            for i in partes:
                if i != "":
                    for j in range(len(i)):
                        if i[j] == "0":
                            fichas.append((fila,j,str("white")))
                        elif i[j] == "1":
                            fichas.append((fila,j,str('black')))
                    fila +=1
    except:
        print("No hay archivo")
    return fichas,fila

def crear_archivo(archivo):
    with open(archivo,"w") as f:
        f.write(f"gridsize({longitud}).\n")
        for ficha in fichas:
            f.write(f"_drawcircle({ficha[0]},{ficha[1]},{ficha[2]}).\n")
        f.write(f"#const n = {longitud-1}.")
       

try:
    fichas,longitud = abrir_archivo(sys.argv[1])
    crear_archivo(sys.argv[2])
except:
    print("")

