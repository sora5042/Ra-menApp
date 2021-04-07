//
//  PostViewModel.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/04/06.
//

import Foundation
import RxSwift
import RxCocoa

protocol PostViewModelInputs {
    var recommendTextInput: AnyObserver<String> { get }
    var commentTextInput: AnyObserver<String> { get }
    
}

protocol PostViewModelOutputs {
    var recommendTextOutput: PublishSubject<String> { get }
    var commentTextOutput: PublishSubject<String> { get }
    
}

class PostViewModel: PostViewModelInputs, PostViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    
    // MARK: observable
    var recommendTextOutput = PublishSubject<String>()
    var commentTextOutput = PublishSubject<String>()
    var validPostSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: observer
    var recommendTextInput: AnyObserver<String> {
        recommendTextOutput.asObserver()
        
    }
    
    var commentTextInput: AnyObserver<String> {
        commentTextOutput.asObserver()
        
    }
    
    var validPostDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validPostDriver = validPostSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        
        let recommendValid = recommendTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count <= 3
            }
        
        let commentValid = commentTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count <= 140
            }
        
        Observable.combineLatest(recommendValid, commentValid) { $0 && $1 }
            .subscribe { validPostAll in
                
                self.validPostSubject.onNext(validPostAll)
                
            }
            .disposed(by: disposeBag)
    }
}
