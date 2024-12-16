//
//  ViewControllerRootView.swift
//  Morse
//
//  Created by Адам Мирзаканов on 16.12.2024.
//

import UIKit

enum Const {
  static let placeholderTextViewFont = UIFont(name: "Courier", size: 40)
  static let placeholderText: String = "Write..."
  static let stackViewTopInset: CGFloat = 15.0
  static let stackViewHorizontalInset: CGFloat = 20.0
  static let stackViewWidthAdjustment: CGFloat = -40.0
  static let duration: CGFloat = 0.08
  static let pressingPlayButtonScale: CGFloat = 0.9
  static let playButtonScale: CGFloat = 1.0
  static let lineHeight: CGFloat = 1.0
  static let lineColor: UIColor = .systemGray
}

protocol RootViewDelegate: AnyObject {
  func playButtonTapped(message: MorseCodeMessage)
}

final class ViewControllerRootView: BaseRootView {
  // MARK: Properties
  weak var delegate: RootViewDelegate?
  
  // MARK: Views
  private let messageTextView: PlaceholderTextView = {
    $0.font = Const.placeholderTextViewFont
    $0.isScrollEnabled = false
    $0.textAlignment = .left
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = .zero
    $0.placeholder = Const.placeholderText
    $0.backgroundColor = .clear
    $0.textColor = .systemGray
    $0.tintColor = .systemGray
    $0.autocapitalizationType = .allCharacters  
    $0.autocorrectionType = .no
    return $0
  }(PlaceholderTextView())
  
  private let playMessageButton: UIButton = {
    $0.setTitle("Message", for: .normal)
    $0.setTitleColor(.systemGray, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Courier", size: 30)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 10.0
    return $0
  }(UIButton())
  
  private lazy var lineView: UIView = {
    $0.backgroundColor = Const.lineColor
    $0.heightAnchor.constraint(
      equalToConstant: Const.lineHeight / traitCollection.displayScale
    ).isActive = true
    return $0
  }(UIView())
  
  private lazy var anchorImageView: UIImageView = {
    $0.image = UIImage(named: "Anchors")
    $0.contentMode = .scaleAspectFit
    $0.heightAnchor.constraint(
      equalToConstant: 100
    ).isActive = true
    $0.widthAnchor.constraint(
      equalToConstant: 100
    ).isActive = true
    return $0
  }(UIImageView())
  
  private lazy var textViewStackView: UIStackView = {
    $0.axis = .vertical
    $0.alignment = .center
    $0.alignment = .fill
    $0.spacing = 10
    $0.addArrangedSubview(messageTextView)
    $0.addArrangedSubview(lineView)
    return $0
  }(UIStackView())
  
  private lazy var mainStackView: UIStackView = {
    $0.axis = .vertical
    $0.alignment = .center
    $0.alignment = .fill
    $0.spacing = 30
    $0.addArrangedSubview(textViewStackView)
    $0.addArrangedSubview(playMessageButton)
    $0.addArrangedSubview(anchorImageView)
    return $0
  }(UIStackView())
  
  let scrollView: UIScrollView = {
    $0.alwaysBounceVertical = true
    return $0
  }(UIScrollView())
  
  // MARK: Setup Views
  override func initViews() {
    super.initViews()
    addSubviews()
    setConstranits()
    setupPlayButton()
    backgroundColor = .tertiarySystemBackground
  }
  
  // MARK: Private Methods
  private func addSubviews() {
    addSubview(scrollView)
    scrollView.addSubview(mainStackView)
  }
  
  private func setConstranits() {
    setScrollViewConstraints()
    setMainStackViewConstraints()
  }
  
  private func setScrollViewConstraints() {
    scrollView.setConstraints(
      top: safeAreaLayoutGuide.topAnchor,
      bottom: safeAreaLayoutGuide.bottomAnchor,
      leading: safeAreaLayoutGuide.leadingAnchor,
      trailing: safeAreaLayoutGuide.trailingAnchor
    )
  }
  
  private func setMainStackViewConstraints() {
    mainStackView.centerXY()
    mainStackView.widthAnchor.constraint(
      equalTo: scrollView.widthAnchor,
      constant: Const.stackViewWidthAdjustment
    ).isActive = true
  }
  
  // MARK: Private Methods
  private func scheduleColorChange(
    for event: MorseCodePlaybackEvent,
    at timeInterval: TimeInterval
  ) {
    let color = colorForEvent(event)
    Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: false) { _ in
        self.backgroundColor = color
      }
  }
  
  private func colorForEvent(_ event: MorseCodePlaybackEvent) -> UIColor {
    switch event {
    case .off:
      return .black
    case .on:
      return .systemRed
    }
  }
  
  private func scheduleResetColor(at timeInterval: TimeInterval) {
    Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: false) { _ in
        self.backgroundColor = .black
      }
  }
  
  private func setupPlayButton() {
    playMessageButton.addTarget(
      self,
      action: #selector(playButtonTapped),
      for: .touchUpInside
    )
  }
  
  @objc private func playButtonTapped(_ sender: UIButton) {
    guard let message = MorseCodeMessage(message: messageTextView.text ?? "")
    else { return }
    messageTextView.resignFirstResponder()
    animatePlayButton(sender)
    delegate?.playButtonTapped(message: message)
  }
  
  
  func animatePlayButton(_ sender: UIButton) {
    UIView.animate(withDuration: Const.duration) { [weak self] in
      self?.scaleDownButton(sender)
    } completion: { _ in
      UIView.animate(withDuration: Const.duration) { [weak self] in
        self?.scaleUpButton(sender)
      }
    }
  }
  
  func scaleDownButton(_ sender: UIButton) {
    let scaleTransform = CGAffineTransform(
      scaleX: Const.pressingPlayButtonScale,
      y: Const.pressingPlayButtonScale
    )
    sender.transform = scaleTransform
  }
  
  func scaleUpButton(_ sender: UIButton) {
    let scaleTransform = CGAffineTransform(
      scaleX: Const.playButtonScale,
      y: Const.playButtonScale
    )
    sender.transform = scaleTransform
  }
}

// MARK: - MorseCodePlayer
extension ViewControllerRootView: MorseCodePlayer {
  func play(message: MorseCodeMessage) throws {
    
    // время через которое экран меняет цвет
    var startTimeInterval: TimeInterval = .zero
    
    message.playbackEvents.forEach {
      switch $0 {
      case .off:
        Timer.scheduledTimer(
          withTimeInterval: startTimeInterval,
          repeats: false) { _ in
            self.backgroundColor = .tertiarySystemBackground
//            self.messageTextView.backgroundColor = .tertiarySystemBackground
            self.messageTextView.textColor = .systemGray
            self.lineView.backgroundColor = Const.lineColor
          }
      case .on:
        Timer.scheduledTimer(
          withTimeInterval: startTimeInterval,
          repeats: false) { _ in
            self.backgroundColor = .systemGray
//            self.messageTextView.backgroundColor = .systemGray
            self.messageTextView.textColor = .tertiarySystemBackground
            self.lineView.backgroundColor = .systemGray3
          }
      }
      // таймер стартует без задержки startTimeInterval = 0
      // после каждого шага к startTimeInterval прибавляется время которое прошло
      // для того что бы смена цвета произошла с учетом пройденного времени
      startTimeInterval += $0.duration
      
      // цвет на котором все закончится (вернуться к исходному)
      Timer.scheduledTimer(
        withTimeInterval: startTimeInterval,
        repeats: false
      ) { _ in
        self.backgroundColor = .tertiarySystemBackground
      }
    }
  }
}
