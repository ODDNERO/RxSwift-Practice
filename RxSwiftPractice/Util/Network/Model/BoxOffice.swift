//
//  BoxOffice.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/8/24.
//

import Foundation

struct BoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Decodable {
    let movieNm: String
    let openDt: String
}
