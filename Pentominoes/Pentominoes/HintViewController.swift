//
//  HintViewController.swift
//  Pentominoes
//
//  Created by Yixuan Zhang on 9/22/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit

protocol HintDelegate{
    func dismissHint()
}

class HintViewController: UIViewController {
    
    var delegate : HintDelegate?
    var pentominoes: [Pentomino] = []
    var currentBoard: Int = 0
    var numberOfHints: Int = 0
    var pentominoViews: [PentominoView] = []
    
    @IBOutlet weak var board: UIImageView!
    @IBAction func dismissByDelegate(_ send:Any){
        if let _delegate = delegate{
            _delegate.dismissHint()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        board.image = UIImage(named: "Board"+"\(currentBoard)")
        
        // Do any additional setup after loading the view.
    }
    func displayPentomino(){
        
        
    }
    func configure(with pentominoes:[Pentomino], currentBoard:Int, numberOfHints:Int){
        self.pentominoes = pentominoes
        self.currentBoard = currentBoard
        self.numberOfHints = numberOfHints
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
