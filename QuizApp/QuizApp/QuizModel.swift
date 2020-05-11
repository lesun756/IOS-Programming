//
//  QuizModel.swift
//  QuizApp
//
//  Created by 杨丽婧 on 2020/2/7.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation

//Requirement 6: QuizModel
class QuizModel {
    enum Expression {
        case Arithmetic(Int, Int, Operator)
    }
    
    enum Operator {
        case Binary((Int, Int) -> Int)
    }
    
    let operators = ["+": Operator.Binary({$0 + $1}),
                     "-": Operator.Binary({$0 - $1}),
                     "x": Operator.Binary({$0 * $1})]
    
    static func evaluateExpression(expression: Expression) -> Int {
        switch expression {
        case .Arithmetic(let opRand1, let opRand2, let op):
            switch op {
            case .Binary(let c):
                let res = c(opRand1, opRand2)
                return res
            }
        }
    }
}
