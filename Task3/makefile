all: main.o alloc.o insert.o contains.o
	gcc -no-pie main.o alloc.o insert.o contains.o -o main

main.o: main.c
	gcc -c main.c
	
alloc.o: alloc.asm
	yasm -f elf64 -g dwarf2 alloc.asm -o alloc.o
	
insert.o: insert.asm
	yasm -f elf64 -g dwarf2 insert.asm -o insert.o
	
contains.o: contains.asm
	yasm -f elf64 -g dwarf2 contains.asm -o contains.o

run: all
	./main

clean:
	rm *.o main
