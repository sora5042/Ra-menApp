//
//  PostCollectionViewCell.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/09.
//

import UIKit
import FirebaseFirestore
import Nuke
import RxCocoa
import RxSwift

class PostCollectionViewCell: UICollectionViewCell {
    
    private let disposeBag = DisposeBag()
    
    var post: Post? {
        didSet {
            
            if let post = post {
                
                userNameLabel.text = post.name
                postDateLabel.text = dateFormatterForDateLabel(date: post.createdAt.dateValue())
                storeNameLabel.text = post.storeName
                recommendLabel.text = post.recommendPoint
                commentLabel.text = post.comment
                placeLabel.text = post.place
                
                if let url = URL(string: post.postImageUrl) {
                    Nuke.loadImage(with: url, into: postImageView)
                    
                }
                
                if let url = URL(string: post.profileImageUrl) {
                    Nuke.loadImage(with: url, into: profileImageView)
                }
            }
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 15
        backgroundColor = UIColor.rgb(red: 255, green: 230, blue: 139)
        
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
