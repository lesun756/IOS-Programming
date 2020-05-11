//
//  AuthorViewController.swift
//  DiceGame
//
//  Created by 杨丽婧 on 2020/2/14.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //dismiss function to go back to the DiceGame screen
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Show alert when click on moreDetails button
    @IBAction func moreDetails(_ sender: Any) {
        createAlert(title: "Hello!", message: "Please visit my personal website: \n//https:123456.syr.edu")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
