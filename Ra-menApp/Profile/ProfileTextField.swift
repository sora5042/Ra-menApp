//
//  ProfileTextField.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/25.
//

import UIKit

class ProfileTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.textColor = .black
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.borderStyle = .bezel
        self.backgroundColor = .rgb(red: 245, green: 245, blue: 245)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
