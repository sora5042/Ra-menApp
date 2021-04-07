//
//  LookProfileCollectionViewCell.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/30.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LookProfileCollectionViewCell: UICollectionViewCell {
    
    var user: User?
    var users = [User]()
    var post: Post?
    
    let nameLabel = ProfileLabel(title: "名前")
    let ageLabel = ProfileLabel(title: "年齢")
    let residenceLabel = ProfileLabel(title: "居住地")
    let favoriteLabel = ProfileLabel(title: "お気に入りのラーメン屋")
    
    let userNameLabel = ProfileLabel()
    let userAgeLabel = ProfileLabel()
    let userResidenceLabel = ProfileLabel()
    let userFavoriteLabel = ProfileLabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupLayout()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.fetchUserFromFirestore(uid: uid) { (user) in
            if let user = user {
                self.user = user
                
                self.userNameLabel.text = user.name
                self.userAgeLabel.text = user.age
                self.userResidenceLabel.text = user.residence
                self.userFavoriteLabel.text = user.favorite
                
            }
        }
    }
    
    private func setupLayout() {
        
        let views = [[nameLabel, userNameLabel], [ageLabel, userAgeLabel], [residenceLabel, userResidenceLabel], [favoriteLabel, userFavoriteLabel]]
        
        let stackViews = views.map { (views) -> UIStackView in
            guard let label = views.first as? UILabel,
                  let userLabel = views.last as? UILabel else { return UIStackView() }
            
            let stackView = UIStackView(arrangedSubviews: [label, userLabel])
            stackView.axis = .vertical
            stackView.spacing = 5
            userLabel.anchor(height: 50)
            return stackView
        }
        
        let baseStackView = UIStackView(arrangedSubviews: stackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 15
        
        addSubview(baseStackView)
        userNameLabel.anchor(width: UIScreen.main.bounds.width - 40, height: 80)
        baseStackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, topPadding: 10, leftPadding: 20, rightPadding: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

