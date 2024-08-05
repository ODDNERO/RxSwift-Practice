//
//  EmailViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String?> //emailTextField.rx.text
        let nextButtonTap: ControlEvent<Void>   //nextButton.rx.tap
    }
    struct Output {
        let isValidEmail: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
    }
}

extension EmailViewModel {
    func transform(_ input: Input) -> Output {
        let isValidEmail = input.emailText.orEmpty
            .map { $0.count >= 4 }
        
        return Output(isValidEmail: isValidEmail, nextButtonTap: input.nextButtonTap)
    }
}
