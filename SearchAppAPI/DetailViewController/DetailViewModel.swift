//
//  DetailViewModel.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {
    private let appDataSubject = BehaviorSubject<[App]>(value: [])
    var appData: Observable<[App]> {
        return appDataSubject.asObservable()
    }
    
    private let screenshotsSubject = BehaviorSubject<[String]>(value: [])
    var screenshots: Observable<[String]> {
        return screenshotsSubject.asObservable()
    }
    
    func updateAppData(data: [App]) {
        appDataSubject.onNext(data)
        if let image = data.first {
            screenshotsSubject.onNext(image.screenshotUrls)
        }
    }
}
