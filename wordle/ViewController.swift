//
//  ViewController.swift
//  wordle
//
//  Created by Mohd Haris on 02/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    let answers = ["dream","blunt","muudi","fanta"]
    
    
    var answer = ""
    private var gueses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5),
                                      count: 6) // in wordle we have 6 guesses therefore we have 6 row and 5 for number of columns because our word will be of five characters
    
    let keyboardVC = keyboardViewController()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? ""
        view.backgroundColor = .gray
        addChildren()
    }

    private func addChildren(){
        
        // first, you add the keyboard view controller
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        // now adding the board view controller
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.dataSource = self
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        
        //isse basically mai kar rha hu jo dono VC add hue h vo kis propotion me show honge
        addConstraints()
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.6),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }

}

extension ViewController:keyboardViewControllerDelegate{
    func KeyboardViewController(_ vc: keyboardViewController, didTapKey letter: Character) {
        
        //update guesses
        var stop = false
        
        for i in 0..<gueses.count{
            for j in 0..<gueses[i].count{
                if gueses[i][j]==nil{
                    gueses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop{
                break
            }
        }
        
        boardVC.reloadData()
    }
}

extension ViewController:BoardViewControllerDataSource{
        
    var currentGuesses: [[Character?]] {
        return gueses
    }
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        
        let rowIndex = indexPath.section
        let count = gueses[rowIndex].compactMap({$0}).count
        guard count == 5 else{
            return nil
        }
        
        let indexedAnswer = Array(answer)

        guard let letter = gueses[indexPath.section][indexPath.row],indexedAnswer.contains(letter) else{
            return nil
        }
        
        if indexedAnswer[indexPath.row] == letter{
            return .systemGreen
        }
        
        return .systemOrange
    }
}

