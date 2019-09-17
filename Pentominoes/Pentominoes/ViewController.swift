//
//  ViewController.swift
//  Pentominoes
//
//  Created by Yixuan Zhang on 9/13/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit


class PentominoView: UIImageView{
    var shape:String=""
    convenience init(shape: String) {
        self.init(frame: CGRect.zero)
        self.image=UIImage(named: "Piece"+shape)
        self.shape=shape
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
    var currentBoard : Int = 0
    var counter:Int=0
    var coverView:UIView=UIView(frame: CGRect.zero)
    var isinitialized=false
    var isReset=false
    
    
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var safeView: UIView!
    @IBOutlet weak var mainBoard: UIImageView!
    @IBOutlet var boards: [UIButton]!
    @IBOutlet weak var elementArea: UIView!
    
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    
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
        disableButton(button: solveButton)
        disableButton(button: resetButton)
        disableButton(button: hintButton)
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if counter != 1{
            for aPentominoView in PentominoViews{
                elementArea.addSubview(aPentominoView)
            }
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
            print("1")
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
            counter=counter+1
            
            
            
        }
        
        
        
        
    }
    

    @IBAction func changeBoard(_ sender: UIButton) {
        let index :Int = sender.tag
        mainBoard.image = UIImage(named: "Board"+"\(index)")
        resetBoardsButton()
        setBoardButton(index: index)
        currentBoard=index
        if index==0{
            disableButton(button: solveButton)
            disableButton(button: resetButton)
            disableButton(button: hintButton)
        }
        else
        {
            enableButton(button: solveButton)
            enableButton(button: hintButton)
        }
        coverView.frame.size.width=420
        coverView.frame.size.height=420
        safeView.addSubview(coverView)
        coverView.center=CGPoint(x: safeView.frame.size.width/2, y: upperView.frame.size.height/2+20)
        
    }
    @IBAction func solve(_ sender: Any) {
        if solveButton.isEnabled==true{
            disableButton(button: solveButton)
            enableButton(button: resetButton)
        }
        else{
            disableButton(button: resetButton)
            enableButton(button: solveButton)
        }
        for aPentomino in Pentominoes{
            aPentomino.setCorrectPosition(boardIndex: currentBoard)
            rotateAndFlip(aPentomino: aPentomino)
            translate(aPentomino: aPentomino)
        }
        if isReset{
            enableBoardChange()
        }else{
            disableBoardChange()
        }
        isReset = !isReset
        
    }
    
    
    func translate(aPentomino:Pentomino){
        aPentomino.setCorrectPosition(boardIndex: currentBoard)
        let isMovingToMainBoard = aPentomino.pentominoView.superview == self.elementArea
        let superView = isMovingToMainBoard ? self.coverView : self.elementArea
        
        moveView(aPentomino.pentominoView, toSuperview: superView!)
        
        let newCenter = isMovingToMainBoard ? CGPoint(x: CGFloat(aPentomino.positionOnBoard.x*30) + aPentomino.pentominoView.frame.width/2, y: CGFloat(aPentomino.positionOnBoard.y*30) + aPentomino.pentominoView.frame.height/2) : CGPoint(x: aPentomino.positionOffBoard.centerX, y: aPentomino.positionOffBoard.centerY)
        
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            aPentomino.pentominoView.center = newCenter
        })
    }
    
    var i:Int=0
    
    func rotateAndFlip(aPentomino:Pentomino){
        var transform = aPentomino.pentominoView.transform
        
            
        transform=transform.rotated(by: CGFloat(Double(aPentomino.positionOnBoard.rotations)*Double.pi/2))
        
        if aPentomino.positionOnBoard.isFlipped==true{
            transform=transform.scaledBy(x: -1, y: 1)
        }
            
        
        if isReset==false{
        UIView.animate(withDuration: 1,animations: {aPentomino.pentominoView.transform=transform})
        
        }
        else{
            UIView.animate(withDuration: 1,animations: {aPentomino.pentominoView.transform=CGAffineTransform.identity})
        }

    }
    
    
    func moveView(_ view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convert(view.center, from: view.superview)
        view.center = newCenter
        superView.addSubview(view)
        safeView.bringSubviewToFront(superView)
        safeView.clipsToBounds=false
        elementArea.clipsToBounds=false
        coverView.clipsToBounds=false
        
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
    
    func disableButton(button:UIButton){
        button.isEnabled=false
        button.backgroundColor = colors.disabledGrey
        
    }
    
    func enableButton(button:UIButton){
        button.isEnabled=true
        button.backgroundColor = colors.enableWhite
        
    }
    
    func disableBoardChange(){
        for board in boards{
            board.isEnabled=false
            if board.layer.borderColor==colors.edgeBlue.cgColor{
                board.layer.borderColor=colors.disabledGrey.cgColor
            }
        }
        
    }
    
    func enableBoardChange(){
        for board in boards{
            board.isEnabled=true
            if board.layer.borderColor==colors.disabledGrey.cgColor{
                board.layer.borderColor=colors.edgeBlue.cgColor
            }
        }
    }
    
    
    
}




