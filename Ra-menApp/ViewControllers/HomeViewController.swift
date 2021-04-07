//
//  ViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/02/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let cellId = "cellId"
    private var user: User?
    private var users = [User]()
    private var post: Post?
    private var posts = [Post]()
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            
            let storyboard = UIStoryboard(name: "Title", bundle: nil)
            let titleViewController = storyboard.instantiateViewController(withIdentifier: "TitleViewController") as! TitleViewController
            titleViewController.modalPresentationStyle = .fullScreen
            self.present(titleViewController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: Methods
    private func fetchUsers() {
        
        Firestore.fetchUsersFromFirestore { (users) in
            
            self.users = users
            print("ユーザー情報の取得に成功")
        }
    }
    
    private func fetchPosts() {
        
        Firestore.fetchPostsFromFirestore { (posts) in
            
            self.posts = posts
            self.posts.sort { (e1, e2) -> Bool in
                let e1Date = e1.createdAt.dateValue()
                let e2Date = e2.createdAt.dateValue()
                return e1Date > e2Date
            }
            
            print("post情報の取得に成功")
            self.postCollectionView.reloadData()
        }
    }
    
    private func setupView() {
        
        topView.backgroundColor = .rgb(red: 255, green: 200, blue: 60)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width
        
        return .init(width: width, height: 535)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCollectionViewCell
        let profileButton = cell.contentView.viewWithTag(1) as! UIButton
        cell.post = posts[indexPath.row]
        profileButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                
                let storyboard = UIStoryboard(name: "LookProfile", bundle: nil)
                let lookProfileViewController = storyboard.instantiateViewController(withIdentifier: "LookProfileViewController") as! LookProfileViewController
                lookProfileViewController.post = self?.post
                lookProfileViewController.user = self?.user
                self?.present(lookProfileViewController, animated: true, completion: nil)
                
            }
            .disposed(by: disposeBag)
        
        return cell
    }
}
