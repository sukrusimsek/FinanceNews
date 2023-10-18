//
//  ViewController.swift
//  FinanceNews
//
//  Created by Şükrü Şimşek on 16.10.2023.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - Properties
    let cellId : String = "cellId"
    var collectionView: UICollectionView!
    let breakingNewsImage = ["1","2","3","4","5","6","7","8"]
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        style()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CustomCellForColView.self, forCellWithReuseIdentifier: cellId)
    }


}
//MARK: - Helpers
extension HomeViewController {
    private func style() {
        
    }
    private func layout() {
        let layoutForColView = UICollectionViewFlowLayout()
        layoutForColView.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForColView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            //collectionView layout
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            
        ])
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breakingNewsImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellForColView
        cell.breakingImageView.image = UIImage(named: breakingNewsImage[indexPath.row])
        //CustomCellView Oluşturduktan sonra buraya dön
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Detay Sayfasına Gidilecek \(indexPath.row)")
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height / 1.5)
    }
}

class CustomCellForColView: UICollectionViewCell {
    let breakingImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(breakingImageView)
        breakingImageView.layer.cornerRadius = 10
        breakingImageView.layer.masksToBounds = true
        
        breakingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            breakingImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            breakingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            breakingImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            breakingImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
