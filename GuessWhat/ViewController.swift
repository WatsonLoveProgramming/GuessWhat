//
//  ViewController.swift
//  GuessWhat
//
//  Created by Watson Li on 8/24/17.
//  Copyright © 2017 Huaxin Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //UIButtons and UIlabels for operands and products
    @IBOutlet weak var operandButton1: UIButton!
    @IBOutlet weak var operandButton2: UIButton!
    @IBOutlet weak var operandButton3: UIButton!
    @IBOutlet weak var operandButton4: UIButton!
    @IBOutlet weak var operandButton5: UIButton!
    @IBOutlet weak var operandButton6: UIButton!
    
    @IBOutlet weak var productLabel1: UILabel!
    @IBOutlet weak var productLabel2: UILabel!
    @IBOutlet weak var productLabel3: UILabel!
    
    //UIButtons for answer choices
    @IBOutlet weak var optionButton1: UIButton!
    @IBOutlet weak var optionButton2: UIButton!
    @IBOutlet weak var optionButton3: UIButton!
    @IBOutlet weak var optionButton4: UIButton!
    @IBOutlet weak var optionButton5: UIButton!
    @IBOutlet weak var optionButton6: UIButton!
    
    //All other buttoms and labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButtom: UIButton!
    @IBOutlet weak var UndoButtom: UIButton!
    @IBOutlet weak var nextButtom: UIButton!
    @IBOutlet weak var correntLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    //an array of questions' operands
    var touches : [UIButton] = []
    //an array of answer choices
    var answers : [UIButton] = []
    //an array of selected choices
    var selected : [(UIButton, UIButton)] = []
    //current round number
    var round : Int = 0
    //correct number of the two round game
    var correctNum : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        round = 1
        roundExecute()
    }
    
    /*
     This method executes when a new round starts
     */
    func roundExecute(){
        //Initialize arrays and default settings
        titleLabel.text = "Round  " + String(round)
        checkButtom.isEnabled = false
        UndoButtom.isEnabled = false
        nextButtom.isEnabled = false
        correntLabel.text = ""
        resultLabel.text = ""
        touches = [operandButton1,operandButton2,operandButton3,operandButton4,operandButton5,operandButton6]
        answers = [optionButton1,optionButton2,optionButton3,optionButton4,optionButton5,optionButton6]
        
        for i in touches{
            i.isEnabled = true
            i.setTitle("???", for: .normal)
        }
        for i in answers{
            i.isEnabled = false
        }
        
        //Randomly generate questions
        for i in 0...(answers.count - 1){
            
            answers[i].titleLabel?.text=(String(arc4random_uniform(18) + 2))
            answers[i].setTitle(answers[i].titleLabel?.text, for: .normal)
        }
        answers.shuffle()
        
        let a = Int((answers[0].titleLabel?.text)!)
        let b = Int((answers[1].titleLabel?.text)!)
        let c = Int((answers[2].titleLabel?.text)!)
        let d = Int((answers[3].titleLabel?.text)!)
        let e = Int((answers[4].titleLabel?.text)!)
        let f = Int((answers[5].titleLabel?.text)!)
        productLabel1.text = String(a! * b!)
        productLabel2.text = String(c! * d!)
        productLabel3.text = String(e! * f!)
        
    }

    /*
     This action method executes when one of the operand is touched.
     */
    @IBAction func touchAction(_ sender: UIButton) {
        //Highlight the chosen operand, temporary disable all operands, enable answer choices
        sender.backgroundColor = UIColor.white
        for i in touches{
            i.isEnabled = false
        }
        for i in answers{
            i.isEnabled = true
        }
        UndoButtom.isEnabled = false
    }
    
    /*
     This action method executes when one of the answer choices is touched
     */
    @IBAction func answerAction(_ sender: UIButton) {
        //Remove the chosen operand and answer from the array, append selected choice pair to an array
        for i in touches{
            if i.backgroundColor == UIColor.white {
                sender.isEnabled = false
                i.setTitle(sender.titleLabel?.text, for: .normal)
                i.backgroundColor = nil
                touches.remove(at: touches.index(of: i)!)
                answers.remove(at: answers.index(of: sender)!)
                selected.append(i, sender)
            }else{
                i.isEnabled = true
            }
        }
        
        //Check if all 6 answers are chosen, enables check buttom
        if touches == []{
            checkButtom.isEnabled = true
        }
        UndoButtom.isEnabled = true
    }
    
    /*
     This method executes when Check buttom is touched
     */
    @IBAction func checkAnswer(_ sender: Any) {
        checkButtom.isEnabled = false
        //check correct answer
        if Int((operandButton1.titleLabel?.text)!)! * Int((operandButton4.titleLabel?.text)!)! == Int(productLabel1.text!)!
        && Int((operandButton2.titleLabel?.text)!)! * Int((operandButton5.titleLabel?.text)!)! == Int(productLabel2.text!)!
        && Int((operandButton3.titleLabel?.text)!)! * Int((operandButton6.titleLabel?.text)!)! == Int(productLabel3.text!)!{
            correntLabel.text = "Correct!"
            correntLabel.textColor = UIColor.green
            correctNum += 1
        }else{
            correntLabel.text = "InCorrect!"
            correntLabel.textColor = UIColor.red
        }
        
        //show results of the 2 rounds
        if round == 2 {
            resultLabel.text = String(correctNum) + "/2 Correct"
            if correctNum == 0{
                resultLabel.textColor = UIColor.red
            }else if correctNum == 1{
                resultLabel.textColor = UIColor.orange
            }else if correctNum == 2{
                resultLabel.textColor = UIColor.green
            }
            correctNum = 0
            round = 0
            nextButtom.setTitle("Reset", for: .normal)
        }
        nextButtom.isEnabled = true
        UndoButtom.isEnabled = false
    }
    
    /*
     This method executes when Undo buttom is touched
     */
    @IBAction func UndoChoice(_ sender: Any) {
        //add the pair removed from touches and answer arrays back
        if !selected.isEmpty {
            let tmp = selected.popLast()
            touches.append((tmp?.0)!)
            (tmp?.0)!.isEnabled = true
            (tmp?.0)!.setTitle("???", for: .normal)
            answers.append((tmp?.1)!)
            (tmp?.1)!.isEnabled = true
            checkButtom.isEnabled = false
        }
        
    }
    
    /*
     This method executes when Next buttom is touched, it starts a new round
     */
    @IBAction func nextRound(_ sender: Any) {
        nextButtom.setTitle("Next", for: .normal)
        round += 1
        roundExecute()
    }
    
}

