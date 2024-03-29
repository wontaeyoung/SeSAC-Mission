//
//  ViewController.swift
//  Day6-BMI-Calculator
//
//  Created by 원태영 on 1/3/24.
//

import UIKit

extension UIViewController {
  // MARK: - Custom Type
  enum ValidationTarget {
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
  
  enum BMI: String {
    case 저체중
    case 정상
    case 과체중
    case 비만
    case 검사불가
    
    static func checkBMI(bmi: Int) -> Self {
      switch bmi {
        case ...185:
          return .저체중
          
        case 185...250:
          return .정상
          
        case 250...300:
          return .과체중
          
        case 300...:
          return .비만
          
        default:
          return .검사불가
      }
    }
  }
  
  enum TextFieldTag: Int {
    case height
    case weight
    
    var tag: Int {
      return self.rawValue
    }
  }
  
  enum BMIError: Error {
    case optionalBindingFailed
    case textUnfindable
    case getRandomNumberFailed
    case noHistory
    
    var errorDescription: String {
      switch self {
        case .optionalBindingFailed:
          return "옵셔널 바인딩에 실패했습니다."
          
        case .textUnfindable:
          return "텍스트를 찾지 못했습니다."
          
        case .getRandomNumberFailed:
          return "랜덤 숫자 획득에 실패했습니다."
          
        case .noHistory:
          return "검사 기록이 저장되어있지 않습니다."
      }
    }
  }
  
  enum LabelStyle {
    case title
    case desc
    case inputValidInfo
    case body
  }
  
  enum ButtonStyle {
    case random
    case result
    case secure
  }
  
}

final class ViewController: UIViewController {
  // MARK: - IBOutlet
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  
  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  
  @IBOutlet weak var heightInputInfoLabel: UILabel!
  @IBOutlet weak var weightInputInfoLabel: UILabel!
  
  @IBOutlet weak var heightField: UITextField!
  @IBOutlet weak var weightField: UITextField!
  
  @IBOutlet weak var randomBMIButton: UIButton!
  @IBOutlet weak var resultButton: UIButton!
  @IBOutlet weak var secureToggleButton: UIButton!
  
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var nicknameField: UITextField!
  
  @IBOutlet weak var historyLabel: UILabel!
  @IBOutlet weak var historyValueLabel: UILabel!
  
  @IBOutlet weak var resetButton: UIButton!
  
  // MARK: - Property
  private var isSecure: Bool = false
  private var user = User() {
    didSet {
      changeHistoryLabel()
    }
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    changeHistoryLabel()
  }
  
  // MARK: - IBAction
  @IBAction func inputChanged(_ sender: UITextField) {
    guard
      let height = heightField.text,
      let weight = weightField.text
    else {
      showLog(error: .textUnfindable)
      return
    }
    
    let isHeightValid: Bool = checkValidation(text: height, target: .height)
    let isWeightValid: Bool = checkValidation(text: weight, target: .weight)
    
    changeInputInfoLabel(
      isValid: isHeightValid,
      target: .height,
      isEmpty: height.isEmpty
    )
    
    changeInputInfoLabel(
      isValid: isWeightValid,
      target: .weight,
      isEmpty: weight.isEmpty
    )
    
    changeResultButtonEnabled(isValid: isHeightValid && isWeightValid)
  }
  
  @IBAction func secureToggleTapped(_ sender: UIButton) {
    isSecure.toggle()
    weightField.isSecureTextEntry = isSecure
    changeSecureToggleImage()
  }
  
  @IBAction func randomButtonTapped(_ sender: UIButton) {
    guard
      let randomHeight = ValidationTarget.height.validRange.randomElement(),
      let randomWeight = ValidationTarget.weight.validRange.randomElement()
    else {
      showLog(error: .getRandomNumberFailed)
      return
    }
    
    heightField.text = randomHeight.description
    weightField.text = randomWeight.description
    self.inputChanged(UITextField())
  }
  
  @IBAction func resultButtonTapped(_ sender: UIButton) {
    guard
      let nickname = nicknameField.text,
      let heightText = heightField.text,
      let weightText = weightField.text,
      let height = Int(heightText),
      let weight = Int(weightText)
    else {
      showLog(error: .optionalBindingFailed)
      return
    }
    
    let bmi: Int = calculate(height: height, weight: weight)
    let result: BMI = .checkBMI(bmi: bmi)
    
    showAlert(bmi: result)
    save(nickname: nickname, height: height, weight: weight)
  }
  
  @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func nicknameFieldReturned(_ sender: UITextField) {
    guard let nickname = nicknameField.text else {
      showLog(error: .optionalBindingFailed)
      return
    }
    
    user.nickname = nickname
  }
  
  @IBAction func nicknameInputChanged(_ sender: UITextField) {
    guard let text = sender.text else {
      showLog(error: .textUnfindable)
      return
    }
    
    descriptionLabel.text = text + "의 BMI 지수를 알려드릴게요."
  }
  
  @IBAction func resetButtonTapped(_ sender: UIButton) {
    user.removeHistory()
    historyValueLabel.text = " "
  }
  
  // MARK: - Method
  private func showAlert(bmi: BMI) {
    let alert = UIAlertController(
      title: "검사 결과",
      message: #"\#(user.nickname)의 BMI 검사 결과는 '\#(bmi.rawValue)' 입니다!"#,
      preferredStyle: .alert
    )
    
    // 타입 어노테이션 vs 타입 추론 컴파일 시점 성능 차이
    let action = UIAlertAction(title: "확인", style: .default)
    
    alert.addAction(action)
    
    present(alert, animated: true)
  }
  
  private func showLog(function: String = #function, error: BMIError) {
    print(function, error.errorDescription)
  }
  
  @objc private func moveToPreFieldButtonTapped() {
    heightField.becomeFirstResponder()
  }
  
  @objc private func moveToNextFieldButtonTapped() {
    weightField.becomeFirstResponder()
  }
  
  @objc private func hideKeyboardBarButtonTapped() {
    view.endEditing(true)
  }
}

// MARK: - Set UI
extension ViewController {
  private func configureUI() {
    setLabel(titleLabel, text: Constant.titleText, style: .title)
    setLabel(descriptionLabel, text: user.nickname + Constant.descText, style: .desc)
    setLabel(heightLabel, text: Constant.heightText, style: .body)
    setLabel(weightLabel, text: Constant.weightText, style: .body)
    setLabel(heightInputInfoLabel, text: Constant.heightInvalidText, style: .inputValidInfo)
    setLabel(weightInputInfoLabel, text: Constant.weightInvalidText, style: .inputValidInfo)
    
    setButton(randomBMIButton, text: Constant.randomCalculateText, style: .random)
    setButton(resultButton, text: Constant.checkResultText, style: .result)
    setButton(secureToggleButton, text: Constant.secureOnSymbol, style: .secure)
    
    setImageView(logoImageView)
    
    setTextField(heightField)
    setTextField(weightField)
    
    setLabel(nicknameLabel, text: Constant.nicknameText, style: .body)
    setTextField(nicknameField)
    
    setLabel(historyLabel, text: Constant.historyText, style: .body)
    setButton(resetButton, text: Constant.resetText, style: .random)
    
    heightField.tag = TextFieldTag.height.tag
    weightField.tag = TextFieldTag.weight.tag
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
        label.numberOfLines = 2
        
      case .body:
        label.font = .systemFont(ofSize: 14)
        
      case .inputValidInfo:
        label.font = .systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true
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
        let config = UIImage.SymbolConfiguration(font: imageFont)
        button.setImage(
          UIImage(systemName: text, withConfiguration: config),
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
    injectHideKeyboardToolbar(field)
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
    
    let image = UIImage(systemName: symbol)
    
    secureToggleButton.setImage(image, for: .normal)
  }
  
  private func changeInputInfoLabel(
    isValid: Bool,
    target: ValidationTarget,
    isEmpty: Bool
  ) {
    switch target {
      case .height:
        guard !isEmpty else {
          heightInputInfoLabel.isHidden = true
          return
        }
        
        heightInputInfoLabel.isHidden = isValid
        
      case .weight:
        guard !isEmpty else {
          weightInputInfoLabel.isHidden = true
          return
        }
        
        weightInputInfoLabel.isHidden = isValid
    }
  }
  
  private func changeHistoryLabel() {
    print(user.height)
    let historyText: String = user.height > .zero ? "\(user.nickname): \(user.height)cm x \(user.weight)kg" : " "
    historyValueLabel.text = historyText
  }
  
  private func injectHideKeyboardToolbar(_ field: UITextField) {
    let toolbar = UIToolbar()
    
    let flexibleSpace = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    
    let moveFieldBarButton: UIBarButtonItem = getMoveFieldBarButton(field)
    
    let hideKeyboardBarButton = UIBarButtonItem(
      image: UIImage(systemName: Constant.hideKeyboard)?.colored(with: .black),
      style: .plain,
      target: self,
      action: #selector(hideKeyboardBarButtonTapped)
    )
    
    let toolbarItems: [UIBarButtonItem] 
    
    switch field {
      case heightField:
        toolbarItems = [flexibleSpace, moveFieldBarButton]
        
      case weightField:
        toolbarItems = [moveFieldBarButton, flexibleSpace, hideKeyboardBarButton]
        
      default:
        toolbarItems = [flexibleSpace, hideKeyboardBarButton]
    }
    
    toolbar.sizeToFit()
    toolbar.setItems(toolbarItems, animated: true)
    
    field.inputAccessoryView = toolbar
  }
  
  private func getMoveFieldBarButton(_ field: UITextField) -> UIBarButtonItem {
    if field == heightField {
      return UIBarButtonItem(
        image: UIImage(systemName: Constant.nextField)?.colored(with: .black),
        style: .plain,
        target: self,
        action: #selector(moveToNextFieldButtonTapped)
      )
    } else {
      return UIBarButtonItem(
        image: UIImage(systemName: Constant.previousField)?.colored(with: .black),
        style: .plain,
        target: self,
        action: #selector(moveToPreFieldButtonTapped)
      )
    }
  }
}

// MARK: - Logic
extension ViewController {
  private func checkValidation(
    text: String,
    target: ValidationTarget
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
  
  private func calculate(height: Int, weight: Int) -> Int {
    let height: Double = Double(height) / 100
    let weight: Double = Double(weight)
    let calculated: Double = weight / (height * height)
    
    return Int(calculated) * 10
  }
  
  private func save(
    nickname: String,
    height: Int,
    weight: Int
  ) {
    user.nickname = nickname
    user.height = height
    user.weight = weight
  }
  
  private func fetch() {
    guard user.height > .zero else {
      showLog(error: .noHistory)
      return
    }
  }
}

enum Constant {
  static let titleText: String = "BMI Calculator"
  static let descText: String = "의 BMI 지수를 알려드릴게요."
  static let heightText: String = "키가 어떻게 되시나요?"
  static let heightInvalidText: String = "키는 100 ~ 250 사이로 입력 가능해요!"
  static let weightText: String = "몸무게는 어떻게 되시나요?"
  static let weightInvalidText: String = "몸무게는 30 ~ 200 사이로 입력 가능해요!"
  static let randomCalculateText: String =
  "랜덤으로 BMI 계산하기"
  static let checkResultText: String = "결과 확인"
  static let nicknameText: String = "닉네임을 알려주세요!"
  static let historyText: String = "가장 최근 검사 결과"
  static let resetText: String = "초기화"
  
  static let secureOnSymbol: String = "eye.slash.fill"
  static let secureOffSymbol: String = "eye.fill"
  
  static let previousField: String = "arrowshape.left.fill"
  static let nextField: String = "arrowshape.right.fill"
  static let hideKeyboard: String = "keyboard.chevron.compact.down.fill"
}

extension UIImage {
  func colored(with color: UIColor) -> UIImage {
    return self.withTintColor(color, renderingMode: .alwaysOriginal)
  }
}
