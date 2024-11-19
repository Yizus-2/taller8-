# Nombre del ejecutable
TARGET = numerov_solver

# Compilador
CC = gcc

# Flags del compilador
CFLAGS = -std=c99 -Wall -Wextra -O2 -lm

# Archivos fuente
SRC = Oscilador.c

# Archivos objeto generados
OBJ = $(SRC:.c=.o)

# Requisitos de Python
REQUIREMENTS = requirements.txt

# Comprobaciones previas de herramientas necesarias
CHECK_PYTHON = $(shell command -v python3 2>/dev/null)
CHECK_PIP = $(shell command -v pip3 2>/dev/null)
CHECK_GCC = $(shell command -v gcc 2>/dev/null)

# Comandos específicos de instalación dependiendo de la distribución
DEBIAN_INSTALL = sudo apt-get update && sudo apt-get install -y gcc python3 python3-pip
FEDORA_INSTALL = sudo dnf install -y gcc python3 python3-pip

# Regla por defecto
all: check_tools install_deps $(TARGET)

# Comprobar si Python3, pip3 y gcc están instalados
check_tools:
	@echo "Verificando herramientas necesarias..."
	@if [ -z "$(CHECK_PYTHON)" ]; then echo "Error: Python3 no está instalado."; exit 1; fi
	@if [ -z "$(CHECK_PIP)" ]; then echo "Error: pip3 no está instalado."; exit 1; fi
	@if [ -z "$(CHECK_GCC)" ]; then echo "Error: gcc no está instalado."; exit 1; fi

# Regla para instalar las dependencias de Python
install_deps:
	@echo "Instalando dependencias de Python..."
	@pip3 install -r $(REQUIREMENTS)

# Regla para instalar herramientas necesarias en Debian
install_debian_tools:
	@echo "Instalando herramientas necesarias para Debian..."
	@$(DEBIAN_INSTALL)

# Regla para instalar herramientas necesarias en Fedora
install_fedora_tools:
	@echo "Instalando herramientas necesarias para Fedora..."
	@$(FEDORA_INSTALL)

# Regla para instalar herramientas necesarias en el sistema detectado
install_tools:
	@echo "Detectando el sistema operativo..."
	@if [ -f /etc/debian_version ]; then $(MAKE) install_debian_tools; \
	elif [ -f /etc/fedora-release ]; then $(MAKE) install_fedora_tools; \
	else echo "Error: Sistema operativo no soportado para instalación automática."; exit 1; fi

# Regla para compilar el ejecutable
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

# Regla para compilar archivos .c a .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Regla para limpiar archivos generados
clean:
	rm -f $(TARGET) $(OBJ) results_*.dat funciones_de_onda_multiples.png

# Regla para ejecutar el ejecutable y luego el script en Python
run: $(TARGET)
	./$(TARGET) 1.0  # Cambia el valor de E según sea necesario
	python3 grafica.py

# Regla de limpieza completa
distclean: clean
	rm -rf _pycache_ .pytest_cache
