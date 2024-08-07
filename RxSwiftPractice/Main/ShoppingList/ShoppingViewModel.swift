//
//  ShoppingViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

struct Shopping: Identifiable {
    let id = UUID()
    var isCompleted: Bool
    var isBookmarked: Bool
    let content: String
    var memo: String
}

final class ShoppingViewModel {
    let recommendationList = BehaviorRelay(value: ["짐색", "버뮤다", "레인부츠", "손풍기", "볼캡", "키보드", "샌들", "텀블러", "모니터", "선크림"].shuffled())
    private var shoppingData = [
        Shopping(isCompleted: false, isBookmarked: true, content: "망곰이 마스킹테이프", memo: "일상망곰"),
        Shopping(isCompleted: true, isBookmarked: false, content: "시리얼 사기", memo: "오!그래놀라 POP 초코아몬드"),
        Shopping(isCompleted: false, isBookmarked: true, content: "브리타 필터 사기", memo: ""),
        Shopping(isCompleted: false, isBookmarked: false, content: "예스24 eBook 구매", memo: "1. 클린 아키텍처 - Robert C. Martin")
    ]
    private lazy var shoppingList = BehaviorRelay(value: shoppingData)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let addContentText: ControlProperty<String?>  //addTextField.rx.text
        let addButtonTap: ControlEvent<Void>          //addButton.rx.tap
        
        let keywordText: ControlEvent<String>         //shoppingCollectionView.rx.modelSelected(String.self)
        let keywordSelect: ControlEvent<Void>         //shoppingCollectionView.rx.itemSelected
        
        let toggleCompleteRowIndex: PublishRelay<Int>
        let toggleBookmarkRowIndex: PublishRelay<Int>
        let deleteAction: ControlEvent<Shopping>      //shoppingTableView.rx.modelDeleted(Shopping.self)
        let contentSelect: ControlEvent<Shopping>     //shoppingTableView.rx.modelSelected(Shopping.self)
    }
    struct Output {
        let userShoppingList: BehaviorRelay<[Shopping]>
        let addButtonTap: ControlEvent<Void>
        let contentSelect: ControlEvent<Shopping>
    }
}

extension ShoppingViewModel {
    func transform(_ input: Input) -> Output {
        searchShopping(input.addContentText)
        
        addShopping(input.addContentText.orEmpty.asObservable(), on: input.addButtonTap)
        addShopping(input.keywordText.asObservable(), on: input.keywordSelect)
        deleteShopping(on: input.deleteAction)
        
        updateCompleteState(at: input.toggleCompleteRowIndex)
        updateBookmarkState(at: input.toggleBookmarkRowIndex)
        
        return Output(userShoppingList: shoppingList,
                      addButtonTap: input.addButtonTap,
                      contentSelect: input.contentSelect)
    }
    
    private func searchShopping(_ text: ControlProperty<String?>) {
        text.orEmpty
            .compactMap { $0.replacingOccurrences(of: " ", with: "") }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                let allData = owner.shoppingData
                let allList = owner.shoppingList.value
                let filteredList = text.isEmpty ? allData : allList.filter {
                    $0.content.replacingOccurrences(of: " ", with: "").localizedCaseInsensitiveContains(text)
                }
                owner.shoppingList.accept(filteredList)
            }.disposed(by: disposeBag)
    }
}

extension ShoppingViewModel {
    private func addShopping(_ text: Observable<String>, on action: ControlEvent<Void>) {
        action.withLatestFrom(text)
            .distinctUntilChanged()
            .compactMap { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, text in
                owner.shoppingData.append(Shopping(isCompleted: false, isBookmarked: false, content: text, memo: ""))
                owner.shoppingList.accept(owner.shoppingData)
            }.disposed(by: disposeBag)
    }
    private func deleteShopping(on action: ControlEvent<Shopping>) {
        action
            .bind(with: self) { owner, item in
                let deleteItem = item
                var currentList = owner.shoppingList.value
                owner.shoppingData.removeAll { $0.id == deleteItem.id }
                currentList.removeAll { $0.id == deleteItem.id }
                owner.shoppingList.accept(currentList)
            }.disposed(by: disposeBag)
    }
    
    private func updateCompleteState(at targetRow: PublishRelay<Int>) {
        targetRow
            .bind(with: self) { owner, row in
                var currentList = owner.shoppingList.value
                let editItem = currentList[row]
                guard let index = owner.shoppingData.firstIndex(where: { $0.id == editItem.id }) else { return }
                owner.shoppingData[index].isCompleted.toggle()
                currentList[row].isCompleted.toggle()
                owner.shoppingList.accept(currentList)
            }.disposed(by: disposeBag)
    }
    private func updateBookmarkState(at targetRow: PublishRelay<Int>) {
        targetRow
            .bind(with: self) { owner, row in
                var currentList = owner.shoppingList.value
                let editItem = currentList[row]
                guard let index = owner.shoppingData.firstIndex(where: { $0.id == editItem.id }) else { return }
                owner.shoppingData[index].isBookmarked.toggle()
                currentList[row].isBookmarked.toggle()
                owner.shoppingList.accept(currentList)
            }.disposed(by: disposeBag)
    }
}
