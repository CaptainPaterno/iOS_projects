//
//  ViewController.swift
//  Pentominoes
//
//  Created by Yixuan Zhang on 9/13/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit


class PentominoView: UIImageView{
    
    convenience init(shape: String) {
        self.init(frame: CGRect.zero)
        self.image=UIImage(named: "Piece"+shape)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)


    }
    
    required init?(coder aDecoder:NSCoder) {
        
        super.init(coder: aDecoder)

    }
    
    
    
}



class ViewController: UIViewController {
    let colors=Colors()
    let PentominoViews : [PentominoView]
    var Pentominoes: [Pentomino]=[]
    let model=Model()
    
    
    @IBOutlet weak var mainBoard: UIImageView!
    @IBOutlet var boards: [UIButton]!
    @IBOutlet weak var elementArea: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        
        var _PentominoViews : [PentominoView] = []
        // create the color views
        for index in model.characterList {
            
            let shape:String = index
            let aPentominoView = PentominoView(shape: shape)
            _PentominoViews.append(aPentominoView)
        }
        PentominoViews = _PentominoViews
        
        super.init(coder: aDecoder)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBoardsButton()
        setBoardButton(index: 0)
        for aPentominoView in PentominoViews{
            elementArea.addSubview(aPentominoView)
        }
        print(model.allSolutions[0])
        let unitX=(elementArea.bounds.size.width-40)/6
        let unitY=(elementArea.bounds.size.height-40)/2
        for i in 0...5 {
            let aPentominoViews = PentominoViews[i]
            let x:Double = (Double(20) + Double(i) * Double(unitX))
            let y:Double = 20
            let height:Double = model.heightList[i]
            let width:Double = model.widthList[i]
            let frame = CGRect(x: x, y: y, width: width, height: height)
            aPentominoViews.frame = frame
        }
        for i in 6...11 {
            let aPentominoViews = PentominoViews[i]
            let x:Double =  Double(Double(20) + Double(i-6) * Double(unitX))
            let y:Double = 20+Double(unitY)
            let height = model.heightList[i]
            let width = model.widthList[i]
            let frame = CGRect(x: x, y: y, width: width, height: height)
            aPentominoViews.frame = frame
        }
        for aPentominoview in PentominoViews{
            Pentominoes.append(Pentomino(pentominoView: aPentominoview))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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




