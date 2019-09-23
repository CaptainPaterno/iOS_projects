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
    var pentominoPointer :Pentomino?
    convenience init(shape: String) {
        self.init(frame: CGRect.zero)
        self.image=UIImage(named: "Piece"+shape)
        self.shape=shape
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pentominoPointer = nil

    }
    
    required init?(coder aDecoder:NSCoder) {
        
        super.init(coder: aDecoder)
        pentominoPointer = nil

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
    
    
    
    @IBOutlet weak var TopView: UIView!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
            aPentominoview.isUserInteractionEnabled=true
            Pentominoes.append(Pentomino(pentominoView: aPentominoview))
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveViewOBJC(_:)))
            aPentominoview.addGestureRecognizer(panGesture)
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(rotate(_:)))
            aPentominoview.addGestureRecognizer(singleTap)
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(flip(_:)))
            doubleTap.numberOfTapsRequired = 2
            aPentominoview.addGestureRecognizer(doubleTap)
            singleTap.require(toFail: doubleTap)
        }
        
        coverView.frame.size.width=420
        coverView.frame.size.height=420
        safeView.addSubview(coverView)
        coverView.center=CGPoint(x: safeView.frame.size.width/2, y: upperView.frame.size.height/2+20)
        
        
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
        let isMovingToMainBoard = aPentomino.pentominoView.superview == elementArea
        let superView = isMovingToMainBoard ? coverView : elementArea
        
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
    
    @objc func rotate(_ sender: UITapGestureRecognizer){
        let aPentominoView = sender.view!
        var transform = aPentominoView.transform
        transform=transform.rotated(by: CGFloat(Double.pi/2))
        UIView.animate(withDuration: 1,animations: {aPentominoView.transform=transform})
    }
    
    @objc func flip(_ sender: UITapGestureRecognizer){
        let aPentominoView = sender.view!
        var transform = aPentominoView.transform
        transform=transform.scaledBy(x: -1, y: 1)
        UIView.animate(withDuration: 1,animations: {aPentominoView.transform=transform})
        
    }
    
    @objc func moveViewOBJC(_ sender: UIPanGestureRecognizer){
        let aPentominoView = sender.view! as! PentominoView
        
        switch sender.state {
        case .began:
            aPentominoView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            //self.view.bringSubviewToFront(aPentominoView)
            //let location = sender.location(in: self.elementArea)
            //aPentominoView.center=location
            safeView.bringSubviewToFront(TopView)
            let newCenter = TopView.convert(aPentominoView.center, from: aPentominoView.superview)
            TopView.addSubview(aPentominoView)
            aPentominoView.center = newCenter
            
        case .changed:
            let location = sender.location(in: self.TopView)
            aPentominoView.center = location
        case .ended:
            aPentominoView.transform = CGAffineTransform(scaleX: 1, y: 1)
            let newCenter = coverView.convert(aPentominoView.center, from: aPentominoView.superview)
            coverView.addSubview(aPentominoView)
            aPentominoView.center = newCenter
            safeView.sendSubviewToBack(TopView)
            safeView.bringSubviewToFront(coverView)
            if coverView.bounds.contains(aPentominoView.frame)==false{
                translate(aPentomino: aPentominoView.pentominoPointer!)
            } else{
                let originalCenterX=aPentominoView.center.x
                let originalCenterY=aPentominoView.center.y
                let remainderX=originalCenterX.truncatingRemainder(dividingBy: 30)
                let remainderY=originalCenterY.truncatingRemainder(dividingBy: 30)
                var newCenterX: CGFloat
                var newCenterY: CGFloat
                let pentominoWidth=aPentominoView.bounds.size.width / CGFloat(30)
                let pentominoHeight=aPentominoView.bounds.size.height / CGFloat(30)
                if (pentominoWidth.truncatingRemainder(dividingBy: 3)==0 )  {
                    if remainderX<15{
                        newCenterX=originalCenterX-remainderX-15
                    }else{
                        newCenterX=originalCenterX+(30-remainderX)-15
                    }
                }else{
                    if remainderX<15{
                        newCenterX=originalCenterX-remainderX
                    }else{
                        newCenterX=originalCenterX+(30-remainderX)
                    }
                }
                    
                if (pentominoHeight.truncatingRemainder(dividingBy: 3)==0)  {
                    if remainderY<15{
                        newCenterY=originalCenterY-remainderY-15
                    }else{
                        newCenterY=originalCenterY+(30-remainderY)-15
                    }
                }else{
                    if remainderY<15{
                        newCenterY=originalCenterY-remainderY
                    }else{
                        newCenterY=originalCenterY+(30-remainderY)
                    }
                }
                let newCenter = CGPoint(x: newCenterX,y: newCenterY)
                aPentominoView.center=newCenter
            }
            
        default:
            break
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




