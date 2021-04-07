//
//  LoginViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/05.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import PKHUD

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let loginViewModel = LoginViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    private func setupBinding() {
        
        //buttonのbinding
        dontHaveAccountButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let storyboard = UIStoryboard(name: "Register", bundle: nil)
                let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                registerViewController.modalPresentationStyle = .fullScreen
                registerViewController.modalTransitionStyle = .crossDissolve
                self?.present(registerViewController, animated: true, completion: nil)
                
            }
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                self?.login()
            }
            .disposed(by: disposeBag)
        
        //textFieldのbinding
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.loginViewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.loginViewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        //viewModelのbinding
        loginViewModel.validLoginDriver
            .drive { validLoginAll in
                print("validLoginAll: ", validLoginAll)
                self.loginButton.isEnabled = validLoginAll
                self.loginButton.backgroundColor = validLoginAll ? .rgb(red: 86, green: 169, blue: 221) : .init(white: 0.7, alpha: 1)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func login() {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        HUD.show(.progress)
        Auth.loginWithFireAuth(email: email, password: password) { (success) in
            HUD.hide()
            if success {
                
                let storyboard = UIStoryboard(name: "BaseTabBar", bundle: nil)
                let baseTabBarViewController = storyboard.instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
                baseTabBarViewController.modalPresentationStyle = .fullScreen
                baseTabBarViewController.modalTransitionStyle = .coverVertical
                self.present(baseTabBarViewController, animated: true, completion: nil)
                
            } else {
                
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
