//
//  DiscoViewController.swift
//  ConnectionExample
//
//  Copyright © 2020 Syracuse University. All rights reserved.
//

import UIKit

class DiscoViewController: UIViewController {
    let bgColors: [UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.orange, UIColor.cyan, UIColor.magenta, UIColor.yellow, UIColor.white]
    
    var cnt = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cnt = 0
        // Do any additional setup after loading the view.
    }

    @IBAction func changeColor(_ sender: Any) {
        
        runTimer()
        //updateTimer()
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats:true)
    }
    
    @objc func updateTimer(){
        self.view.backgroundColor = bgColors[cnt]
        
        cnt += 1
        if cnt >= bgColors.count{
            cnt = 0
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
