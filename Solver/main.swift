//
//  main.swift
//  Solver
//
//  Created by Leonardo Corona Garza on 12/Mar/22.
//

import Foundation

func tabulate(_ matrix: [[Double]], decimalPlaces: Int? = 5) -> String {
    var spaces: [[Int]] = matrix.map({ $0.map({ _ in 0 }) })
    let matrix: [[String]] = matrix.map({ $0.map({
        decimalPlaces == nil ? String($0) : String(format: "%.\(decimalPlaces!)g", $0)
    }) })
    
    // Saber cuánto se debe espaciar cada elemento
    for j in 0..<matrix[0].count {
        let charCounts = matrix.map({ $0[j].count })
        let largest = charCounts.max()!
        for (i, charCount) in charCounts.enumerated() {
            spaces[i][j] = largest - charCount
        }
    }
    
    // Armar la matriz
    let totalSpace = matrix[0].reduce(2, { $0 + $1.count + 2 }) + spaces[0].reduce(0, +)
    var resp = "┌"
    for _ in 0..<totalSpace {
        resp.append(" ")
    }
    resp.append("┐\n")
    for (row, rowSpaces) in zip(matrix, spaces) {
        resp.append("|  ")
        
        for (element, elementSpace) in zip(row, rowSpaces) {
            resp.append(element)
            for _ in 0..<(elementSpace + 2) {
                resp.append(" ")
            }
        }
        
        resp.append("|\n")
    }
    resp.append("└")
    for _ in 0..<totalSpace {
        resp.append(" ")
    }
    resp.append("┘")
    
    return resp
}

func gaussEliminate(_ matrix: [[Double]]) -> Bool {
    var matrix = matrix
    let rows = matrix.count

    // Convertir a matriz triangular
    for step in 0..<(rows - 1) {
        if pivoteo {
            let tempMatrix = matrix
            
            func key(_ row: [Double]) -> Double {
                if step != 0 && tempMatrix.firstIndex(of: row)! < step {
                    return Double.infinity
                }
                return abs(row[step])
            }
            
            matrix.sort(by: { lhs, rhs in key(lhs) > key(rhs) })
        }
        
        if verbose {
            print("Step \(step + 1)")
            print(tabulate(matrix))
            print("")
        }
        
        let pivot = matrix[step][step]
        for rowIndex in (step + 1)..<rows {
            let row = matrix[rowIndex]
            let factor = row[step] / pivot
            let newRow = zip(row, matrix[step]).map({ rowElement, pivotElement in
                rowElement - pivotElement * factor
            })
            matrix[rowIndex] = newRow
        }
        
        if verbose {
            print(tabulate(matrix))
            print("")
        }
    }
    
    // Despejar las incógnitas

    var incognitas: [Double] = matrix.map({ _ in 0.0 })
    var index = rows
    for row in matrix.reversed() {
        index -= 1
        let x = (row.last! - zip(row, incognitas).reduce(0.0, { acum, stuff in
            acum + stuff.0 * stuff.1
        })) / row[index]
        incognitas[index] = x
    }
    
    var wasUseless = false
    for (i, x) in incognitas.enumerated() {
        wasUseless = wasUseless || x.isNaN
        print("x\(i + 1) = \(x)")
    }
    print("")
    
    return !wasUseless
}

print("Núm Incógnitas?", terminator: " ")
let unknowns = Int(readLine()!) ?? 3
print("")

var matrix: [[Double]] = []

for _ in 1...unknowns {
    var newRow = [Double]()
    for col in 1...unknowns {
        print("Coef \(col)?", terminator: " ")
        let val = Double(readLine()!) ?? 0
        newRow.append(val)
    }
    print("Resp?", terminator: " ")
    let val = Double(readLine()!) ?? 0
    newRow.append(val)
    matrix.append(newRow)
    print("")
}

print(tabulate(matrix))
print("")

print("Pivoteo? (y / n)", terminator: " ")
var pivoteo = readLine()! == "y"
print("Verbose? (y / n)", terminator: " ")
let verbose = readLine()! == "y"
print("")

let success = gaussEliminate(matrix)
if !success && !pivoteo {
    print("Retrying with pivoteo...\n")
    pivoteo = true
    _ = gaussEliminate(matrix)
}
