//
//  TitleViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/02/20.
//

import UIKit
import RxSwift
import RxCocoa

class TitleViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupBinding() {
        
        loginButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                loginViewController.modalPresentationStyle = .fullScreen
                self?.present(loginViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let storyboard = UIStoryboard(name: "Register", bundle: nil)
                let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                registerViewController.modalPresentationStyle = .fullScreen
                self?.present(registerViewController, animated: true, completion: nil)
                
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
}
