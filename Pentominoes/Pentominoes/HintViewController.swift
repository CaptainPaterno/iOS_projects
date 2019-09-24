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
    let colors = Colors()
    let model = Model()
    var delegate : HintDelegate?
    var pentominoesForHint: [Pentomino] = []
    var currentBoard: Int = 0
    var numberOfHints: Int = 0
    var pentominoViewsForHint: [PentominoView] = []
    
    @IBOutlet weak var HintBoard: UIImageView!
    @IBAction func dismissByDelegate(_ send:Any){
        if let _delegate = delegate{
            _delegate.dismissHint()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        var _PentominoViews : [PentominoView] = []
        // create the color views
        for index in model.characterList {
            
            let shape:String = index
            let aPentominoView = PentominoView(shape: shape)
            _PentominoViews.append(aPentominoView)
        }
        pentominoViewsForHint = _PentominoViews
        
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HintBoard.image = UIImage(named: "Board"+"\(currentBoard)")
    
        for aPentominoview in pentominoViewsForHint{
            aPentominoview.isUserInteractionEnabled = false
            pentominoesForHint.append(Pentomino(pentominoView: aPentominoview))
            HintBoard.addSubview(aPentominoview)
        }
        for i in 0...11 {
            let aPentominoViews = pentominoViewsForHint[i]
            let x:Double = 0
            let y:Double = 0
            let height:Double = model.heightList[i]
            let width:Double = model.widthList[i]
            let frame = CGRect(x: x, y: y, width: width, height: height)
            aPentominoViews.frame = frame
            aPentominoViews.isHidden=true
        }
        
        for aPentomino in pentominoesForHint{
            aPentomino.setCorrectPosition(boardIndex: currentBoard)
            var transform = aPentomino.pentominoView.transform
            transform=transform.rotated(by: CGFloat(Double(aPentomino.positionOnBoard.rotations)*Double.pi/2))
            if aPentomino.positionOnBoard.isFlipped==true{
                transform=transform.scaledBy(x: -1, y: 1)
            }
            UIView.animate(withDuration: 0,animations: {aPentomino.pentominoView.transform=transform})
            
        
            let newCenter = CGPoint(x: CGFloat(aPentomino.positionOnBoard.x*30) + aPentomino.pentominoView.frame.width/2, y: CGFloat(aPentomino.positionOnBoard.y*30) + aPentomino.pentominoView.frame.height/2)
            UIView.animate(withDuration: 0, animations: { () -> Void in
                aPentomino.pentominoView.center = newCenter
            })
        }
        displayPentomino(numberOfHints: numberOfHints)
        // Do any additional setup after loading the view.
    }
    
    func displayPentomino(numberOfHints:Int){
        if numberOfHints<12{
            for i in 0...numberOfHints{
                pentominoViewsForHint[i].isHidden=false
            }
        }else{
            for i in 0...11{
                pentominoViewsForHint[i].isHidden=false
        }
        
        }
    }
    func configure(with currentBoard:Int, numberOfHints:Int){
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
