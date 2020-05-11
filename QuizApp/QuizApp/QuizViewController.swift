//
//  ViewController.swift
//  QuizApp
//
//  Created by 杨丽婧 on 2020/2/3.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var multLabel: UILabel!
    
    @IBOutlet weak var addText: UITextField!
    @IBOutlet weak var subText: UITextField!
    @IBOutlet weak var multText: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var addAnswer: Int = 0
    var subAnswer: Int = 0
    var multAnswer: Int = 0
    
    var countAnwsers: Int = 0
    var isAddCorrect: Bool = false
    var isSubCorrect: Bool = false
    var isMultCorrect: Bool = false
    
    var ableEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Requirement 1 & 6: Use QuizModel to do the 3 operations
        var op1 = Int.random(in: 0...10)
        var op2 = Int.random(in: 0...10)

        let exprAdd = QuizModel.Expression.Arithmetic(op1, op2, QuizModel.Operator.Binary({$0 + $1}))
        addAnswer = QuizModel.evaluateExpression(expression: exprAdd)
        addLabel.text = "\(op1) + \(op2)"
        
        op1 = Int.random(in: 0...10)
        op2 = Int.random(in: 0...10)

        let exprSub = QuizModel.Expression.Arithmetic(op1, op2, QuizModel.Operator.Binary({$0 - $1}))
        subAnswer = QuizModel.evaluateExpression(expression: exprSub)
        subLabel.text = "\(op1) - \(op2)"
        
        op1 = Int.random(in: 0...10)
        op2 = Int.random(in: 0...10)

        let exprMult = QuizModel.Expression.Arithmetic(op1, op2, QuizModel.Operator.Binary({$0 * $1}))
        multAnswer = QuizModel.evaluateExpression(expression: exprMult)
        multLabel.text = "\(op1) x \(op2)"
        
        ableEdit = true
        
        
        //Requirement 2.3: The keyboard should retract when the user taps the background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    //Requirement 2.3
    @IBAction func dismissKeyboard(_ sender: UIPanGestureRecognizer) {
        view.endEditing(true)
    }
    
    //Requirement 2.4: cannot enter 0 as the first digit unless the correct answer is 0
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let id = textField.restorationIdentifier
        if string == "0", let text = textField.text {
            if text.count == 0 {
                if id == "+" && addAnswer != 0 {
                    return false
                }
                if id == "-" && subAnswer != 0 {
                    return false
                }
                if id == "*" && multAnswer != 0 {
                    return false
                }
            }
            if text.count == 1 {
                if let char = text.first{
                    if char == "-" {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    //Requirement 3.2: cannot edit answers after submit
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return ableEdit
    }
    
    @IBAction func addTextChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Int(text) {
            if value == addAnswer {
                isAddCorrect = true
            }
            else {
                isAddCorrect = false
            }
        }
        else {
            isAddCorrect = false
        }
    }
    
    
    @IBAction func subTextChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Int(text) {
            if value == subAnswer {
                isSubCorrect = true
            }
            else {
                isSubCorrect = false
            }
        }
        else {
            isSubCorrect = false
        }
    }
    
    @IBAction func multTextChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Int(text) {
            if value == multAnswer {
                isMultCorrect = true
            }
            else {
                isMultCorrect = false
            }
        }
        else {
            isMultCorrect = false
        }
    }
    
    @IBAction func Submit(_ sender: Any) {
        
        //Requirement 3.1: count correct answers and change resultLabel
        if isAddCorrect == true {
            countAnwsers += 1
        }
        if isSubCorrect == true {
            countAnwsers += 1
        }
        if isMultCorrect == true {
            countAnwsers += 1
        }
        
        if countAnwsers != 0 {
            resultLabel.text = "\(countAnwsers) correct answers"
        }
        
        countAnwsers = 0
        
        //Requirement 3.2: cannot edit answers after submit
        ableEdit = false
    }
    
    
    @IBAction func Next(_ sender: Any) {
        
        //Requirement 3.1 & 4: resultLabel should disappear after click Next
        countAnwsers = 0
        isAddCorrect = false
        isSubCorrect = false
        isMultCorrect = false
        resultLabel.text = ""
        addText.text = ""
        subText.text = ""
        multText.text = ""
        ableEdit = true
        
        //Requirement 4: display 3 new expressions
        var op1 = Int.random(in: 0...10)
        var op2 = Int.random(in: 0...10)

        let exprAdd = QuizModel.Expression.Arithmetic(op1, op2, QuizModel.Operator.Binary({$0 + $1}))
        addAnswer = QuizModel.evaluateExpression(expression: exprAdd)
        addLabel.text = "\(op1) + \(op2)"
        
        op1 = Int.random(in: 0...10)
        op2 = Int.random(in: 0...10)

        let exprSub = QuizModel.Expression.Arithmetic(op1, op2, QuizModel.Operator.Binary({$0 - $1}))
        subAnswer = QuizModel.evaluateExpression(expression: exprSub)
        subLabel.text = "\(op1) - \(op2)"
        
        op1 = Int.random(in: 0...10)
        op2 = Int.random(in: 0...10)

        let exprMult = QuizModel.Expression.Arithmetic(op1, op2, QuizModel.Operator.Binary({$0 * $1}))
        multAnswer = QuizModel.evaluateExpression(expression: exprMult)
        multLabel.text = "\(op1) x \(op2)"
        
        
    }
    
}

