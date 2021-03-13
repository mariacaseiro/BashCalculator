#!/bin/sh
#CALCULADORA EN BASH: SUMA, RESTA Y MULTIPLICA
#Autora: María Caseiro Arias

#Variables principales
op1=0
op2=0
operacion=''


separador() {
    #separamos los operandos del operador
    op1=$(echo $1 | sed -E 's/([+]|[-]|[*])/\n/g' | tr "n" "\n" | sed -n 1p)
    op2=$(echo $1 | sed -E 's/([+]|[-]|[*])/\n/g' | tr "n" "\n" | sed -n 2p)
}

decimales() {
    #separamos la parte decimal
    decOp=$(echo $1 | grep -Eo '([.][0-9]+)')
    #contamos el num de caracteres
    longitud=$(echo "$((10#${#decOp} - 1))")
}

#MAIN---------------------------------------------------------------

if [[ $# -ne 0 ]]; then #comprobamos el numero de argumentos
    operacion=$1
else #si no existe argumento se pide la operacion
    echo "Introducir operación:"
    read operacion
fi

separador $operacion

#anhadimos .0 a los elementos sin decimales
if [[ $op1 != *"."* ]]; then
    op1=$(echo $op1 | sed -e 's/$/.0/')
fi
if [[ $op2 != *"."* ]]; then
    op2=$(echo $op2 | sed -e 's/$/.0/')
fi

decimales $op1
tam1=$longitud

decimales $op2
tam2=$longitud

tam=$(echo "$((10#$tam2 - $tam1))")

#quitamos el punto
op1=$(echo "${op1//.}")
op2=$(echo "${op2//.}")

#anhadimos los ceros, tantos ceros como diferencia entre decimales
if [[ $tam -gt 0 ]]; then #-gt greather than
    for  (( c=0; c<$tam; c++ ))
    do
       op1=$(echo $op1 | sed 's/$/0/')
    done
elif [[ $tam -lt 0 ]]; then
    tam=$(echo "$(($tam1 - $tam2))")
    for (( c=0; c<$tam; c++ ))
    do
        op2=$(echo $op2 | sed 's/$/0/')
    done
fi

#Realizamos la operacion indicada
#suma
if [[ $operacion == *"+"* ]]; then
    resultado=$(echo "$((10#$op1 + 10#$op2))")
fi
#multiplicacion
if [[ $operacion == *"*"* ]]; then
    resultado=$(echo "$((10#$op1 * 10#$op2))")
fi
#resta
if [[ $operacion == *"-"* ]]; then
    resultado=$(echo "$((10#$op1 - 10#$op2))")
fi

#Anhadir el punto decimal en todos los casos posibles
if [[ $operacion == *"*"* ]]; then
    if [[ $tam2 -gt $tam1 ]]; then
        dec=$(echo "$(($tam2 * 2))")
        longitud=$(echo "$((${#resultado} - $dec))")
    else
        dec=$(echo "$(($tam1 * 2))")
        longitud=$(echo "$((${#resultado} - $dec))")
    fi
    final=$(echo $resultado | sed -E "s/([0-9]{$longitud})([0-9]{$dec})/\\1.\\2/g") #añadimos el punto decimal
else
    if [[ $tam2 -gt $tam1 ]]; then
        dec=$tam2
        longitud=$(echo "$((${#resultado} - $dec))")
    else
        dec=$tam1
        longitud=$(echo "$((${#resultado} - $dec))")
    fi
    if [[ $resultado == *"-"* ]]; then
        longitud="$(($longitud - 1))"
        final=$(echo $resultado | sed -E "s/(-[0-9]{$longitud})([0-9]{$dec})/\\1.\\2/g") #añadimos el punto decimal
    else
        final=$(echo $resultado | sed -E "s/([0-9]{$longitud})([0-9]{$dec})/\\1.\\2/g") #añadimos el punto decimal
    fi
fi

#eliminar elementos restantes
final=$(echo -n $final | sed -E 's/(\.0*$)|(\.$)|(0*$)//g')
#final=$(echo $final | sed -E 's/0*$//')
#final=$(echo $final | sed -E 's/\.$//')

echo $final
