//
//  TabelViewModel.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TabelViewModel {
    let screenshotRelay = BehaviorRelay<[String]>(value: [])
    
    func updateScreenshots(with urls: [String]) {
        screenshotRelay.accept(urls)
    }
    
}
