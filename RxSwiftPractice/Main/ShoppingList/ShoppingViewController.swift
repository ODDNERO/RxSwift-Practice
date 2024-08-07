//
//  ShoppingViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/3/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ShoppingViewController: UIViewController {
    private let viewModel = ShoppingViewModel()
    private let disposeBag = DisposeBag()
    
    private let contentView = ShoppingView()
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "쇼핑"
        navigationItem.backButtonTitle = ""
        bind()
    }
}

extension ShoppingViewController {
    private func bind() {
        let keywordSelect: ControlEvent<Void> = ControlEvent(events: contentView.shoppingCollectionView.rx.itemSelected.map { _ in () })
        let toggleCompleteRowIndex = PublishRelay<Int>()
        let toggleBookmarkRowIndex = PublishRelay<Int>()
        
        let input = ShoppingViewModel.Input(addContentText: contentView.addTextField.rx.text,
                                            addButtonTap: contentView.addButton.rx.tap,
                                            keywordText: contentView.shoppingCollectionView.rx.modelSelected(String.self),
                                            keywordSelect: keywordSelect,
                                            toggleCompleteRowIndex: toggleCompleteRowIndex,
                                            toggleBookmarkRowIndex: toggleBookmarkRowIndex,
                                            deleteAction: contentView.shoppingTableView.rx.modelDeleted(Shopping.self), 
                                            contentSelect: contentView.shoppingTableView.rx.modelSelected(Shopping.self))
        let output = viewModel.transform(input)
        
        viewModel.recommendationList
            .bind(to: contentView.shoppingCollectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, element, cell) in
                cell.setupKeyword(element)
            }
            .disposed(by: disposeBag)
        
        output.userShoppingList
            .bind(to: contentView.shoppingTableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                cell.setupContentText(element)
                cell.setupButton(element)

                cell.completeButton.rx.tap
                    .map { row }
                    .bind(to: toggleCompleteRowIndex)
                    .disposed(by: cell.disposeBag)
                
                cell.bookmarkButton.rx.tap
                    .map { row }
                    .bind(to: toggleBookmarkRowIndex)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(contentView.addButton.rx.tap, keywordSelect)
            .subscribe(with: self) { owner, text in
                let section = owner.contentView.shoppingTableView.numberOfSections - 1
                let row = owner.contentView.shoppingTableView.numberOfRows(inSection: section) - 1
                owner.contentView.shoppingTableView.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: true)
            }.disposed(by: disposeBag)
        
        output.addButtonTap
            .map { "" }
            .bind(to: contentView.addTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.contentSelect
            .bind(with: self) { owner, shopping in
                let memoVC = MemoViewController(data: shopping)
                owner.navigationController?.pushViewController(memoVC, animated: true)
            }.disposed(by: disposeBag)
    }
}
