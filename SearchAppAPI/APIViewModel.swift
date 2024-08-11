//
//  APIViewModel.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class APIViewModel {
    let disposeBag = DisposeBag()
    lazy var recentList: [String] = UserDefaultManager.recentList //최근 검색어 담을 배열
    let screenshotRelay = BehaviorRelay<[String]>(value: [])
    
    struct Input{
        let previousSearchText: PublishSubject<String> // 테이블뷰 누르면 최근검색어 추가, 클릭한 테이블뷰의 글자
        let searchText: ControlProperty<String> // searchBar.rx.text.orEmpty
        let searchButtonTap: ControlEvent<Void> // searchBar.rx.searchButtonClicked
    }
    struct Output{
        let appList: Observable<[App]> //테이블뷰에 들어올 데이터
        let recentList: BehaviorSubject<[String]> //컬렉션뷰 리스트에 추가
    }
    func updateScreenshots(with urls: [String]) {
        screenshotRelay.accept(urls)
    }
    func transform(input: Input) -> Output {
        let recentListSubject = BehaviorSubject(value: recentList)
        let appList = PublishSubject<[App]>()
        
        input.previousSearchText
            .subscribe(with: self) { owner, value in
                var recentList = UserDefaultManager.recentList
                print("이전 검색어 리스트: \(recentList)")
                recentList.insert(value, at: 0)
                if recentList.count > 10 {
                    recentList = Array(recentList.prefix(10))
                }
                UserDefaultManager.recentList = recentList
                print("업데이트된 검색어 리스트: \(recentList)")
                recentListSubject.onNext(recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .debug("체크1")
            .distinctUntilChanged() // 동일한 글자는 중복으로 통신하지 않음
            .flatMap { value -> Observable<AppStoreResponse> in
                NetworkManager.shared.callItunesApp(text: value)
            }
            //.debug("체크2")
            .subscribe(with: self, onNext: { owner, value in
                appList.onNext(value.results)
            }, onError: { owner, error in
                print("onError")
            }, onCompleted: { _ in
                print("onCompleted")
            }, onDisposed: { _ in
                print("onDisposed")
            })
            .disposed(by: disposeBag)

        return Output(appList: appList, recentList: recentListSubject)
    }
}
