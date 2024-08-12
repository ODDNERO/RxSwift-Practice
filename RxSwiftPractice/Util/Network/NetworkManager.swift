//
//  NetworkManager.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/8/24.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    //MARK: - Joke
    static let jokeURL = "https://v2.jokeapi.dev/joke/Programming?type=single"
    
    static func requestJoke() -> Observable<Joke> {
        return Observable.create { observer -> Disposable in //AnyObserver<_>
            AF.request(NetworkManager.jokeURL)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    switch response.result {
                    case .success(let joke):
                        observer.onNext(joke)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }.debug("Joke API 통신")
    }
    
    static func requestJokeWithSingle() -> Single<Joke> {
        return Single.create { observer -> Disposable in
            AF.request(NetworkManager.jokeURL)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    switch response.result {
                    case .success(let joke):
                        observer(.success(joke)) //Result 타입
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            return Disposables.create()
        }.debug("Joke API 통신")
    }
    
