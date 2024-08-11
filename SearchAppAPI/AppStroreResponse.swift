//
//  AppStoreResponse.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/10/24.
//

import Foundation
     
struct AppStoreResponse: Decodable {
    let resultCount: Int
    let results: [App]
}

struct App: Decodable {
    let supportedDevices: [String] //사용가능 디바이스
    let screenshotUrls: [String] //사용 스크린샷
    let sellerName: String
    let releaseNotes: String? //설명
    let artistId: Int
    let artistName: String
    let artworkUrl60: String //앱 이미지
    let genres: [String] //게임.엔터테인먼트
    let releaseDate: String
    let description: String
    let currency: String //원화
    let trackId: Int
    let trackName: String // 제목
    let minimumOsVersion: String //최소버전
    let fileSizeBytes: String //용량
    let formattedPrice: String //가격
    let version: String //버전
}

