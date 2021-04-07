//
//  PostViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Nuke
import PKHUD

class PostViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let postViewModel = PostViewModel()
    
    var user: User?
    
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var storeNemeTextField: UITextField!
    @IBOutlet weak var recommendPointTextFeild: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupView()
        setupBinding()
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
    
    // MARK: Methods
    private func setupView() {
        
        recommendPointTextFeild.keyboardType = .numberPad
        postImageButton.layer.borderWidth = 2.5
        postImageButton.layer.borderColor = UIColor.rgb(red: 255, green: 200, blue: 130).cgColor
        sendButton.layer.cornerRadius = 12
        
    }
    
    private func setupBinding() {
        
        //buttonのbinding
        postImageButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.showAlert()
                
            }
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.createPost()
            }
            .disposed(by: disposeBag)
        
        //textFieldのbinding
        recommendPointTextFeild.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.postViewModel.recommendTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        commentTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.postViewModel.commentTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        //viewModelのbinding
        postViewModel.validPostDriver
            .drive { validPostAll in
                print("validPostAll: ", validPostAll)
                self.sendButton.isEnabled = validPostAll
                self.sendButton.backgroundColor = validPostAll ? .rgb(red: 255, green: 180, blue: 110) : .init(white: 0.7, alpha: 1)
            }
            .disposed(by: disposeBag)
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
    
    private func createPost() {
        
        guard let image = postImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { (matadata, err) in
            
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました。\(err)")
                return
            }
            
            storageRef.downloadURL { (url, err) in
                
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました。\(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                guard let storeName = self.storeNemeTextField.text else { return }
                guard let recommendPoint = self.recommendPointTextFeild.text else { return }
                guard let comment = self.commentTextField.text else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                guard let name = self.user?.name else { return }
                guard let profileImageUrl = self.user?.profileImageUrl else { return }
                guard let place = self.placeTextField.text else { return }
                
                let doctId = self.randomString(length: 20)
                HUD.show(.progress)
                Firestore.postDataToFirestore(name: name, profileImageUrl: profileImageUrl, postImageUrl: urlString, storeName: storeName, recommendPoint: recommendPoint, place: place, comment: comment, uid: uid, docId: doctId) { (success) in
                    HUD.hide()
                    if success {
                        print("処理が完了")
                        
                        let storyboard = UIStoryboard(name: "BaseTabBar", bundle: nil)
                        let baseTabBarViewController = storyboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                        baseTabBarViewController.modalPresentationStyle = .fullScreen
                        baseTabBarViewController.modalTransitionStyle = .coverVertical
                        self.present(baseTabBarViewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
        
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func doCamera() {
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func doAlbum() {
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editImage = info[.editedImage] as? UIImage {
            postImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            postImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        postImageButton.setTitle("", for: .normal)
        postImageButton.imageView?.contentMode = .scaleAspectFill
        postImageButton.contentHorizontalAlignment = .fill
        postImageButton.contentVerticalAlignment = .fill
        postImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            
            self.doCamera()
        }
        
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
}
