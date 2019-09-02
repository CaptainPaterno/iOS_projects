//
//  ViewController.swift
//  Word Scramble
//
//  Created by Yixuan Zhang on 9/1/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var wordLength: Int = 4
    var word: String = ""
    var wordInArray = [Character]()
    var numberOfCharactersUnselected: Int = 4
    let wordModel = WordModel()
    
    
    @IBOutlet weak var userAnswer: UILabel!
    
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var characterSelector: UISegmentedControl!
    
    @IBOutlet weak var respnse: UILabel!
    
    @IBOutlet weak var newWordButton: UIButton!
    
    @IBOutlet weak var wordLengthSelector: UISegmentedControl!
    
    @IBAction func wordLengthChanged(_ sender: UISegmentedControl) {
        wordLength = wordLengthSelector.selectedSegmentIndex+4
        wordModel.setCurrentWordSize(newSize: wordLength)
        numberOfCharactersUnselected = wordLength
        
        characterSelector.removeAllSegments()
        characterSelector.selectedSegmentIndex = -1
        
        for index in 1...wordLength{
            characterSelector.insertSegment(withTitle: "", at: index-1, animated: true)
        }
        
    }
    
    @IBAction func requestNewWord(_ sender: Any) {
        word = wordModel.randomWord
        wordInArray = Array(word)
        var shuffledWord = word.shuffled()
        for index in 1...wordLength{
            characterSelector.setTitle("\(wordInArray[index-1])", forSegmentAt: index-1)
        }
        userAnswer.text = ""
        
        for index in 0...characterSelector.numberOfSegments-1 {
            characterSelector.setEnabled(true, forSegmentAt: index)
        }
    }
    
    @IBAction func selectCharacter(_ sender: Any) {
        if userAnswer.text != nil{
            userAnswer.text = String(userAnswer.text!)+"\(wordInArray[characterSelector.selectedSegmentIndex])"
        } else {
            userAnswer.text = "\(wordInArray[characterSelector.selectedSegmentIndex])"
        }
        
        characterSelector.setEnabled(false, forSegmentAt: characterSelector.selectedSegmentIndex)
        
        characterSelector.selectedSegmentIndex = -1
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
}

