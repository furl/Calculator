//
//  ViewController.swift
//  Calculator
//
//  Created by Andrew Furletov on 13/01/2019.
//  Copyright © 2019 Andrew Furletov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet var operatorButtons: [UIButton]!
    var operatorButtonDefaultColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.text = "0"
        operatorButtonDefaultColor = operatorButtons[0].backgroundColor!
    }

    var currentOperand = 0
    var operands = ["0","0"] {
        didSet {
            outputLabel.text = operands[currentOperand]
        }
    }
    
    //var `var` = 0
    var operatorUsed = ""
    var equalPressed = false
    var lastKeyPressed = ""
    
    
    @IBAction func touchButton(_ sender: UIButton) {
        
        ERROR:
        if outputLabel.text == "Error"{
            if ["0","1","2","3","4","5","6","7","8","9",".","C"].contains(sender.currentTitle){
                reset()
                break ERROR
            }else{
                return
            }
        }
 ///    347 -> operands[0]
 
        switch sender.currentTitle{
        case "C":
            reset()
            
        case "0","1","2","3","4","5","6","7","8","9":
            if operatorUsed != "" {
                if currentOperand == 0 {
                    operands[1] = ""
                    currentOperand = 1
                }
                operands[1] += sender.currentTitle!
            } else {
//                if operands[0] == "0"{
//                    operands[0] = ""
//                }
                operands[0] = operands[0] == "0" ? "" : operands[0]
                operands[0] += sender.currentTitle!
                operands[1] = operands[0]
            }
            
            break

        case ".":
            if operatorUsed != "" {
                if currentOperand == 0 {
                    operands[1] = ""
                    currentOperand = 1
                }
                if operands[currentOperand].contains("."){
                    break
                } else {
                    operands[1] += "."
                    if operands[1] == "." { operands[1] = "0." }
                }
                
            }
            if operands[currentOperand].contains(".") {
                break
            } else {
                operands[currentOperand] += sender.currentTitle!
                if currentOperand == 0 {
                    operands[1] = operands[0]
                }
            }
        
        case "+","-","*","/":
            if equalPressed == false && operatorUsed != "" && !["+","-","*","/"].contains(lastKeyPressed) {
                setFirstOperand()
            }
            operatorUsed = sender.currentTitle!
            equalPressed = false
        
        case "=":
            if operatorUsed == "" {
                break
            } else {
                setFirstOperand()
                equalPressed = true
            }
            
        default:
            break
        }
  
        lastKeyPressed = sender.currentTitle!
    }
    
    func setFirstOperand() {
        operands[0] = calculate(operand1: operands[0], operand2: operands[1], operatorUsed: operatorUsed)
        outputLabel.text = operands[0]
        if outputLabel.text == "Error"{
            setOperatorButtonsState(active: false)
        }
        currentOperand = 0
    }

    func reset(){
        currentOperand = 0
        operands = ["0","0"]
        operatorUsed = ""
        equalPressed = false
        lastKeyPressed = ""
        setOperatorButtonsState(active: true)
    }
    
    func setOperatorButtonsState(active: Bool){
        for button in operatorButtons{
            button.backgroundColor = active ? operatorButtonDefaultColor : UIColor.lightGray
            button.isEnabled = active
        }
    }
    
    
    
    func calculate(operand1: String, operand2: String, operatorUsed: String) -> String{
        let op1 = Decimal(string: operand1)!
        let op2 = Decimal(string: operand2)!
        var result: String = ""
        var calcResult: Decimal = 0.0
        
        switch operatorUsed{
        case "+":
            calcResult = op1 + op2
        case "-":
            calcResult = op1 - op2
        case "*":
            calcResult = op1 * op2
        case "/":
            if op2 == 0 { return "Error" }
            calcResult = op1 / op2
        default:
            break
        }

        result = NSDecimalNumber(decimal: calcResult).stringValue
        
        return result
    }
    
    
}

