# Ra-menApp  

# 概要  
このアプリの名前は「ラーム」です。ラームでは、ユーザーのお気に入りのラーメンや実際に食べたラーメンの画像、店舗名、場所、おすすめ度、コメントを入力し、投稿できるアプリです。  
まずはプロフィール画像とメールアドレスとパスワードとユーザーネームを入力し、アカウントを作成します。プロフィール画面ではプロフィール情報を編集して保存ができたり、ログアウトができます。これら全てをFirebaseと通信をして実装しています。  
アカウント作成はFireAuth、投稿内容やプロフィール情報はFirestoreとFirestorageを使って保存しています。「探す」という画面では、ボタンを押すとマップアプリを起動して近くのラーメン屋を探すことができます。  
苦労した点は、初めてRxSwiftを使用しアーキテクチャーのMVVMを実装したのでその勉強に苦労しました。ですのでまだまだ改善点はたくさんあると思います。  
完成度は低いですが、精一杯作ったので温かい目で見ていただけると嬉しいです。ちなみにラーメンは大好きです。  
※このアプリはAppStoreには公開していません。

# 開発環境  
Xcode 12.3  
Swift 5.3.2  

# 動作対象端末・OS  
iOS 14.3  

# 使用したライブラリ(PodとSPM）  
pod 'Firebase/Analytics'  
pod 'Firebase/Auth'  
pod 'Firebase/Firestore'  
pod 'Firebase/Storage'  
[Nuke 9.3.1](https://github.com/kean/Nuke)  
[RxSwift 6.1.0](https://github.com/ReactiveX/RxSwift)  
[PKHUD 5.4.0](https://github.com/pkluz/PKHUD)  

# スクリーンショット  
<img src="https://user-images.githubusercontent.com/65600700/117263717-83cffd80-ae8d-11eb-8f31-6cc06048dff1.PNG" width="250px">  <img src="https://user-images.githubusercontent.com/65600700/117263950-b974e680-ae8d-11eb-83c0-a4cbe54af47a.PNG" width="250px"> <img src="https://user-images.githubusercontent.com/65600700/117264075-d6a9b500-ae8d-11eb-8183-dc17dc4c5bd2.PNG" width="250px">

<img src="https://user-images.githubusercontent.com/65600700/117264201-f7720a80-ae8d-11eb-8c0e-13ce41f9c7c6.PNG" width="250px">  <img src="https://user-images.githubusercontent.com/65600700/117264354-1bcde700-ae8e-11eb-8e3a-98c7285d89e0.PNG" width="250px">  <img src="https://user-images.githubusercontent.com/65600700/117264560-4d46b280-ae8e-11eb-8604-1d28950bbca0.PNG" width="250px">  <img src="https://user-images.githubusercontent.com/65600700/117264701-70716200-ae8e-11eb-8bdd-a9263a49e7d0.PNG" width="250px">  <img src="https://user-images.githubusercontent.com/65600700/117264802-8f6ff400-ae8e-11eb-8dcf-c75afa9d0f6a.PNG" width="250px">   <img src="https://user-images.githubusercontent.com/65600700/117264912-ac0c2c00-ae8e-11eb-8e60-760b84bc6af8.PNG" width="250px"> 
