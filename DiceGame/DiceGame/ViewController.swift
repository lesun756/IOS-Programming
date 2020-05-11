//
//  ViewController.swift
//  DiceGame
//
//  Created by 杨丽婧 on 2020/2/8.
//  Copyright © 2020 Le Sun. All rights reserved.
//
//  Please noted that:
//  杨丽婧 is my roommate.
//  I borrowed her Mac to do the homework.


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var BetMoneyLabel: UILabel!
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var Stepper: UIStepper!
    
    @IBOutlet weak var TotalMoneyLabel: UILabel!
    @IBOutlet weak var RoundLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    @IBOutlet weak var ComputerImage: UIImageView!
    @IBOutlet weak var PlayerImage: UIImageView!
    
    
    var totalMoney: Int = 100
    var imageArray = [UIImage]()
    
    //Round # will be updated after each play
    var count = 0 {
        didSet {
            RoundLabel.text = "Round: \(count)"
        }
    }
    
    /*
    Game Score Design:
    The score is based on how much the player wins cumulatively, regardless how much he/she loses.
    So as long as the balance isn't zero, the player still has the chance to get higher score.
    e.g.
    A player plays three rounds of game and wins money [40,-30,20].
    The score will be 40+20=60, even though he loses 30 dollars for the second round.
    */
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageArray.append(UIImage(named: "dice no roll")!)
        imageArray.append(UIImage(named: "dice 1")!)
        imageArray.append(UIImage(named: "dice 2")!)
        imageArray.append(UIImage(named: "dice 3")!)
        imageArray.append(UIImage(named: "dice 4")!)
        imageArray.append(UIImage(named: "dice 5")!)
        imageArray.append(UIImage(named: "dice 6")!)
        
    }
    
    //Use slider to change bet money
    @IBAction func slider(_ sender: UISlider) {
        BetMoneyLabel.text = "Betting Money: \(Int(sender.value))"
        Stepper.value = Double(sender.value)
    }
    
    //Use stepper to change bet money
    @IBAction func stepper(_ sender: UIStepper) {
        BetMoneyLabel.text = "Betting Money: \(Int(sender.value))"
        Slider.value = Float(sender.value)
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //alert call for Balance changing
    //will update the balance (& score if needed) after clicking "OK"
    func createBetAlert(title: String, message: String, win: Bool, bet: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
            if win {
                self.score = self.score + bet
                self.ScoreLabel.text = "Game Score: \(self.score)"
                self.totalMoney = self.totalMoney + bet
                self.TotalMoneyLabel.text = "Balance: \(self.totalMoney)"
            }
            else {
                self.totalMoney = self.totalMoney - bet
                self.TotalMoneyLabel.text = "Balance: \(self.totalMoney)"
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func roll(_ sender: UIButton) {
        
        //Alert if balance is lower than the bet money
        if Int(Slider.value) > totalMoney {
            //warning
            createAlert(title: "Sorry ...", message: "Your balance isn't enough, please Rebet.")
        }
        
        else {
            
            count = count + 1
            
            //Generate two random number between 1 and 6
            let computer = 1 + Int(arc4random_uniform(6))
            let player = 1 + Int(arc4random_uniform(6))
            
            //change the dice images to the corresponding dice number
            UIView.transition(with: self.ComputerImage, duration: 1, options: .transitionCrossDissolve, animations: {
                self.ComputerImage.image = self.imageArray[computer]
            }, completion: nil)
            
            UIView.transition(with: self.PlayerImage, duration: 1, options: .transitionCrossDissolve, animations: {
                self.PlayerImage.image = self.imageArray[player]
            }, completion: nil)
            
            if computer > player {
                //computer wins
                createBetAlert(title: "Oops!", message: "Computer rolled: \(computer), You rolled \(player)\n You lose \(Int(Slider.value)) dollar(s)", win: false, bet: Int(Slider.value))
            }
            
            if computer < player {
                //player wins
                createBetAlert(title: "Congrats!", message: "Computer rolled: \(computer), You rolled \(player)\n You win \(Int(Slider.value)) dollar(s)", win: true, bet: Int(Slider.value))
            }
            
            if computer == player {
                //truce
                createAlert(title: "Truce", message: "Computer rolled: \(computer), You rolled \(player)\n Nobody wins")
            }
        }
        
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        score = 0
        ScoreLabel.text = "Game Score: 0"
        totalMoney = 100
        TotalMoneyLabel.text = "Balance: \(totalMoney)"
        BetMoneyLabel.text = "Betting Money: 1"
        Slider.value = 1
        Stepper.value = 1
        UIView.transition(with: self.ComputerImage, duration: 1.5, options: .transitionCrossDissolve, animations: {
            self.ComputerImage.image = self.imageArray[0]
        }, completion: nil)
        UIView.transition(with: self.PlayerImage, duration: 1.5, options: .transitionCrossDissolve, animations: {
            self.PlayerImage.image = self.imageArray[0]
        }, completion: nil)
        count = 0
    }
    
    //perform segue using "rules" identifier to connect DiceGame screen and Game Rules(How to play?) screen
    @IBAction func rules(_ sender: UIButton) {
        performSegue(withIdentifier: "rules", sender: self)
    }
    
    //perform segue using "author" identifier to connect DiceGame screen and Author screen
    @IBAction func author(_ sender: UIButton) {
        performSegue(withIdentifier: "author", sender: self)
    }
    
}

