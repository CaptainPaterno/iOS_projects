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
    var shuffledWord: String = ""
    var numberOfCharactersUnselected: Int = 4
    var memory = [Int]()
    var selectedIndex=0
    var numberOfQuestion: Int = 0
    var numberOfCorrect: Int = 0
    let wordModel = WordModel()
    let buttonBlue = UIColor(displayP3Red: 0.227, green: 0.482, blue: 0.792, alpha: 1)
    let grey: UIColor = UIColor(displayP3Red: 0.333, green: 0.333, blue: 0.333, alpha: 1)
    let newWordOrange=UIColor(displayP3Red: 0.979, green: 0.600, blue: 0.388, alpha: 1)
    
    @IBOutlet weak var userAnswer: UILabel!
    
    @IBOutlet weak var questionCounter: UILabel!
    
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var characterSelector: UISegmentedControl!
    
    @IBOutlet weak var response: UILabel!
    
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
        userAnswer.text = ""
        response.isHidden=true
        setStateToDefault()
        cleanMemory()
    }
    
    @IBAction func requestNewWord(_ sender: Any) {
        wordModel.setCurrentWordSize(newSize: wordLength)
        word = wordModel.randomWord
        shuffledWord = String(word.shuffled())
        wordInArray = Array(shuffledWord)
        for index in 1...wordLength{
            characterSelector.setTitle("\(wordInArray[index-1])", forSegmentAt: index-1)
        }
        userAnswer.text = ""
        
        for index in 0...characterSelector.numberOfSegments-1 {
            characterSelector.setEnabled(true, forSegmentAt: index)
        }
        setStateToPreparing()
        response.isHidden = true
        cleanMemory()
    }
    

    @IBAction func checkAnswer(_ sender: Any) {
        var isCorrect:Bool = false
        if userAnswer.text != nil {
            isCorrect=wordModel.isDefined(userAnswer.text!)
        }
        if isCorrect {
            response.text = wordModel.correctResponse()
            numberOfCorrect = numberOfCorrect + 1
        } else {
            response.text = wordModel.incorrectResponse()
        }
        response.isHidden=false
        numberOfQuestion=numberOfQuestion+1
        userAnswer.text=word
        questionCounterUpdate()
        setStateToDefault()
        
    }
    
    
    @IBAction func clickUndo(_ sender: Any) {
        characterSelector.setEnabled(true, forSegmentAt: memory.removeLast())
        userAnswer.text!.removeLast()
        if memory.isEmpty {
            disableButton(button: undoButton)
        }
        disableButton(button: checkButton)
    }
    
    func cleanMemory(){
        if memory.isEmpty==false {
            for _ in 0...memory.count-1{
                memory.removeFirst()
            }
        }
        
    }
    
    func questionCounterUpdate(){
        questionCounter.text=String(numberOfCorrect)+" out of "+String(numberOfQuestion)+" correct"
        
    }
    
    @IBAction func selectCharacter(_ sender: Any) {
        if userAnswer.text != nil{
            userAnswer.text = String(userAnswer.text!)+"\(wordInArray[characterSelector.selectedSegmentIndex])"
        } else {
            userAnswer.text = "\(wordInArray[characterSelector.selectedSegmentIndex])"
        }
        selectedIndex = characterSelector.selectedSegmentIndex
        characterSelector.setEnabled(false, forSegmentAt: characterSelector.selectedSegmentIndex)
        memory.append(selectedIndex)
        
    
        characterSelector.selectedSegmentIndex = -1
        if memory.count == wordLength {
            enableButton(button: checkButton)
        }
        enableButton(button: undoButton)
        setStateToPlaying()
        
    }
    
    func disableButton(button: UIButton){
        button.backgroundColor = grey
        button.isEnabled = false
    }
    
    func enableButton(button: UIButton){
        button.backgroundColor = buttonBlue
        button.isEnabled = true
    }
    
    func disableSegCtrl(segCtrl: UISegmentedControl){
        for index in 0...segCtrl.numberOfSegments-1{
            segCtrl.setEnabled(false, forSegmentAt: index)
        }
    }
    
    func enableSegCtrl(segCtrl: UISegmentedControl){
        for index in 0...segCtrl.numberOfSegments-1{
            segCtrl.setEnabled(true, forSegmentAt: index)
        }
    }
    
    func setStateToDefault(){
        disableButton(button: undoButton)
        disableButton(button: checkButton)
        disableSegCtrl(segCtrl: characterSelector)
        newWordButton.isEnabled=true
        newWordButton.backgroundColor=newWordOrange
        enableSegCtrl(segCtrl: wordLengthSelector)
    }
    func setStateToPreparing(){
        disableButton(button: undoButton)
        disableButton(button: checkButton)
        enableSegCtrl(segCtrl: characterSelector)
        newWordButton.isEnabled=false
        newWordButton.backgroundColor=grey
        disableSegCtrl(segCtrl: wordLengthSelector)
    }
    
    
    func setStateToPlaying(){
        disableSegCtrl(segCtrl: wordLengthSelector)
        enableButton(button: undoButton)
        newWordButton.isEnabled=false
        newWordButton.backgroundColor=grey
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setStateToDefault()
    }

    
    
    
}

