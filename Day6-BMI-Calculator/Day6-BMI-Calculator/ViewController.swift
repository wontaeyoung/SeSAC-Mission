//
//  ViewController.swift
//  Day6-BMI-Calculator
//
//  Created by 원태영 on 1/3/24.
//

import UIKit

final class ViewController: UIViewController {
  struct BMI {
    let height: Int
    let weight: Int
    let result: BMIResult
    let date: Date
    
    func calculate() -> Int {
      return weight / height * height
    }
  }
  
  enum BMIResult {
    case 저체중
    case 건강
    case 과체중
    case 비만
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
}

