//
//  NicknameViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    var disposeBag: DisposeBag { get }
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class NicknameViewModel: BaseViewModel {
    var disposeBag = DisposeBag()

    struct Input {
        let jokeButtonTap: ControlEvent<Void>
    }
    struct Output {
        let joke: Driver<Joke>
    }
}

extension NicknameViewModel {
    func transform(input: Input) -> Output {
        /* MARK: - asSingle() 테스트
        let joke = input.jokeButtonTap
//            .flatMap { NetworkManager.requestJoke() }
            .flatMap { NetworkManager.requestJokeWithSingle() } //Single 객체 사용
//            .asSingle() //Observable 스트림 자체가 Single이 됨
//                        //Single은 next -> complete되기 때문에 dispose됨
//                        //결과적으로 "실패"가 뜨고 버튼 클릭이 더 이상 되지 않음
            .asDriver(onErrorJustReturn: Joke(joke: "실패", id: 0))
            .debug("jokeButtonTap")
         */
        
        //MARK: - 스트림 중간에서 Error 이벤트 발생하더라도 Tap 이벤트 자체가 Dispose되지 않도록 처리 (클릭 안 됨 현상)
        let joke = input.jokeButtonTap
            .flatMap {
                NetworkManager.requestJokeWithSingle() //-> Single<Joke>
                    //안에서 catch도 가능
                    .catch { error in
                        return Single<Joke>.never() 
                        /* 
                         1. MARK: never() = Next/Error/Completed 어떤 이벤트도 방출하지 않음 -> 시퀀스 영원히 지속
                         -> 이벤트 방출 X, 에러 X, 완료 X, 시퀀스 종료 X Single 생성해서 반환
                         -> 이 Single을 구독한 옵저버는 Dispose되지 않고 영원히 대기 상태가 됨 (옵저버블이 이벤트를 방출하지 않기 때문에)
                         결론: error 이벤트를 캐치하면 -> 아무 이벤트도 없는 Single로 반환 => 'error 이벤트'를 'No 이벤트'로 대체
                         */
                    }
            }
            /* 이전 이벤트(네트워크 Observable)에서 error 이벤트가 전달되었을 때 에러 캐치
             .catch { error in
             return Observable.just(Joke(joke: "실패", id: 0))
             2. MARK: error를 캐치하면 새로운 Observable로 반환 -> Dispose되지 않음
             }
             */
            .asDriver(onErrorJustReturn: Joke(joke: "실패", id: 0))
            .debug("jokeButtonTap")
        
        return Output(joke: joke)
    }
}
