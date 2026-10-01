#!/bin/sh
set -eu

cd "$(dirname "$0")/.."
mkdir -p temp
scanner_command=${SCANNER:-./scanner}
passed=0

check() {
    name=$1
    expected_status=$2
    actual_status=0

    timeout 5 "$scanner_command" < "tests/$name.chl" \
        > "temp/$name.out" 2> "temp/$name.err" || actual_status=$?

    if [ "$actual_status" -ne "$expected_status" ]; then
        printf 'fallo: %s, salida esperada %s, obtenida %s\n' \
            "$name" "$expected_status" "$actual_status" >&2
        cat "temp/$name.err" >&2
        exit 1
    fi

    if [ -s "temp/$name.err" ]; then
        cat "temp/$name.err" >&2
        exit 1
    fi

    diff -u "tests/$name.expected" "temp/$name.out"
    printf 'ok: %s (salida %s)\n' "$name" "$actual_status"
    passed=$((passed + 1))
}

for name in programa limites tokens literales numeros comentarios \
    vacio espacios string_eof char_eof linea_eof bloque_eof; do
    check "$name" 0
done

for name in errores numeros_invalidos literales_invalidos unicode_invalido \
    string_abierto_eof char_abierto_eof comentario_abierto_eof crlf; do
    check "$name" 1
done

printf '%s pruebas correctas\n' "$passed"
