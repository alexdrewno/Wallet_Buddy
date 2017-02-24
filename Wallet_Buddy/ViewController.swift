//
//  ViewController.swift
//  Wallet_Buddy
//
//  Created by adrewno1 on 2/21/17.
//  Copyright © 2017 adrewno1. All rights reserved.
//

import UIKit
import AKPickerView

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "authorized", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

