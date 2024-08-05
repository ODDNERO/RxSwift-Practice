//
//  PasswordViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let passwordText: ControlProperty<String?> //passwordTextField.rx.text
        let nextButtonTap : ControlEvent<Void>     //nextButton.rx.tap
    }
    struct Output {
        let nextButtonText: BehaviorRelay<String>
        let isValidPassword: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
    }
}

extension PasswordViewModel {
    func transform(_ input: Input) -> Output {
        let isValidPassword = input.passwordText.orEmpty
            .map { $0.count >= 8 }
        
        let nextButtonText = BehaviorRelay(value: "8자리 이상 입력")
        isValidPassword.bind { value in
            let guide = value ? "다음" : "8자리 이상 입력"
            nextButtonText.accept(guide)
        }.disposed(by: disposeBag)
        
        return Output(nextButtonText: nextButtonText, isValidPassword: isValidPassword,
                      nextButtonTap: input.nextButtonTap)
    }
}
