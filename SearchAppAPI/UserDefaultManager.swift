//
//  UserDefaultManager.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/11/24.
//

import Foundation

final class UserDefaultManager {
    private enum UserDefaultKeys {
        static let recentList = "recentList"
    }
    
//    static var profileImage: String {
//        get {
//            return UserDefaults.standard.string(forKey: UserDefaultKeys.profileImage) ?? ""
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.profileImage)
//        }
//    }
    static var recentList: [String] {
        get {
            return UserDefaults.standard.array(forKey: UserDefaultKeys.recentList) as? [String] ?? []
        }
        set {
            var updatedList = newValue
            if updatedList.count > 10 {
                updatedList = Array(updatedList.prefix(10))
            }
            UserDefaults.standard.set(updatedList, forKey: UserDefaultKeys.recentList)
        }
    }
}
