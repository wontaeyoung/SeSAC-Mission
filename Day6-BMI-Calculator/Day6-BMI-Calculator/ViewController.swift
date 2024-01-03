//
//  ViewController.swift
//  Day6-BMI-Calculator
//
//  Created by 원태영 on 1/3/24.
//

import UIKit

final class ViewController: UIViewController {
  // MARK: - Custom Type
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
    case secure
  }
  
  // MARK: - IBOutlet
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  
  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  
  @IBOutlet weak var heightField: UITextField!
  @IBOutlet weak var weightField: UITextField!
  
  @IBOutlet weak var randomBMIButton: UIButton!
  @IBOutlet weak var resultButton: UIButton!
  @IBOutlet weak var secureToggleButton: UIButton!
  
  // MARK: - Property
  private var isSecure: Bool = false
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  @IBAction func inputChanged(_ sender: UITextField) {
    guard
      let height = heightField.text,
      let weight = weightField.text
    else {
      print("텍스트를 찾을 수 없습니다.")
      return
    }
    
    let isValid: Bool = checkValidation(text: height, target: .height)
    && checkValidation(text: weight, target: .weight)
    
    changeResultButtonEnabled(isValid: isValid)
  }
  
  @IBAction func secureToggleTapped(_ sender: UIButton) {
    isSecure.toggle()
    weightField.isSecureTextEntry = isSecure
    changeSecureToggleImage()
  }
}

// MARK: - Set UI
extension ViewController {
  private func configureUI() {
    setLabel(titleLabel, text: Constant.titleText, style: .title)
    setLabel(descriptionLabel, text: Constant.descText, style: .desc)
    setLabel(heightLabel, text: Constant.heightText, style: .body)
    setLabel(weightLabel, text: Constant.weightText, style: .body)
    
    setButton(randomBMIButton, text: Constant.randomCalculateText, style: .random)
    setButton(resultButton, text: Constant.checkResultText, style: .result)
    setButton(secureToggleButton, text: Constant.secureOnSymbol, style: .secure)
    
    setImageView(logoImageView)
    
    setTextField(heightField)
    setTextField(weightField)
    weightField.tag = 1
  }
  
  private func setLabel(
    _ label: UILabel,
    text: String,
    style: LabelStyle
  ) {
    label.text = text
    
    switch style {
      case .title:
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        
      case .desc:
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = .zero
        
      case .body:
        label.font = .systemFont(ofSize: 14)
    }
  }
  
  private func setButton(
    _ button: UIButton,
    text: String,
    style: ButtonStyle
  ) {
    switch style {
      case .random:
        button.setTitle(text, for: .normal)
        button.setTitleColor(.randomButtonTitle, for: .normal)
        button.titleLabel?.textAlignment = .right
        
      case .result:
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.isEnabled = false
        
      case .secure:
        let imageFont: UIFont = .systemFont(ofSize: 12)
        let config: UIImage.SymbolConfiguration = .init(font: imageFont)
        button.setImage(
          .init(systemName: text, withConfiguration: config),
          for: .normal
        )
        button.tintColor = .gray
    }
  }
  
  private func setImageView(_ imageView: UIImageView) {
    imageView.image = .logo
    imageView.contentMode = .scaleAspectFit
  }
  
  private func setTextField(_ field: UITextField) {
    field.keyboardType = .numberPad
    field.autocorrectionType = .no
    field.autocapitalizationType = .none
    field.layer.cornerRadius = 10
    field.layer.borderColor = UIColor.gray.cgColor
    field.layer.borderWidth = 2
  }
  
  private func changeResultButtonEnabled(isValid: Bool) {
    if isValid {
      resultButton.backgroundColor = .resultButtonBackground
      resultButton.isEnabled = true
    } else {
      resultButton.backgroundColor = .gray
      resultButton.isEnabled = false
    }
  }
  
  private func changeSecureToggleImage() {
    let symbol: String = isSecure
    ? Constant.secureOffSymbol
    : Constant.secureOnSymbol
    
    let image: UIImage? = .init(systemName: symbol)
    
    secureToggleButton.setImage(image, for: .normal)
  }
}

// MARK: - Logic
extension ViewController {
  private func checkValidation(
    text: String,
    target: ValidationCase
  ) -> Bool {
    guard
      text.contains(" ") == false,
      let number = Int(text),
      target.validRange.contains(number)
    else {
      return false
    }
    
    return true
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
  
  static let secureOnSymbol: String = "eye.slash.fill"
  static let secureOffSymbol: String = "eye.fill"
}
