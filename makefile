build:
	flex olympicGame.lex
	gcc -c lex.yy.c
	gcc -o olympicGame.exe lex.yy.c

run:
	./olympicGame.exe input.txt
clean:
	rm *.o
	rm *.exe
	rm lex.yy.c