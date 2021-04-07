//
//  Firebase-Extention.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/16.
//

import Firebase

// MARK: - Auth
extension Auth {
    
    static func createUserToFireAuth(email: String?, password: String?, name: String?, profileImageUrl: String, completion: @escaping (Bool) -> ()) {
        
        guard let email = email else { return }
        guard let password = password else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
            
            if let err = err {
                print("Auth情報の保存に失敗。: ", err)
                return
            }
            
            guard let uid = auth?.user.uid else { return }
            Firestore.setUserDataToFirestore(email: email, profileImageUrl: profileImageUrl, uid: uid, name: name) { success in
                completion(success)
            }
        }
    }
    
    static func loginWithFireAuth(email: String, password: String, completion: @escaping (Bool) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                print("ログインに失敗。: ", err)
                completion(false)
                return
                
            }
            print("ログインに成功。")
            completion(true)
            
        }
    }
}

// MARK: - Firestore
extension Firestore {
    
    static func setUserDataToFirestore(email: String, profileImageUrl: String, uid: String, name: String?, completion: @escaping (Bool) -> ()) {
        
        guard let name = name else { return }
        
        let document = [
            
            "name": name,
            "email": email,
            "profileImageUrl": profileImageUrl,
            "uid": uid,
            "createdAt": Timestamp()
            
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).setData(document) { (err) in
            
            if let err = err {
                print("ユーザー情報のFirestoreへの保存に失敗。: ", err)
                return
            }
            
            completion(true)
            print("ユーザー情報のFirestoreへの保存に成功。")
            
        }
    }
    
    static func fetchUserFromFirestore(uid: String, completion: @escaping (User?) -> Void) {
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            
            if let err = err {
                print("ユーザー情報の取得に失敗。: ", err)
                completion(nil)
                return
                
            }
            
            guard let dic = snapshot?.data() else { return }
            let user = User(dic: dic)
            print("ユーザー情報の取得に成功しました")
            completion(user)
            
        }
    }
    
    // Firestoreから自分以外のユーザー情報を取得
    static func fetchUsersFromFirestore(completion: @escaping ([User]) -> Void) {
        
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            
            if let err = err {
                print("ユーザー情報の取得に失敗。: ", err)
                return
            }
            
            let users = snapshots?.documents.map({ (snapshot) -> User in
                let dic = snapshot.data()
                let user = User(dic: dic)
                return user
            })
            
            completion(users ?? [User]())
        }
    }
    
    static func postDataToFirestore(name: String, profileImageUrl: String, postImageUrl: String, storeName: String, recommendPoint: String, place: String, comment: String, uid: String, docId: String, completion: @escaping (Bool) -> ()) {
        
        let document = [
            
            "name": name,
            "profileImageUrl": profileImageUrl,
            "postImageUrl": postImageUrl,
            "storeName": storeName,
            "recommendPoint": recommendPoint,
            "place": place,
            "comment": comment,
            "uid": uid,
            "createdAt": Timestamp(),
            "postDate": Date().timeIntervalSince1970,
            "docId": docId
            
        ] as [String : Any]
        
        Firestore.firestore().collection("post").document(docId).setData(document) { (err) in
            
            if let err = err {
                print("post情報のFirestoreへの保存に失敗。: ", err)
                return
            }
            
            print("post情報のFirestoreへの保存に成功。")
            completion(true)
        }
    }
    
    static func fetchPostsFromFirestore(completion: @escaping ([Post]) -> Void) {
        
        Firestore.firestore().collection("post").getDocuments { (snapshots, err) in
            
            if let err = err {
                print("ユーザー情報の取得に失敗。: ", err)
                return
            }
            
            let posts = snapshots?.documents.map({ (snapshot) -> Post in
                let dic = snapshot.data()
                let post = Post(dic: dic)
                
                return post
            })
            
            completion(posts ?? [Post]())
        }
    }
    
    static func fetchPostFromFirestore(uid: String, completion: @escaping (Post?) -> Void) {
        
        Firestore.firestore().collection("post").order(by: uid).addSnapshotListener { (snapshot, err) in
            
            if let err = err {
                print("ユーザー情報の取得に失敗。: ", err)
                completion(nil)
                return
                
            }
            
            if let snapShotDoc = snapshot?.documents {
                
                for doc in snapShotDoc{
                    
                    let dic = doc.data()
                    let post = Post(dic: dic)
                    print("ユーザー情報の取得に成功しました")
                    completion(post)
                    
                }
            }
        }
    }
    
    static func updateUserInfoToFirestore(profileImageUrl: String, name: String, age: String, residence: String, favorite: String, uid: String) {
        
        let document = [
            
            "profileImageUrl": profileImageUrl,
            "name": name,
            "age": age,
            "residence": residence,
            "favorite": favorite
            
        ]
        
        Firestore.firestore().collection("users").document(uid).updateData(document) { (err) in
            
            if let err = err {
                print("ユーザー情報の更新に失敗", err)
                return
            }
            print("updateに成功")
            
        }
    }
    
    static func fetchProfileFromFirestore(uid: String, completion: @escaping ([User]) -> Void) {
        
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid).getDocuments { (snapshots, err) in
            
            if let err = err {
                print("ユーザー情報の取得に失敗。: ", err)
                return
            }
            
            let users = snapshots?.documents.map({ (snapshot) -> User in
                let dic = snapshot.data()
                let user = User(dic: dic)
                return user
            })
            
            completion(users ?? [User]())
        }
    }
}
