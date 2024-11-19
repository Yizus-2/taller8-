CC = gcc
CFLAGS = -Wall -lm
TARGET = taller8-
SRC = oscilador.c
PYTHON_SCRIPT = graficar_resultados.py
VENV_DIR = .venv
 
# Detección de sistema operativo
OS := $(shell uname -s)
 
# Variables para verificar dependencias
PYTHON_CMD := $(shell which python3 2>/dev/null || which python 2>/dev/null)
GCC_CMD := $(shell which gcc 2>/dev/null)
EOG_CMD := $(shell which eog 2>/dev/null)
 
.PHONY: all clean venv run_c run_python view_image check_dependencies install_dependencies
 
all: check_dependencies run_c run_python
 
# Verificar dependencias
check_dependencies: install_dependencies
	@echo "Verificando dependencias..."
 
# Instalar dependencias según el sistema operativo
install_dependencies:
ifeq ($(OS), Linux)
	@if [ -z "$(GCC_CMD)" ]; then \
		echo "Instalando gcc..."; \
		sudo apt-get update && sudo apt-get install -y gcc; \
	fi
	@if [ -z "$(PYTHON_CMD)" ]; then \
		echo "Instalando Python..."; \
		sudo apt-get update && sudo apt-get install -y python3 python3-pip python3-venv; \
	fi
	@if [ -z "$(EOG_CMD)" ]; then \
		echo "Instalando eog..."; \
		sudo apt-get update && sudo apt-get install -y eog; \
	fi
else ifeq ($(OS), Darwin)
	@if [ -z "$(GCC_CMD)" ]; then \
		echo "Instalando gcc..."; \
		xcode-select --install; \
	fi
	@if [ -z "$(PYTHON_CMD)" ]; then \
		echo "Instalando Python..."; \
		brew install python3; \
	fi
else ifeq ($(OS), Windows_NT)
	@echo "En Windows, por favor instala manualmente Python, GCC (MinGW) y un visor de imágenes"
endif
 
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) -lm
 
venv: $(VENV_DIR)/bin/activate
 
$(VENV_DIR)/bin/activate:
ifeq ($(OS), Darwin) # macOS
	python3 -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install -r requirements.txt
else ifeq ($(OS), Linux) # Linux
	python3 -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install -r requirements.txt
else ifeq ($(OS), Windows_NT) # Windows
	python -m venv $(VENV_DIR)
	$(VENV_DIR)\Scripts\pip install -r requirements.txt
endif
 
run_c: $(TARGET)
ifeq ($(OS), Windows_NT)
	$(TARGET).exe
else
	./$(TARGET)
endif
 
run_python: venv
ifeq ($(OS), Windows_NT)
	$(VENV_DIR)\Scripts\python $(PYTHON_SCRIPT)
else
	$(VENV_DIR)/bin/python3 $(PYTHON_SCRIPT)
endif
	$(MAKE) view_image
 
view_image:
ifeq ($(OS), Darwin) # macOS
	open grafica.png
else ifeq ($(OS), Linux) # Linux
	if [ -x "$(EOG_CMD)" ]; then \
		eog grafica.png; \
	else \
		xdg-open grafica.png; \
	fi
else ifeq ($(OS), Windows_NT) # Windows
	start grafica.png
endif
 
clean:
	rm -f $(TARGET)
	rm -rf $(VENV_DIR)
	rm -f datos_n0.txt datos_n1.txt datos_n2.txt datos_n3.txt grafica.png
ifeq ($(OS), Windows_NT)
	del /f $(TARGET).exe
endif
