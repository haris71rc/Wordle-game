//
//  BoardViewController.swift
//  wordle
//
//  Created by Mohd Haris on 02/03/24.
//

import UIKit

protocol BoardViewControllerDataSource:AnyObject{
    var currentGuesses : [[Character?]] {get}
    func boxColor(at indexPath:IndexPath) -> UIColor?
}

class BoardViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    weak var dataSource : BoardViewControllerDataSource?
    
   private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -35),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
   public func reloadData(){
        collectionView.reloadData()
    }
}

extension BoardViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.currentGuesses.count ?? 0 // if you're not able to get the count, then return will be 0 ?? Symbolises that.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let guesses = dataSource?.currentGuesses ?? []
        return guesses[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else{
            fatalError()
        }
        
        cell.backgroundColor = dataSource?.boxColor(at: indexPath)
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 2.5
        
        let guesses = dataSource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row]{
            cell.configure(with: letter)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 50, height: 50)
        let margin:CGFloat = 20
        let size:CGFloat = (collectionView.frame.size.width - margin)/5
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
