# Intel® Software Development Emulator (support AVX2)
# http://software.intel.com/en-us/articles/intel-software-development-emulator/
SDE=../sde-hsw-external-4.46.0-2011-12-15-lin-intel64-and-ia32/sde

gather: gather.c gather.o
	gcc -g3 -O0 gather.c gather.o -o gather

gather.o: gather.asm
	yasm -g DWARF2 -f ELF64 gather.asm

exec: gather
	$(SDE) -- ./gather

clean:
	rm -f gather.o gather