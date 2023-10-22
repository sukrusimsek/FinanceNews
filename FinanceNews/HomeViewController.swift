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
    
    fileprivate var collectionViewForBreaking: UICollectionView!
    
    let breakingNewsImage = ["1","2","3","4","5","6","7","8","9"]
    
    
    fileprivate var collectionViewForPrice: UICollectionView!
    fileprivate var timer: Timer?
    fileprivate var direction:MarqueeDirection = .left
    
    let customTexts = ["Dolar: 28.40","Euro: 29.90","Sterlin: 34.70","Gram Altın: 1760","Bist: 7769,0","Bitcoin: $28.465","Ons Altın: $1970"]
    
    enum MarqueeDirection : CGFloat {
            case left = 1
            case right = -1
        }

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupCollectionViewForCurrency()
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelTimer()
    }
    
    func startTimer() {
        guard timer == nil, collectionViewForPrice.numberOfSections == 3 else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(scroll(sender:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func cancelTimer() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }
    @objc
        func scroll(sender:Timer) {
            self.collectionViewForPrice.contentOffset.x += direction.rawValue
        }
    private func setupCollectionViewForCurrency() {
        /*collectionViewForBreaking = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120), collectionViewLayout: layoutForColView)
        collectionViewForBreaking.translatesAutoresizingMaskIntoConstraints = false
        collectionViewForBreaking.register(CustomCellForColView.self, forCellWithReuseIdentifier: cellId)
        collectionViewForBreaking.dataSource = self
        collectionViewForBreaking.delegate = self
        collectionViewForBreaking.showsHorizontalScrollIndicator = false
        view.addSubview(collectionViewForBreaking)*/
        
        
       
        
    }
}
//MARK: - Helpers
extension HomeViewController {
    private func layout() {
        let layoutForColView = UICollectionViewFlowLayout()
        layoutForColView.scrollDirection = .horizontal
        collectionViewForBreaking = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50), collectionViewLayout: layoutForColView)
        collectionViewForBreaking.translatesAutoresizingMaskIntoConstraints = false
        collectionViewForBreaking.register(CustomCellForColView.self, forCellWithReuseIdentifier: cellId)
        collectionViewForBreaking.dataSource = self
        collectionViewForBreaking.delegate = self
        collectionViewForBreaking.showsHorizontalScrollIndicator = false
        view.addSubview(collectionViewForBreaking)
        
        collectionViewForBreaking.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionViewForBreaking.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4).isActive = true
        collectionViewForBreaking.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4).isActive = true
        collectionViewForBreaking.heightAnchor.constraint(equalToConstant: 120).isActive = true
        collectionViewForBreaking.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        layout1.minimumLineSpacing = 2
        layout1.minimumInteritemSpacing = 2
        layout1.itemSize = CGSize(width: 80, height: 50)
        
        collectionViewForPrice = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10), collectionViewLayout: layout1)
        collectionViewForPrice.delegate = self
        collectionViewForPrice.dataSource = self
        collectionViewForPrice.backgroundColor = .white
        collectionViewForPrice.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewForPrice.showsHorizontalScrollIndicator = false
        collectionViewForPrice.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionViewForPrice)
        
        collectionViewForPrice.topAnchor.constraint(equalTo: collectionViewForBreaking.bottomAnchor).isActive = true
        collectionViewForPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionViewForPrice.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionViewForPrice.heightAnchor.constraint(equalToConstant: 18).isActive = true
        collectionViewForPrice.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }


}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewForBreaking {
            return breakingNewsImage.count
        } else if collectionView == collectionViewForPrice {
            return customTexts.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewForBreaking {
            let cell = collectionViewForBreaking.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellForColView
            cell.breakingImageView.image = UIImage(named: breakingNewsImage[indexPath.row])
            //CustomCellView Oluşturduktan sonra buraya dön
            return cell
        } else if collectionView == self.collectionViewForPrice {
            let cell = collectionViewForPrice.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
            
            if indexPath.row < customTexts.count {
                //cell.layer.borderWidth = 2
                //cell.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
                cell.label.font = .systemFont(ofSize: 9)
                cell.label.text = customTexts[indexPath.row]
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Detay Sayfasına Gidilecek \(indexPath.row)")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewForPrice {
            return 3
        }
        return 1
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewForBreaking.frame.width/5, height: collectionViewForBreaking.frame.height / 1.5)
    }
}
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let framWidth = collectionViewForPrice.frame.width
        let sectionLength = collectionViewForPrice.contentSize.width/CGFloat(numberOfSections(in: collectionViewForPrice))
        let contentLength = collectionViewForPrice.contentSize.width
        if contentOffsetX <= 0 {
            collectionViewForPrice.contentOffset.x = sectionLength - contentOffsetX
        } else if contentOffsetX >= contentLength - framWidth {
            collectionViewForPrice.contentOffset.x = contentLength - sectionLength - framWidth
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cancelTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0) {
            direction = .right
        } else {
            direction = .left
        }
        startTimer()
    }
}
class CustomCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let view = UILabel()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .systemTeal
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
}

class CustomCellForColView: UICollectionViewCell {
    let breakingImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        breakingImageView.contentMode = .scaleAspectFill
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

