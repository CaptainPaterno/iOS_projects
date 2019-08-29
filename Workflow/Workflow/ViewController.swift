//
//  ViewController.swift
//  Workflow
//
//  Created by Yixuan Zhang on 8/29/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weAreLabel: UILabel!
    @IBOutlet weak var pennStateLabel: UILabel!
    
    var cheerCount = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pennStateLabel.isHidden = true
        
    }

    @IBAction func cheerPressed(_ sender: UIButton) {
        weAreLabel.isHidden = !isEvnCheerCount
        pennStateLabel.isHidden = isEvnCheerCount
        cheerCount += 1
    }
    
}
