//
//  SearchViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/03.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var mapImageButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupBindings()
        
    }
    
    private func setupBindings() {
        
        mapButton.rx.tap
            .asDriver()
            .drive {  [weak self] _ in
                
                self?.setupMapApps()
                
            }
            .disposed(by: disposeBag)
        
        mapImageButton.rx.tap
            .asDriver()
            .drive {  [weak self] _ in
                
                self?.setupMapApps()
                
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
    
    private func setupMapApps() {
        
        let latitude = "35.692096424393867"
        let longitude = "139.77235727788792"
        let ramen = "Ra-men"
        let urlString: String!
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            urlString = "comgooglemaps://?q=\(ramen)&center=\(latitude),\(longitude)"
            
        } else {
            urlString = "http://maps.apple.com/?q=\(ramen)"
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
        
    }
}
