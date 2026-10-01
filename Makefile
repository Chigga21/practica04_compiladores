CC     = gcc
CFLAGS = -Wall -Wextra
FLEX   = flex
TYPST  = typst

.PHONY: test report clean

scanner: lex.yy.c scanner.c scanner.h
	$(CC) $(CFLAGS) -o scanner lex.yy.c scanner.c

lex.yy.c: scanner.l scanner.h
	$(FLEX) scanner.l

test: scanner temp
	sh tests/run.sh

temp:
	mkdir -p temp

clean:
	rm -f scanner lex.yy.c
	rm -rf temp
