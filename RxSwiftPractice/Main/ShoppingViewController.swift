//
//  ShoppingViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/3/24.
//

import UIKit
import RxSwift
import RxCocoa

struct Shopping {
    var isCompleted: Bool
    var isBookmarked: Bool
    let content: String
    let memo: String
}

final class ShoppingViewController: UIViewController {
    private var data = [
        Shopping(isCompleted: false, isBookmarked: true, content: "망곰이 마스킹테이프", memo: "일상망곰"),
        Shopping(isCompleted: true, isBookmarked: false, content: "시리얼 사기", memo: "오!그래놀라 POP 초코아몬드"),
        Shopping(isCompleted: false, isBookmarked: true, content: "브리타 필터 사기", memo: ""),
        Shopping(isCompleted: false, isBookmarked: false, content: "예스24 eBook 구매", memo: "1. 클린 아키텍처 - Robert C. Martin")
    ]
    private lazy var shoppingList = BehaviorSubject(value: data)
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
    func bind() {
        shoppingList
            .bind(to: contentView.shoppingTableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                cell.setupContentText(element)
                cell.setupButton(element)
                
                //EDIT
                cell.completeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var list = try! owner.shoppingList.value()
                        list[row].isCompleted.toggle()
                        owner.shoppingList.onNext(list)
                    }.disposed(by: cell.disposeBag)
                
                cell.bookmarkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var list = try! owner.shoppingList.value()
                        list[row].isBookmarked.toggle()
                        owner.shoppingList.onNext(list)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        //ADD
        contentView.addButton.rx.tap
            .withLatestFrom(contentView.addTextField.rx.text.orEmpty)
            .filter { !($0.isEmpty) && ($0 != " ") }
            .bind(with: self) { owner, text in
                owner.data.append(Shopping(isCompleted: false, isBookmarked: false, content: text, memo: ""))
                owner.shoppingList.onNext(owner.data)
                owner.contentView.addTextField.text = .none
            }
            .disposed(by: disposeBag)
        
        //DELETED
        contentView.shoppingTableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                var list = try! owner.shoppingList.value()
                list.remove(at: indexPath.row)
                owner.shoppingList.onNext(list)
            }
            .disposed(by: disposeBag)
        
        //SEARCH
        contentView.addTextField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                print("실시간 검색어: \(text)")
                let allData = owner.data
                let allList = try! owner.shoppingList.value()
                let filteredList = text.isEmpty ? allData : allList.filter { $0.content.localizedCaseInsensitiveContains(text) }
                owner.shoppingList.onNext(filteredList)
            }
            .disposed(by: disposeBag)
        
        //PUSH VC
        contentView.shoppingTableView.rx.modelSelected(Shopping.self)
            .bind(with: self) { owner, shopping in
                let memoVC = MemoViewController(data: shopping)
                owner.navigationController?.pushViewController(memoVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
