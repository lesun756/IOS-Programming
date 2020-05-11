//
//  ViewController.swift
//  ConnectionExample
//
//  Copyright © 2020 Syracuse University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    
  
    @IBOutlet weak var myHeight: UITextField!
    
    @IBOutlet weak var myWeight: UITextField!
    
    @IBOutlet weak var myBMI: UITextField!
    
    @IBOutlet weak var otherSlider: UISlider!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySlider: UISlider!
    
    var BMI: Double = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        myLabel.text = String(12345)
        otherSlider.value = 0.1
        mySlider.value = 0.9
        
        myCategory.adjustsFontSizeToFitWidth = true
        myCategory.numberOfLines = 0
        myCategory.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func myAction(_ sender: UIButton) {
        // calculate BMI
        let kg = myWeight.text
        let cm = myHeight.text
        if kg == "" || cm == ""{
            return
        }
        let kgnum = Double(kg!)
        let cmnum = Double(cm!)!/100
        
        BMI = kgnum!/(cmnum*cmnum)
        
        evaluateResult()
    }
    
    @IBOutlet weak var myCategory: UILabel!
    
    func evaluateResult(){
        
        var myResult:String
        switch BMI {
        case 1..<15:
            myResult = "Very Severely Underweight!"
        case 15...16:
            myResult = "Severely Underweight!"
        case 16..<18.5:
            myResult = "Underweight!"
        case 18.5..<25:
            myResult = "Normal"
        case 25..<30:
            myResult = "Overweight!"
        case 30..<35:
            myResult = "Moderately Obese!"
        case 35..<40:
            myResult = "Severely Obese!"
        case 40..<60:
            myResult = "Very Severely Obese!"
        default:
            myResult = "You need to see a doctor!"
        }
        myBMI.text = String(BMI)
        //myCategory.contentMode = .scaleToFill
        //myCategory.numberOfLines = 0
        myResult = "Your Category is ... " + myResult
        
        myCategory.text = myResult
        myCategory.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func sliderMoved(_ sender: UISlider) {
        myLabel.text = String(otherSlider.value)
        
    }
    
}

