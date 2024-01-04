//
//  ViewController.swift
//  SeSAC-Mission-Day5-EmotionDiary
//
//  Created by 원태영 on 1/2/24.
//

import UIKit

final class ViewController: UIViewController {
  
  final class Emotion {
    let image: UIImage
    let title: String
    let label: UILabel
    var count: Int
    
    init(
      image: UIImage,
      title: String,
      label: UILabel,
      count: Int
    ) {
      self.image = image
      self.title = title
      self.label = label
      self.count = UserDefaults.standard.integer(forKey: title)
    }
    
    private func increase() {
      count += 1
    }
    
    private func setCount() {
      UserDefaults.standard.set(count, forKey: title)
    }
    
    func updateLabel() {
      increase()
      setCount()
      label.text = title + " " + count.description
    }
  }
  
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var label4: UILabel!
  @IBOutlet weak var label5: UILabel!
  @IBOutlet weak var label6: UILabel!
  @IBOutlet weak var label7: UILabel!
  @IBOutlet weak var label8: UILabel!
  @IBOutlet weak var label9: UILabel!
  
  @IBOutlet var imageViews: [UIImageView]!
  
  private lazy var labels: [UILabel] = [
    label1, label2, label3,
    label4, label5, label6,
    label7, label8, label9
  ]
  
  private lazy var emotions: [Emotion] = [
    .init(image: .slime1, title: "행복해" ,label: label1, count: getRandomNumber()),
    .init(image: .slime2, title: "사랑해" ,label: label2, count: getRandomNumber()),
    .init(image: .slime3, title: "좋아해" ,label: label3, count: getRandomNumber()),
    .init(image: .slime4, title: "당황해" ,label: label4, count: getRandomNumber()),
    .init(image: .slime5, title: "속상해" ,label: label5, count: getRandomNumber()),
    .init(image: .slime6, title: "우울해" ,label: label6, count: getRandomNumber()),
    .init(image: .slime7, title: "심심해" ,label: label7, count: getRandomNumber()),
    .init(image: .slime8, title: "궁금해" ,label: label8, count: getRandomNumber()),
    .init(image: .slime9, title: "억울해" ,label: label9, count: getRandomNumber()),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  
  @IBAction func slimeImageTapped(_ sender: UITapGestureRecognizer) {
    guard let indexTag: Int = sender.view?.tag else { return }
    
    emotions[indexTag].updateLabel()
  }
  
  private func configureUI() {
    setCells()
  }
  
  private func setCells() {
    emotions.indices.forEach { index in
      let imageView: UIImageView = imageViews[index]
      let emotion: Emotion = emotions[index]
      
      imageView.image = emotion.image
      imageView.contentMode = .scaleAspectFit
      imageView.tag = index
      imageView.isUserInteractionEnabled = true
      
      emotion.label.text = emotion.title + " " + emotion.count.description
      emotion.label.font = .boldSystemFont(ofSize: 16)
    }
  }
  
  private func getRandomNumber() -> Int {
    return Int.random(in: 1...100)
  }
}

