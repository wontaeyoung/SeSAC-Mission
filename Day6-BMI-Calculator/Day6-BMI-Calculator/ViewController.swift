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
  
  enum ValidationCase {
    case height
    case weight
    
    var validRange: ClosedRange<Int> {
      switch self {
        case .height:
          return 100...250
          
        case .weight:
          return 30...200
      }
    }
  }
  
  enum BMIResult {
    case 저체중
    case 건강
    case 과체중
    case 비만
  }
  
  enum LabelStyle {
    case title
    case desc
    case body
  }
  
  enum ButtonStyle {
    case random
    case result
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  
  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  
  @IBOutlet weak var heightField: UITextField!
  @IBOutlet weak var weightField: UITextField!
  
  @IBOutlet weak var randomBMIButton: UIButton!
  @IBOutlet weak var resultButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
    
}

// MARK: - Set UI
extension ViewController {
  private func configureUI() {
    setLabel(titleLabel, text: Constant.titleText, style: .title)
    setLabel(descriptionLabel, text: Constant.descText, style: .desc)
    setLabel(heightLabel, text: Constant.heightText, style: .body)
    setLabel(weightLabel, text: Constant.weightText, style: .body)
  }
  
  private func setLabel(
    _ label: UILabel,
    text: String,
    style: LabelStyle
  ) {
    label.text = text
    
    switch style {
      case .title:
        label.font = .boldSystemFont(ofSize: 24)
        
      case .desc:
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = .zero
        
      case .body:
        label.font = .systemFont(ofSize: 14)
    }
  }
}

enum Constant {
  static let titleText: String = "BMI Calculator"
  static let descText: String = "당신의 BMI 지수를 알려드릴게요."
  static let heightText: String = "키가 어떻게 되시나요?"
  static let weightText: String = "몸무게는 어떻게 되시나요?"
  static let randomCalculateText: String =
  "랜덤으로 BMI 계산하기"
  static let checkResultText: String = "결과 확인"
}
