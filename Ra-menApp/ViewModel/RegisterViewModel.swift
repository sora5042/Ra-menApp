//
//  RegisterViewModel.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/16.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegisterViewModelInputs {
    var nameTextInput: AnyObserver<String> { get }
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}

protocol RegisterViewModelOutputs {
    var nameTextOutput: PublishSubject<String> { get }
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}

class RegisterViewModel: RegisterViewModelInputs, RegisterViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    
    // MARK: observable
    var nameTextOutput = PublishSubject<String>()
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: observer
    var nameTextInput: AnyObserver<String> {
        nameTextOutput.asObserver()
        
    }
    
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
        
    }
    
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
        
    }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let nameValid =  nameTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 1
            }
       
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
        
        Observable.combineLatest(nameValid, emailValid, passwordValid) { $0 && $1 && $2}
            .subscribe { validAll in
                self.validRegisterSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
    }
}
