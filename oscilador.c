#include <stdio.h>
#include <math.h>

#define N 1000 // Número de puntos de la malla
#define h 0.01 // Tamaño del paso en la malla
#define omega 1.0 // Frecuencia angular del oscilador armónico

void numerov(double *psi, double *V, double E, int n) {
    double factor = 1.0 / 12.0;

    psi[0] = 0.0; // Condición inicial
    psi[1] = 1.0; // Otra condición inicial arbitraria

    for (int i = 1; i < n - 1; i++) {
        psi[i + 1] = (2.0 * (1.0 - 5.0 * h * h * (E - V[i])) * psi[i] - (1.0 + h * h * (E - V[i - 1])) * psi[i - 1]) / (1.0 + h * h * (E - V[i + 1]));
    }
}

int main() {
    double V[N];
    int n_values[] = {0, 1, 2, 3};
    int num_n_values = sizeof(n_values) / sizeof(n_values[0]);

    // Definir el potencial V(x) del oscilador armónico
    for (int i = 0; i < N; i++) {
        V[i] = 0.5 * omega * omega * i * i * h * h;
    }

    for (int k = 0; k < num_n_values; k++) {
        double psi[N];
        int n = n_values[k];

        // Calcular la función de onda para el valor de n actual
        numerov(psi, V, n, N);

        // Crear un archivo de texto para guardar los resultados
        char filename[50];
        sprintf(filename, "funcion_de_onda_n%d.txt", n);

        FILE *outputFile = fopen(filename, "w");
        if (outputFile == NULL) {
            perror("Error al abrir el archivo");
            return 1;
        }

        // Escribir la función de onda en el archivo
        fprintf(outputFile, "Función de onda para n = %d:\n", n);
        for (int i = 0; i < N; i++) {
            fprintf(outputFile, "%lf %lf\n", i * h, psi[i]);
        }

        // Cerrar el archivo
        fclose(outputFile);

        printf("Los resultados para n=%d se han guardado en '%s'\n", n, filename);
    }

    return 0;
}