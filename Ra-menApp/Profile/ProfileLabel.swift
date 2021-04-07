//
//  ProfileLabel.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/25.
//

import UIKit

class ProfileLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.text = title
        self.textColor = .darkGray
        self.font = .systemFont(ofSize: 14)
        
    }
    
    init() {
        super.init(frame: .zero)
        
        self.textColor = .black
        self.font = .systemFont(ofSize: 17, weight: .bold)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
