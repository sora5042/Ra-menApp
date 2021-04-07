//
//  LookProfileViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/29.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import Nuke

class LookProfileViewController: UIViewController {
    
    var user: User?
    var post: Post?
    
    private let disposeBag = DisposeBag()
    private let cellId = "cellId"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lookProfileCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.fetchUserFromFirestore(uid: uid) { (user) in
            if let user = user {
                self.user = user
                self.nameLabel.text = user.name
                
                if let url = URL(string: user.profileImageUrl ?? "" ) {
                    Nuke.loadImage(with: url, into: self.profileImageView)
                    
                }
            }
        }
    }
    
    private func setupViews() {
        
        profileImageView.layer.cornerRadius = 65
        
        lookProfileCollectionView.delegate = self
        lookProfileCollectionView.dataSource = self
        lookProfileCollectionView.register(LookProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupGradientLayer() {
        
        let layer = CAGradientLayer()
        let startColor = UIColor.rgb(red: 255, green: 230, blue: 139).cgColor
        let endColor = UIColor.rgb(red: 255, green: 255, blue: 180).cgColor
        
        layer.colors = [startColor, endColor]
        layer.locations = [0.0, 1.3]
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
    }
}

extension LookProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = lookProfileCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LookProfileCollectionViewCell
        
        cell.user = self.user
        cell.backgroundColor = .rgb(red: 255, green: 230, blue: 139)
        
        return cell
    }
}
