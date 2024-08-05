//
//  BirthdayViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let birthDate: ControlProperty<Date>  //birthDayPicker.rx.date
        let nextButtonTap: ControlEvent<Void> //nextButton.rx.tap
    }
    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let age: BehaviorRelay<Int>
        let isValidAge: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
    }
}

extension BirthdayViewModel {
    func transform(_ input: Input) -> Output {
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let year = BehaviorRelay(value: currentDate.year!)
        let month = BehaviorRelay(value: currentDate.month!)
        let day = BehaviorRelay(value: currentDate.day!)
        let age = BehaviorRelay(value: 0)
        
        input.birthDate
            .bind(with: self) { owner, date in
                let pickerDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
                year.accept(pickerDate.year!)
                month.accept(pickerDate.month!)
                day.accept(pickerDate.day!)
                age.accept(currentDate.year! - pickerDate.year!)
            }.disposed(by: disposeBag)
        
        let isValidAge = age.map { $0 >= 17 }
        
        return Output(year: year, month: month, day: day, 
                      age: age, isValidAge: isValidAge,
                      nextButtonTap: input.nextButtonTap)
    }
    
    func showSwitchVCAlert(to nextVC: UIViewController) {
        let alert = UIAlertController(title: "🥳 가입 완료", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "⬅️", style: .cancel)
        let finish = UIAlertAction(title: "GO!", style: .destructive) { _ in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: nextVC)
            sceneDelegate.window?.makeKeyAndVisible()
        }
        alert.addAction(cancel)
        alert.addAction(finish)
        nextVC.present(alert, animated: true)
    }
}
