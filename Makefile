build:
	nasm -f macho64 game.asm
	gcc game.o -g -o game
	# ld -macosx_version_min 10.7.0 -lc -e _main -o game game.o
