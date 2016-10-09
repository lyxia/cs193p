//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by lyxia on 2016/9/20.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accmulator: Double = 0.0
    private var internalProgram = [Any]()
    
    func setOperand(operand: Double) {
        accmulator = operand
        internalProgram.append(accmulator)
    }
    
    enum  Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    var operations: Dictionary<String, Operation> = [
        "ℸ" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "*": Operation.binaryOperation({$0 * $1}),
        "/": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals
    ]
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol)
            switch operation {
            case .constant(let value): accmulator = value
            case .unaryOperation(let function): accmulator = function(accmulator)
            case .binaryOperation(let function):
                performPendingBinary()
                pendingBinary = PendingBinaryOperation(binaryOperation: function, accmulator: accmulator)
            case .equals: performPendingBinary()
            }
        }
    }
    
    func performPendingBinary() {
        if (pendingBinary != nil) {
            accmulator = pendingBinary!.binaryOperation(pendingBinary!.accmulator, accmulator)
            pendingBinary = nil
        }
    }
    
    private var pendingBinary:PendingBinaryOperation?
    
    struct PendingBinaryOperation {
        let binaryOperation:(Double, Double) -> Double
        let accmulator:Double
    }
    
    typealias PropertyList = Any
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let program = newValue as? Array<Any> {
                for op in program {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let symbol = op as? String {
                        performOperation(symbol: symbol)
                    }
                }
            }
        }
    }
    
    func clear() {
        accmulator = 0.0
        pendingBinary = nil
        internalProgram = [Any]()
    }
    
    var result: Double {
        get {
            return accmulator
        }
    }
}
