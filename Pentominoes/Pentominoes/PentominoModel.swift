//
//  Model.swift
//  Pentominoes
//
//  Created by John Hannan on 8/28/18.
//  Copyright (c) 2018 John Hannan. All rights reserved.
//

import Foundation

// identifies placement of a single pentomino on a board

struct PentominoSize {
    var width : Int
    var length : Int
}

struct PositionOffBoard {
    var centerX: Double
    var centerY: Double
}

struct PositionOnBoard : Codable {
    var x : Int
    var y : Int
    var isFlipped : Bool
    var rotations : Int
}

// A solution is a dictionary mapping piece names ("T", "F", etc) to positions
// All solutions are read in and maintained in an array
typealias Solution = [String:PositionOnBoard]
typealias Solutions = [Solution]


class Pentomino{
    let model=Model()
    var currentBoard : Int = 0
    var isOnBoard : Bool
    var positionOnBoard=PositionOnBoard(x: 0, y: 0, isFlipped: false, rotations: 0)
    var positionOffBoard=PositionOffBoard(centerX: 0, centerY: 0)
    var pentominoView: PentominoView
    
    
    init(pentominoView:PentominoView) {
        self.isOnBoard=false
        self.pentominoView=pentominoView
        self.positionOffBoard=PositionOffBoard(centerX: 0, centerY: 0)
        self.positionOffBoard.centerX = Double(self.pentominoView.center.x)
        self.positionOffBoard.centerY = Double(self.pentominoView.center.y)
        self.positionOnBoard=PositionOnBoard(x: 0, y: 0, isFlipped: false, rotations: 0)
    }
    
    func setCorrectPosition(boardIndex:Int){
        self.currentBoard=boardIndex-1
        self.positionOnBoard.x=model.allSolutions[currentBoard][pentominoView.shape]!.x
        self.positionOnBoard.y=model.allSolutions[currentBoard][pentominoView.shape]!.y
        self.positionOnBoard.isFlipped=model.allSolutions[currentBoard][pentominoView.shape]!.isFlipped
        self.positionOnBoard.rotations=model.allSolutions[currentBoard][pentominoView.shape]!.rotations
    }
    
}

class Model {
    let characterList: [String] = ["F","I","L","N","P","T","U","V","W","X","Y","Z"]
    let widthList: [Double] = [90,30,60,60,60,90,90,90,90,90,60,90]
    let heightList: [Double] = [90,150,120,120,90,90,60,90,90,90,120,90]
    let allSolutions : Solutions //[[String:[String:Int]]]
    init () {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "Solutions", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allSolutions = try decoder.decode(Solutions.self, from: data)
        } catch {
            print(error)
            allSolutions = []
            print(allSolutions)
        }
    }

}
