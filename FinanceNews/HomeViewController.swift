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
    let cellIdForCurrency : String = "cell"
    let cellIdForNews: String = "cellNews"
    fileprivate var collectionViewForBreaking: UICollectionView!
    let breakingNewsImage = ["1","2","3","4","5","6","7","8","9"]
    
    let customTexts = ["Dolar: 28.40","Euro: 29.90","Sterlin: 34.70","Gram Altın: 1760","Bist: 7769,0","Bitcoin: $28.465","Ons Altın: $1970"]
    
    fileprivate var collectionViewForHomeNews: UICollectionView!
    let imageForTakeApi = ["a","b","c","d","e","f","g","h","k","l","m","n"]
    let newsTexts = ["Hazine, 2 yıllık tahville 1,82 milyar TL borçlandı", "Şimşek’e göre Gabar’daki petrol cari açığı kalıcı olarak azaltacak", "10 yıl vadeli ABD Hazine kağıdının getirisi 16 yıl sonra yüzde 5'i geçti", "Hafize Gaye Erkan, Powell ile bir araya geldi", "Hamasın Finansal Gücü Sadece İran Mı?", "Portakal Suyu Fiyatı neden 3'e katlandı?", "Bitcoin tekrardan 30.000$ üstüne çıktı.", "Borsa İstanbul günü %3.19 yükseliş ile kapattı.", "TABGD Halka arzına rekor talep: 4.949.462 ", "30 Ekimde Ford Otosan 28.2720 TL Temettü dağıtacak.", "Michael Saylor'ın milyar dolarlık Bitcoin yatırımları kâr etmeye başladı", "ECB'nin ilk faiz indiriminin 2024 Mart'ta gelmesi bekleniyor"]
    
    
    enum MarqueeDirection : CGFloat {
            case left = 1
            case right = -1
        }
    fileprivate var collectionViewForPrice: UICollectionView!
    fileprivate var timer: Timer?
    fileprivate var direction:MarqueeDirection = .left

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()

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

}
//MARK: - Helpers
extension HomeViewController {
    private func layout() {
        //Breaking
        let layoutForColView = UICollectionViewFlowLayout()
        layoutForColView.scrollDirection = .horizontal
        collectionViewForBreaking = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10), collectionViewLayout: layoutForColView)
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

        //Currency
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        layout1.minimumLineSpacing = 5
        layout1.minimumInteritemSpacing = 5
        layout1.itemSize = CGSize(width: 80, height: 50)
        
        collectionViewForPrice = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 5), collectionViewLayout: layout1)
        collectionViewForPrice.delegate = self
        collectionViewForPrice.dataSource = self
        collectionViewForPrice.backgroundColor = .white
        collectionViewForPrice.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdForCurrency)
        collectionViewForPrice.showsHorizontalScrollIndicator = false
        collectionViewForPrice.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionViewForPrice)
        
        collectionViewForPrice.topAnchor.constraint(equalTo: collectionViewForBreaking.bottomAnchor,constant: -5).isActive = true
        collectionViewForPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionViewForPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionViewForPrice.heightAnchor.constraint(equalToConstant: 18).isActive = true
        collectionViewForPrice.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let layoutForScreen = UICollectionViewFlowLayout()
        layoutForScreen.scrollDirection = .vertical
        layoutForScreen.minimumLineSpacing = 10
        //layoutForScreen.minimumInteritemSpacing = 10
        collectionViewForHomeNews = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50), collectionViewLayout: layoutForScreen)
        collectionViewForHomeNews.dataSource = self
        collectionViewForHomeNews.delegate = self
        collectionViewForHomeNews.backgroundColor = .white
        collectionViewForHomeNews.register(CustomCellForNewsView.self, forCellWithReuseIdentifier: cellIdForNews)
        collectionViewForHomeNews.translatesAutoresizingMaskIntoConstraints = false
        collectionViewForHomeNews.showsVerticalScrollIndicator = false
        view.addSubview(collectionViewForHomeNews)
        
        NSLayoutConstraint.activate([
            collectionViewForHomeNews.topAnchor.constraint(equalTo: collectionViewForPrice.bottomAnchor,constant: 10),
            collectionViewForHomeNews.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8),
            collectionViewForHomeNews.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
            collectionViewForHomeNews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 8),
        ])
    }


}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewForBreaking {
            return breakingNewsImage.count
        } else if collectionView == collectionViewForPrice {
            return customTexts.count
        } else if collectionView == collectionViewForHomeNews {
            return imageForTakeApi.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewForBreaking {
            let cell = collectionViewForBreaking.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellForColView
            cell.breakingImageView.image = UIImage(named: breakingNewsImage[indexPath.row])
            return cell
        } else if collectionView == self.collectionViewForPrice {
            let cell = collectionViewForPrice.dequeueReusableCell(withReuseIdentifier: cellIdForCurrency, for: indexPath) as! CustomCollectionViewCell
            
            if indexPath.row < customTexts.count {
                //cell.layer.borderWidth = 2
                //cell.layer.borderColor = CGColor(red: 69, green: 71, blue: 75, alpha: 1)
                cell.labelForCurrency.font = .systemFont(ofSize: 9)
                cell.labelForCurrency.text = customTexts[indexPath.row]
            }
            return cell
        } else if collectionView == self.collectionViewForHomeNews {
            let cell = collectionViewForHomeNews.dequeueReusableCell(withReuseIdentifier: cellIdForNews, for: indexPath) as! CustomCellForNewsView
            cell.imageForNews.image = UIImage(named: imageForTakeApi[indexPath.row])
            cell.textForNews.font = .systemFont(ofSize: 9)
            cell.textForNews.text = newsTexts[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewForPrice {
            print("Detay Sayfasına Gidilecek \(indexPath.row) Kurlar Hakkında")
        } else if collectionView == collectionViewForBreaking {
            print("Detay Sayfasına Gidilecek \(indexPath.row) Flash Haberler Hakkında")
        } else if collectionView == collectionViewForHomeNews {
            print("Detay Sayfasına Gidilecek \(indexPath.row) Ana Sayfa Haberleri Hakkında")
        }
        
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
        //return CGSize(width: collectionViewForBreaking.frame.width/5, height: collectionViewForBreaking.frame.height / 1.5)
        
        if collectionView == collectionViewForBreaking {
            return CGSize(width: collectionViewForBreaking.frame.width/5, height: collectionViewForBreaking.frame.height / 1.5)
            
        } else if collectionView == collectionViewForPrice {
            return CGSize(width: view.frame.width/4.8, height: 18)
        } else if collectionView == collectionViewForHomeNews {
            return CGSize(width: collectionViewForHomeNews.frame.width/2-5, height: (view.frame.height - collectionViewForPrice.frame.height - collectionViewForBreaking.frame.height)/4)
        }
        
        return CGSize(width: 0, height: 0)
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
    let labelForCurrency: UILabel = {
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
        addSubview(labelForCurrency)
        labelForCurrency.translatesAutoresizingMaskIntoConstraints = false
        labelForCurrency.widthAnchor.constraint(equalToConstant: 80).isActive = true
        labelForCurrency.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelForCurrency.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelForCurrency.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
class CustomCellForNewsView: UICollectionViewCell {
    let imageForNews = UIImageView()
    let textForNews = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageForNews.contentMode = .scaleAspectFill
        textForNews.textColor = .black
        textForNews.textAlignment = .center
        textForNews.backgroundColor = .secondarySystemBackground
        textForNews.layer.cornerRadius = 5
        textForNews.layer.masksToBounds = true
        textForNews.numberOfLines = 2
        imageForNews.layer.cornerRadius = 10
        imageForNews.layer.masksToBounds = true
        imageForNews.layer.shadowColor = UIColor.black.cgColor
        imageForNews.layer.shadowOpacity = 0.5
        imageForNews.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageForNews.layer.shadowRadius = 5
        imageForNews.translatesAutoresizingMaskIntoConstraints = false
        textForNews.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageForNews)
        addSubview(textForNews)
        NSLayoutConstraint.activate([
            imageForNews.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            imageForNews.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            imageForNews.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            imageForNews.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -20),
            
            textForNews.topAnchor.constraint(equalTo: imageForNews.bottomAnchor, constant: 3),
            textForNews.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            textForNews.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            textForNews.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
