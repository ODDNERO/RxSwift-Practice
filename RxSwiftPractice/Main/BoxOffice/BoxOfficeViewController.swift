//
//  BoxOfficeViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {
    private let viewModel = BoxOfficeViewModel()
    private let disposeBag = DisposeBag()
    
    private let contentView = BoxOfficeView()
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = contentView.movieSearchBar
        bind()
    }
}

extension BoxOfficeViewController {
    /* MARK: - Observable Create Practice
    func createObservable() {
        let random = Observable<Int>.create { observer in //observer: AnyObservable<Int>
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create() //이 연산자를 만들게
        }
        random
            .subscribe(with: self) { owner, num in
                print("random: \(num)")
            }.disposed(by: disposeBag)
    }
    */
    
    func bind() {
        let recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(recentText: recentText,
                                             searchText: contentView.movieSearchBar.rx.text,
                                             searchButtonTap: contentView.movieSearchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input)
        
        output.movieList
            .bind(to: contentView.movieTableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) {
                (row, element, cell) in
                cell.movieNameLabel.text = element.movieNm
                cell.downloadButton.setTitle(element.openDt, for: .normal)
            }.disposed(by: disposeBag)
        
        output.recentList
            .bind(to: contentView.movieCollectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.movieNameLabel.text = element
            }
            .disposed(by: disposeBag)

        //MARK: zip으로 묶기 전
//        contentView.moviewTableView.rx.modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                print("model: \(value)")
//            }.disposed(by: disposeBag)
//        
//        contentView.moviewTableView.rx.itemSelected
//            .subscribe(with: self) { owner, value in
//                print("model: \(value)")
//            }.disposed(by: disposeBag)
        
        //MARK: map 변환 전
//        Observable.zip(contentView.moviewTableView.rx.modelSelected(String.self),
//                       contentView.moviewTableView.rx.itemSelected)
//            .subscribe(with: self) { owner, value in
//                print(value.0, value.1)
//            }.disposed(by: disposeBag)
        
        Observable.zip(
            contentView.movieTableView.rx.modelSelected(DailyBoxOffice.self),
            contentView.movieTableView.rx.itemSelected
        ).debug("MoviewTableView Selected")
        //MoviewTableView Selected -> Event next(("영화 제목", [0, 0]))
            .map { "\($0.0.movieNm)" }
            .subscribe(with: self) { owner, text in
                recentText.onNext(text)
            }.disposed(by: disposeBag)
    }
}
