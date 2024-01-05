//
//  UserDefault.swift
//  Day6-BMI-Calculator
//
//  Created by 원태영 on 1/5/24.
//

import Foundation

struct User {
  @UserDefault var nickname: String
  @UserDefault var height: Int
  @UserDefault var weight: Int
}

// 프로퍼티 래퍼를 통해 중복되는 로직인 저장 / 불러오기를 구현
// UserDefault를 사용하는 값들에 해당 래퍼를 선언하여 구현된 로직을 일괄적으로 재사용
@propertyWrapper
struct UserDefault<T: Any> {
  private let key: Key
  private var defaultValue: T
  
  init(
    key: Key,
    defaultValue: T
  ) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key.name) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key.name)
    }
  }
  
  enum Key: String {
    case nickname
    case height
    case weight
    
    var name: String {
      return self.rawValue
    }
  }
}
