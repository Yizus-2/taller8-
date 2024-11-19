import sympy as sp
import matplotlib.pyplot as plt
import numpy as np

# Símbolos y función de Hermite
x, n = sp.symbols('x n')
hermite = sp.hermite(n, x)

# Cálculo de los primeros polinomios de Hermite
hermite_0 = hermite.subs(n, 0)
hermite_1 = hermite.subs(n, 1)
hermite_2 = hermite.subs(n, 2)
hermite_3 = hermite.subs(n, 3)

# Transformación de Hermite a funciones de onda
psi_0 = (1/sp.sqrt(sp.factorial(0))) * sp.exp(-x**2/2) * hermite_0
psi_1 = (1/sp.sqrt(sp.factorial(1))) * sp.exp(-x**2/2) * hermite_1
psi_2 = (1/sp.sqrt(sp.factorial(2))) * sp.exp(-x**2/2) * hermite_2
psi_3 = (1/sp.sqrt(sp.factorial(3))) * sp.exp(-x**2/2) * hermite_3

# Crear funciones numéricas a partir de las funciones de onda
psi_0_numeric = sp.lambdify(x, psi_0, "numpy")
psi_1_numeric = sp.lambdify(x, psi_1, "numpy")
psi_2_numeric = sp.lambdify(x, psi_2, "numpy")
psi_3_numeric = sp.lambdify(x, psi_3, "numpy")

# Crear puntos para las gráficas
x_values = np.linspace(-5, 5, 100)
y_values_0 = psi_0_numeric(x_values)
y_values_1 = psi_1_numeric(x_values)
y_values_2 = psi_2_numeric(x_values)
y_values_3 = psi_3_numeric(x_values)

# Representación gráfica de todas las funciones de onda
plt.figure()
plt.plot(x_values, y_values_0, label="n = 0")
plt.plot(x_values, y_values_1, label="n = 1")
plt.plot(x_values, y_values_2, label="n = 2")
plt.plot(x_values, y_values_3, label="n = 3")
plt.title("Funciones de onda para n = 0, 1, 2, 3")
plt.xlabel("x")
plt.ylabel("ψ(x)")
plt.legend()
plt.grid()
plt.show()



















