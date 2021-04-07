//
//  SignUpViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/05.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PKHUD

class RegisterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let registerViewModel = RegisterViewModel()
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    private func setupView() {
        
        profileImageButton.layer.cornerRadius = 100
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    private func setupBindings() {
        
        // textFieldのbinding
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.registerViewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.registerViewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        userNameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.registerViewModel.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        // buttonのbinding
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.createUser()
            }
            .disposed(by: disposeBag)
        
        profileImageButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.showAlert()
            }
            .disposed(by: disposeBag)
        
        alreadyHaveAccountButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                loginViewController.modalPresentationStyle = .fullScreen
                loginViewController.modalTransitionStyle = .crossDissolve
                self?.present(loginViewController, animated: true, completion: nil)
                
            }
            .disposed(by: disposeBag)
        
        // viewModelのbinding
        registerViewModel.validRegisterDriver
            .drive { validAll in
                print("validAll: ", validAll)
                self.registerButton.isEnabled = validAll
                self.registerButton.backgroundColor = validAll ? .rgb(red: 91, green: 201, blue: 70) : .init(white: 0.7, alpha: 1)
            }
            .disposed(by: disposeBag)
    }
    
    private func createUser() {
        
        guard let image = profileImageButton.imageView?.image else { return }
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
                
                let email = self.emailTextField.text
                let password = self.passwordTextField.text
                let name = self.userNameTextField.text
                
                HUD.show(.progress)
                
                Auth.createUserToFireAuth(email: email, password: password, name: name, profileImageUrl: urlString) { success in
                    HUD.hide()
                    if success {
                        
                        print("処理が完了")
                        let storyboard = UIStoryboard(name: "BaseTabBar", bundle: nil)
                        let baseTabBarViewController = storyboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                        baseTabBarViewController.modalPresentationStyle = .fullScreen
                        baseTabBarViewController.modalTransitionStyle = .coverVertical
                        self.present(baseTabBarViewController, animated: true, completion: nil)
                        
                    } else {
                        
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        
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

