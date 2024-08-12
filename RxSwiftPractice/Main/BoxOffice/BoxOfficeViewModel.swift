//
//  BoxOfficeViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel {
    private var recentList = [String]()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let recentText: PublishSubject<String> //테이블뷰 셀 클릭 시 들어오는 글자 -> 컬렉션뷰에 업데이트
        let searchText: ControlProperty<String?>
        let searchButtonTap: ControlEvent<Void>
    }
    struct Output {
        let movieList: PublishSubject<[DailyBoxOffice]>
        let recentList: Observable<[String]>
    }
}

extension BoxOfficeViewModel {
    func transform(_ input: Input) -> Output {
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOffice]>()
    
        input.recentText
            .subscribe(with: self) { owner, text in
                print("BoxOfficeViewModel Transform:", text)
                owner.recentList.append(text)
                recentList.onNext(owner.recentList)
            }.disposed(by: disposeBag)
        
        input.searchButtonTap //서치바 엔터 -> 네트워크 통신 진행
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { dateText in
                guard let intText = Int(dateText) else { return 20240807 }
                return intText
            }
            .map { "\($0)" } //다시 string으로 == "\(dateText)"
            .flatMap { dateText in //map => Observable<BoxOffice> | flatMap => BoxOffice
                
                /* MARK: - BoxOffice API -> Observable 타입 반환
                return NetworkManager.requestBoxOffice(date: dateText) //-> Observable<BoxOffice>
                    .catch { error in
                        return Observable<BoxOffice>.never()
                    }
                 */
                
                //MARK: - BoxOffice API -> Single 타입 반환
                return NetworkManager.requestBoxOfficeWithSingle(date: dateText)
                    .catch { error in
                        return Single<BoxOffice>.never()
                    }
            }
            .subscribe(with: self) { owner, boxOffice in
                print(boxOffice.boxOfficeResult.dailyBoxOfficeList)
                print("Next: \(boxOffice)")
                boxOfficeList.onNext(boxOffice.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("Error: \(error)")
            } onCompleted: { owner in
                print("Completed")
            } onDisposed: { owner in
                print("Disposed")
            }.disposed(by: disposeBag)
        
        return Output(movieList: boxOfficeList,
                      recentList: recentList)
    }
}
