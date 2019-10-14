all: main.o alloc.o
	gcc -no-pie main.o alloc.o -o main

main.o: main.c
	gcc -c main.c
	
alloc.o: alloc.asm
	yasm -f elf64 -g dwarf2 alloc.asm -o alloc.o

run: all
	./main

clean:
	rm *.o main
