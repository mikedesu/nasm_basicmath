all: test

test:
	nasm -f elf64 -g test.asm
	gcc -no-pie test.o -o test

clean:
	rm -rfv test test.o

