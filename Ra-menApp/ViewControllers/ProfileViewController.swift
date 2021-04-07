//
//  ProfileViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/02/24.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke
import PKHUD

class ProfileViewController: UIViewController {
    
    var user: User?
    var post: Post?
    
    private let disposeBag = DisposeBag()
    private let cellId = "cellId"
    
    @IBOutlet weak var editProfileImageButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupBindings()
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
        
        Firestore.fetchPostFromFirestore(uid: uid) { (post) in
            
            if let post = post {
                
                self.post = post
            }
        }
    }
    
    //MARK: - Methods
    private func setupViews() {
        
        let image = UIImage(systemName: "square.and.pencil")
        editProfileImageButton.setImage(image, for: .normal)
        editProfileImageButton.layer.cornerRadius = 15
        
        nameLabel.textColor = .black
        
        profileImageView.layer.cornerRadius = 75
        
        infoCollectionView.delegate = self
        infoCollectionView.dataSource = self
        infoCollectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupBindings() {
        
        logoutButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                do {
                    
                    try Auth.auth().signOut()
                    let storyboard = UIStoryboard(name: "Title", bundle: nil)
                    let titleViewController = storyboard.instantiateViewController(withIdentifier: "TitleViewController") as! TitleViewController
                    titleViewController.modalPresentationStyle = .fullScreen
                    self?.present(titleViewController, animated: true, completion: nil)
                    
                } catch  {
                    print("ログアウトに失敗しました。\(error)")
                }
            }
            .disposed(by: disposeBag)
        
        editProfileImageButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.showAlert()
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoCollectionViewCell
        
        cell.user = self.user
        cell.backgroundColor = .rgb(red: 255, green: 230, blue: 139)
        
        saveButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                HUD.show(.progress)
                guard let image = self?.profileImageView.image else { return }
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
                        
                        let name = cell.nameTextField.text ?? ""
                        let age = cell.ageTextField.text ?? ""
                        let residence = cell.residenceTextField.text ?? ""
                        let favorite = cell.favoriteTextField.text ?? ""
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        
                        
                        Firestore.updateUserInfoToFirestore(profileImageUrl: urlString, name: name, age: age, residence: residence, favorite: favorite, uid: uid)
                        HUD.hide()
                    }
                }
            }
            .disposed(by: disposeBag)
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.clipsToBounds = true
            self.profileImageView.image = editImage
            
        } else if let originalImage = info[.originalImage] as? UIImage{
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.clipsToBounds = true
            self.profileImageView.image = originalImage
        }
        
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
