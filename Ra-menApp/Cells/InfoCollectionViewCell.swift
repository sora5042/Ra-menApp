//
//  InfoCollectionViewCell.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InfoCollectionViewCell: UICollectionViewCell {
    
    var user: User?
    
    let nameLabel = ProfileLabel(title: "名前")
    let ageLabel = ProfileLabel(title: "年齢")
    let residenceLabel = ProfileLabel(title: "居住地")
    let favoriteLabel = ProfileLabel(title: "お気に入りのラーメン屋")
    
    let nameTextField = ProfileTextField(placeholder: "名前")
    let ageTextField = ProfileTextField(placeholder: "年齢")
    let residenceTextField = ProfileTextField(placeholder: "居住地")
    let favoriteTextField = ProfileTextField(placeholder: "お気に入りのラーメン屋")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        ageTextField.keyboardType = .numberPad
        
        setupLayout()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.fetchUserFromFirestore(uid: uid) { (user) in
            if let user = user {
                self.user = user
                
                self.nameTextField.text = user.name
                self.ageTextField.text = user.age
                self.residenceTextField.text = user.residence
                self.favoriteTextField.text = user.favorite
                
            }
        }
    }
    
    private func setupLayout() {
        
        let views = [[nameLabel, nameTextField], [ageLabel, ageTextField], [residenceLabel, residenceTextField], [favoriteLabel, favoriteTextField]]
        
        let stackViews = views.map { (views) -> UIStackView in
            guard let label = views.first as? UILabel,
                  let textField = views.last as? UITextField else { return UIStackView() }
            
            let stackView = UIStackView(arrangedSubviews: [label, textField])
            stackView.axis = .vertical
            stackView.spacing = 5
            textField.anchor(height: 50)
            return stackView
        }
        
        let baseStackView = UIStackView(arrangedSubviews: stackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 15
        
        addSubview(baseStackView)
        nameTextField.anchor(width: UIScreen.main.bounds.width - 40, height: 80)
        baseStackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, topPadding: 10, bottomPadding: 10, leftPadding: 20, rightPadding: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

