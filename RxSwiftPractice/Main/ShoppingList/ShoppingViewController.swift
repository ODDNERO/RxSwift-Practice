//
//  ShoppingViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/3/24.
//

import UIKit
import RxSwift
import RxCocoa

/* MARK: 뷰모델 파일로 이동
struct Shopping: Identifiable {
    let id = UUID()
    var isCompleted: Bool
    var isBookmarked: Bool
    let content: String
    var memo: String
}
 */

final class ShoppingViewController: UIViewController {
    private let viewModel = ShoppingViewModel()
    
    /* MARK: 뷰모델로 이동
    private var data = [
        Shopping(isCompleted: false, isBookmarked: true, content: "망곰이 마스킹테이프", memo: "일상망곰"),
        Shopping(isCompleted: true, isBookmarked: false, content: "시리얼 사기", memo: "오!그래놀라 POP 초코아몬드"),
        Shopping(isCompleted: false, isBookmarked: true, content: "브리타 필터 사기", memo: ""),
        Shopping(isCompleted: false, isBookmarked: false, content: "예스24 eBook 구매", memo: "1. 클린 아키텍처 - Robert C. Martin")
    ]
    private lazy var shoppingList = BehaviorSubject(value: data)
     */
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
        let toggleCompleteRowIndex = PublishRelay<Int>()
        let toggleBookmarkRowIndex = PublishRelay<Int>()
        
        let input = ShoppingViewModel.Input(addContentText: contentView.addTextField.rx.text,
                                            addButtonTap: contentView.addButton.rx.tap, 
                                            deleteAction: contentView.shoppingTableView.rx.itemDeleted, 
                                            toggleCompleteRowIndex: toggleCompleteRowIndex,
                                            toggleBookmarkRowIndex: toggleBookmarkRowIndex,
                                            contentSelect: contentView.shoppingTableView.rx.modelSelected(Shopping.self))
        let output = viewModel.transform(input)
        
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
                
                /* MARK: 뷰모델로 이동
                //EDIT
                 cell.completeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var currentList = try! owner.shoppingList.value()
                        var editItem = currentList[row]
                        guard let index = owner.data.firstIndex(where: { $0.id == editItem.id }) else { return }
                        owner.data[index].isCompleted.toggle()
                        currentList[row].isCompleted.toggle()
                        owner.shoppingList.onNext(currentList)
                    }.disposed(by: cell.disposeBag)

                cell.bookmarkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var currentList = try! owner.shoppingList.value()
                        let editItem = currentList[row]
                        guard let index = owner.data.firstIndex(where: { $0.id == editItem.id }) else { return }
                        owner.data[index].isBookmarked.toggle()
                        currentList[row].isBookmarked.toggle()
                        owner.shoppingList.onNext(currentList)
                    }.disposed(by: cell.disposeBag)
                 */
            }
            .disposed(by: disposeBag)
        
        output.addButtonTap
            .bind(with: self) { owner, _ in
                owner.contentView.addTextField.text = .none
            }.disposed(by: disposeBag)
        
        output.contentSelect
            .bind(with: self) { owner, shopping in
                let memoVC = MemoViewController(data: shopping)
                owner.navigationController?.pushViewController(memoVC, animated: true)
            }.disposed(by: disposeBag)
        
        /*  MARK: 뷰모델로 이동
        //ADD
        contentView.addButton.rx.tap
            .withLatestFrom(contentView.addTextField.rx.text.orEmpty)
            .filter { !($0.isEmpty) && ($0 != " ") }
            .bind(with: self) { owner, text in
                owner.data.append(Shopping(isCompleted: false, isBookmarked: false, content: text, memo: ""))
                owner.shoppingList.onNext(owner.data)
                owner.contentView.addTextField.text = .none
            }.disposed(by: disposeBag)
        
        //DELETED
        contentView.shoppingTableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                var currentList = try! owner.shoppingList.value()
                let deleteItem = currentList[indexPath.row]
                owner.data.removeAll { $0.id == deleteItem.id }
                currentList.removeAll { $0.id == deleteItem.id }
                owner.shoppingList.onNext(currentList)
            }
            .disposed(by: disposeBag)
        
        //SEARCH
        contentView.addTextField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                print("실시간 검색어: \(text)")
                let allData = owner.data
                let allList = try! owner.shoppingList.value()
                let filteredList = text.isEmpty ? allData : allList.filter { $0.content.localizedCaseInsensitiveContains(text) }
                owner.shoppingList.onNext(filteredList)
            }
            .disposed(by: disposeBag)
         */
    }
}
