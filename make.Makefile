# Nombre del ejecutable
TARGET = numerov_solver

# Compilador
CC = gcc

# Flags del compilador
CFLAGS = -std=c99 -Wall -Wextra -O2 -lm

# Archivos fuente
SRC = oscilador.c

# Archivos objeto generados
OBJ = $(SRC:.c=.o)

# Regla por defecto
all: install-dependencies $(TARGET)

# Regla para instalar dependencias necesarias
install-dependencies:
	@echo "Instalando dependencias..."
	@sudo apt-get update
	@sudo apt-get install -y gcc python3 python3-pip
	@pip3 install matplotlib numpy

# Regla para compilar el ejecutable
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

# Regla para compilar archivos .c a .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Regla para limpiar archivos generados
clean:
	rm -f $(TARGET) $(OBJ) results.dat

# Regla de limpieza completa
distclean: clean