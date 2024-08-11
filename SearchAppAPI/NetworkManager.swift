//
//  NetworkManager.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/11/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusCode(Int)  // HTTP 상태 코드
    case decodingError(Error)  // 디코딩 오류
    case networkError(Error)  // 네트워크 오류
    case noData  // 데이터가 없는 경우
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .unknownResponse:
            return "알 수 없는 응답입니다."
        case .statusCode(let code):
            return "HTTP 상태 코드 오류: \(code)"
        case .decodingError(let error):
            return "디코딩 오류: \(error.localizedDescription)"
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .noData:
            return "데이터가 없습니다."
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    func callItunesApp(text: String) -> Observable<AppStoreResponse> {
        guard var urlText = URLComponents(string: "https://itunes.apple.com/search?") else {
            fatalError("Invalid URL string")
        }
        let mediaQuery = URLQueryItem(name: "media", value: "software")
        let termQuery = URLQueryItem(name: "term", value: text)
        let countryQuery = URLQueryItem(name: "country", value: "KR")
        
        urlText.queryItems?.append(contentsOf: [mediaQuery, termQuery, countryQuery])
        let requestUrl = urlText.url

        //url잘못 입력
        let result = Observable<AppStoreResponse>.create { observer in
            guard let url = URL(string: requestUrl?.absoluteString ?? "") else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                //네트워크 연결
                if let error = error {
                    observer.onError(APIError.networkError(error))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                //정상코드 아닐때
                guard (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusCode(response.statusCode))
                    return
                }
                //응답이 왔으나 값이 없을때
                guard let data = data else {
                    observer.onError(APIError.noData)
                    return
                }
                do {
                    let appData = try JSONDecoder().decode(AppStoreResponse.self, from: data)
                    observer.onNext(appData)
                    observer.onCompleted()
                } catch {
                    observer.onError(APIError.decodingError(error))
                }
            }.resume()
            return Disposables.create()
        }//.debug("API 조회")
        return result
    }
}
