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
    
    //MARK: - BoxOffice
    static func requestBoxOffice(date: String) -> Observable<BoxOffice> {
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(BoxOfficeAPI.key)&targetDt=\(date)"
        
        let result = Observable<BoxOffice>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    observer.onError(APIError.unknownResponse) //에러 이벤트 보내기
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError) //에러 이벤트 보내기
                    return
                }
                
                if let data,
                    let appData = try? JSONDecoder().decode(BoxOffice.self, from: data) {
                    print(appData)
                    observer.onNext(appData) //성공해서 응답 data가 있을 때 Next 이벤트로 데이터 보내기
                    observer.onCompleted() //통신 성공 이후 바로 정리(dispose)되도록 complete 이벤트 보내 주기
                    //Next로 보냈기 때문에 계속 방출되니까 onCompleted 처리를 해 주어야 함
                    //Next다음에 Complete 하는 것 == Single
                } else {
                    print("응답 O, 디코딩 실패")
                    observer.onError(APIError.unknownResponse) //에러 이벤트 보내기
                }
            }
            .resume()
    
            return Disposables.create()
        }
            .debug("박스오피스 조회")
        return result
    }
}
