"""
Transformar matrices con Gauss Elimination™ y resolver sistemas de ecuaciones.
Leonardo Corona Garza
"""

import math


def tabulate(matrix: list[list[float]], decimal_places: int | None = 5) -> str:
    def mapper(x: float) -> str:
        if decimal_places is not None:
            x = round(x, decimal_places)
        return str(x)

    spaces = [[0 for _ in row] for row in matrix]
    matrix = [list(map(mapper, row)) for row in matrix]

    # Saber cuánto se debe espaciar cada elemento
    for j in range(len(matrix[0])):
        char_counts = list(map(lambda row: len(row[j]), matrix))
        largest = max(char_counts)
        for i, char_count in enumerate(char_counts):
            spaces[i][j] = largest - char_count

    # Armar la matriz
    total_space = sum(spaces[0]) + sum(map(len, matrix[0])) + len(matrix[0]) * 2 + 2
    resp = "┌" + ' ' * total_space + '┐\n'
    for row, row_spaces in zip(matrix, spaces):
        resp += '|  '
        for element, element_space in zip(row, row_spaces):
            resp += element + ' ' * (element_space + 2)
        resp += '|\n'
    resp += '└' + ' ' * total_space + '┘'
    return resp


def gauss_eliminate(matrix: list[list[float]]) -> bool:
    rows = len(matrix)

    # Convertir a matriz triangular
    for step in range(rows - 1):
        if pivoteo:
            temp_matrix = matrix[:]

            def key(_row: list[float]) -> float:
                if step and temp_matrix.index(_row) < step:
                    return math.inf
                return abs(_row[step])

            matrix.sort(key=key, reverse=True)

        if verbose:
            print(f'Step {step + 1}')
            print(tabulate(MATRIX), end='\n\n')

        pivot = matrix[step][step]
        for row_index in range(step + 1, rows):
            row = matrix[row_index]
            factor = row[step] / pivot
            input_rows = zip(row, matrix[step])
            new_row = [
                row_element - pivot_element * factor
                for row_element, pivot_element in input_rows]
            # noinspection PyTypeChecker
            matrix[row_index] = new_row

        if verbose:
            print(tabulate(matrix), end='\n\n')

    # Despejar las incógnitas
    incognitas = [0] * rows
    index = rows
    for row in reversed(matrix):
        index -= 1
        input_rows = zip(row, incognitas)
        # Un despeje de x_n muy sensual
        x = (row[-1] - sum([coef * var for coef, var in input_rows])) / row[index]
        # noinspection PyTypeChecker
        incognitas[index] = x

    # Output
    for index, x in enumerate(incognitas):
        print(f'x{index + 1} = {x}')
    print()

    return all([x != math.nan for x in incognitas])


try:
    unknowns = int(input('Núm Incógnitas? '))
except ValueError:
    unknowns = 3
print()

MATRIX = []

for _ in range(unknowns):
    _new_row = []
    for col in range(unknowns):
        val = float(input(f'Coef {col + 1}? '))
        _new_row.append(val)
    val = float(input('Resp? '))
    _new_row.append(val)
    MATRIX.append(_new_row)
    print()

print(tabulate(MATRIX), end='\n\n')

pivoteo = input('Pivoteo? (y / n) ').lower() == 'y'
verbose = input('Verbose? (y / n) ').lower() == 'y'
print()

try:
    success = gauss_eliminate(MATRIX[:])
except ZeroDivisionError:
    success = False
if not success and not pivoteo:
    print("Retrying with pivoteo...\n")
    pivoteo = True
    gauss_eliminate(MATRIX)
