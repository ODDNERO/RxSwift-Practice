//
//  BirthdayViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/1/24.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    let current = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    lazy var year = BehaviorRelay(value: current.year!)
    lazy var month = BehaviorRelay(value: current.month!)
    lazy var day = BehaviorRelay(value: current.day!)
    let age = BehaviorRelay(value: 0)
    let disposeBag = DisposeBag()
    
    let descriptionLabel = UILabel()
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let nextButton = PointButton(title: "가입하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
}

extension BirthdayViewController {
    func bindDate(_ owner: BirthdayViewController, _ date: ControlProperty<Date>.Element) {
        let pickerDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
        owner.year.accept(pickerDate.year!)
        owner.month.accept(pickerDate.month!)
        owner.day.accept(pickerDate.day!)
        owner.age.accept(current.year! - pickerDate.year!)
    }
    
    func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                owner.bindDate(owner, date)
            }
            .disposed(by: disposeBag)
        
        let isValid = age.map { $0 >= 17 }
        isValid
            .bind(with: self) { owner, value in
                owner.descriptionLabel.text = value ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다."
                owner.descriptionLabel.textColor = value ? .blue : .red
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showSwitchVCAlert(to: SearchViewController())
            }
            .disposed(by: disposeBag)
        
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
 
extension BirthdayViewController {
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
        present(alert, animated: true)
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        [descriptionLabel, containerStackView, birthDayPicker, nextButton].forEach { view.addSubview($0) }
        [yearLabel, monthLabel, dayLabel].forEach { containerStackView.addArrangedSubview($0) }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
