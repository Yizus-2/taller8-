# Nombre del ejecutable
TARGET = numerov_solver

# Compilador
CC = gcc

# Flags del compilador
CFLAGS = -std=c99 -Wall -Wextra -O2 -lm

# Archivos 
SRC = oscilador.c

# Archivos generados
OBJ = $(SRC:.c=.o)

# Regla 
all: install-dependencies $(TARGET)

# Regla para instalar dependencias 
install-dependencies:
	@echo "Instalando dependencias..."
	@sudo apt-get update
	@sudo apt-get install -y gcc python3 python3-pip
	@pip3 install matplotlib numpy

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
clean:
	rm -f $(TARGET) $(OBJ) results.dat
distclean: clean
