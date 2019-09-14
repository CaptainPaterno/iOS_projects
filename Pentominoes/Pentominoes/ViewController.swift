//
//  ViewController.swift
//  Pentominoes
//
//  Created by Yixuan Zhang on 9/13/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit

class 


class ViewController: UIViewController {
    let colors=Colors()
    @IBOutlet weak var mainBoard: UIImageView!
    @IBOutlet var boards: [UIButton]!
    
    @IBOutlet weak var elementArea: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBoardsButton()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeBoard(_ sender: UIButton) {
        let index :Int = sender.tag
        mainBoard.image = UIImage(named: "Board"+"\(index)")
        resetBoardsButton()
        setBoardButton(index: index)
    }
    
    func resetBoardsButton(){
        for index in 0...5{
            boards[index].layer.cornerRadius=7
            boards[index].layer.masksToBounds=true
            boards[index].layer.borderWidth=4
            boards[index].layer.borderColor=colors.edgeBlue.cgColor
        }
    }
    
    func setBoardButton(index: Int){
        boards[index].layer.borderColor=colors.edgeRed.cgColor
        
    }
    
    
    
    
    
}




