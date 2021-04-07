//
//  LoginViewModel.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/04/06.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInputs {
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}

protocol LoginViewModelOutputs {
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}

class LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    
    // MARK: observable
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    var validLoginSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: observer
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
        
    }
    
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
        
    }
    
    var validLoginDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validLoginDriver = validLoginSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
       
        let emailValid = emailTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 5
            }
       
        let passwordValid = passwordTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 8
            }
        
        Observable.combineLatest(emailValid, passwordValid) { $0 && $1}
            .subscribe { validLoginAll in
                
                self.validLoginSubject.onNext(validLoginAll)
                
            }
            .disposed(by: disposeBag)
    }
}
