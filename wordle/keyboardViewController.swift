//
//  keyboardViewController.swift
//  wordle
//
//  Created by Mohd Haris on 02/03/24.
//

import UIKit

protocol keyboardViewControllerDelegate : AnyObject {
    func KeyboardViewController(_ vc:keyboardViewController, didTapKey letter: Character)
}

class keyboardViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    let letters = ["qwertyuiop","asdfghjkl","zxcvbnm"]
   private var keys : [[Character]] = []
    
    weak var delegate:keyboardViewControllerDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
        for row in letters{
            let chars = Array(row)
            keys.append(chars)
        }
    }
}

extension keyboardViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else{
            fatalError()
        }
        let letter = keys[indexPath.section][indexPath.row]
        cell.configure(with: letter)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 50, height: 50)
        let margin:CGFloat = 20
        let size:CGFloat = (collectionView.frame.size.width - margin)/10
        return CGSize(width: size, height: size*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var left:CGFloat = 1
        var right:CGFloat = 1
        
        let margin:CGFloat = 20
        let size:CGFloat = (collectionView.frame.size.width - margin)/10
        
        let count:CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let inset:CGFloat = (collectionView.frame.size.width - (count*size) - (2*count))/2
        
        left = inset
        right = inset
        
        return UIEdgeInsets(top: 2, left: left, bottom: 2, right: right)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let letter = keys[indexPath.section][indexPath.row]
        delegate?.KeyboardViewController(self, didTapKey: letter)
    }
}
