CC = clang-13
CFLAGS = -std=c11 -O3 -glldb -Wall -Wextra -Wstrict-aliasing
# I'm not sure what these are for.  They came with the project.
CFLAGS += -Wno-pointer-arith -Wno-newline-eof -Wno-unused-parameter -Wno-gnu-statement-expression
CFLAGS += -Wno-gnu-compound-literal-initializer -Wno-gnu-zero-variadic-macro-arguments
CFLAGS += -Ilib/cglm/include -Ilib/glad/include -Ilib/glfw/include -Ilib/stb -Ilib/noise -fbracket-depth=1024
LDFLAGS = lib/glad/src/glad.o lib/cglm/libcglm.a lib/glfw/src/libglfw3.a lib/noise/libnoise.a -lm
LDFLAGS += -ldl -lpthread

SRC  = $(wildcard src/**/*.c) $(wildcard src/*.c) $(wildcard src/**/**/*.c) $(wildcard src/**/**/**/*.c)
OBJ  = $(SRC:.c=.o)
BIN = bin

.PHONY: help release clean

help:
	@echo "Hello!  Available options are:\n"\
		"\t\033[1mhelp\033[m:  Show this blurb.\n"\
		"\t\033[1mrelease\033[m:  Build an executable.\n"\
		"\t\033[1mdebug\033[m:  \033[33mNot currently used.\033[m\n"\
		"\t\033[1minstall\033[m:  Install the game.  \033[31mDoesn't work yet.  Requires superuser privileges.\033[m\n"\
		"\t\033[1mclean\033[m:  Get rid of object files and executables.  Does not uninstall the game.\n"

release: _libs _dirs _game

_libs:
	cd lib/cglm && cmake . -DCGLM_STATIC=ON && make
	cd lib/glad && $(CC) -o src/glad.o -Iinclude -c src/glad.c
	cd lib/glfw && cmake . && make
	cd lib/noise && make

_dirs:
	mkdir -p ./$(BIN)

_game: $(OBJ)
	$(CC) -o $(BIN)/game $^ $(LDFLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -r $(BIN) $(OBJ)

debug:
	@echo "This has not yet been implemented."

install:
	@echo "This has not yet been implemented."
