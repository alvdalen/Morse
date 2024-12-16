//
//  ViewControllerRootView.swift
//  Morse
//
//  Created by Адам Мирзаканов on 16.12.2024.
//

import UIKit

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
    $0.setTitle(Const.playMessageButtonTitleText, for: .normal)
    $0.setTitleColor(.systemGray, for: .normal)
    $0.titleLabel?.font = Const.playMessageButtonFont
    $0.backgroundColor = Const.playMessageButtonColor
    $0.layer.cornerRadius = Const.playMessageButtonCornerRadius
    return $0
  }(UIButton())
  
  private lazy var lineView: UIView = {
    $0.backgroundColor = Const.lightMainColor
    $0.heightAnchor.constraint(
      equalToConstant: Const.lineHeight / traitCollection.displayScale
    ).isActive = true
    return $0
  }(UIView())
  
  private lazy var anchorImageView: UIImageView = {
    $0.image = Const.anchorImage
    $0.contentMode = .scaleAspectFit
    $0.heightAnchor.constraint(
      equalToConstant: Const.anchorImageViewSize
    ).isActive = true
    $0.widthAnchor.constraint(
      equalToConstant: Const.anchorImageViewSize
    ).isActive = true
    return $0
  }(UIImageView())
  
  private lazy var textViewStackView: UIStackView = {
    $0.axis = .vertical
    $0.alignment = .center
    $0.alignment = .fill
    $0.spacing = Const.textViewStackViewSpacing
    $0.addArrangedSubview(messageTextView)
    $0.addArrangedSubview(lineView)
    return $0
  }(UIStackView())
  
  private lazy var mainStackView: UIStackView = {
    $0.axis = .vertical
    $0.alignment = .center
    $0.alignment = .fill
    $0.spacing = Const.mainStackViewSpacing
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
    backgroundColor = Const.rootViewBackgroundColor
  }
}

// MARK: - Private Methods
private extension ViewControllerRootView {
  func addSubviews() {
    addSubview(scrollView)
    scrollView.addSubview(mainStackView)
  }
  
  func setConstranits() {
    setScrollViewConstraints()
    setMainStackViewConstraints()
  }
  
  func setScrollViewConstraints() {
    scrollView.setConstraints(
      top: safeAreaLayoutGuide.topAnchor,
      bottom: safeAreaLayoutGuide.bottomAnchor,
      leading: safeAreaLayoutGuide.leadingAnchor,
      trailing: safeAreaLayoutGuide.trailingAnchor
    )
  }
  
  func setMainStackViewConstraints() {
    mainStackView.centerXY()
    mainStackView.widthAnchor.constraint(
      equalTo: scrollView.widthAnchor,
      constant: Const.stackViewWidthAdjustment
    ).isActive = true
  }
  
  func scheduleTimer(
    for event: MorseCodePlaybackEvent,
    at startTimeInterval: TimeInterval
  ) {
    Timer.scheduledTimer(
      withTimeInterval: startTimeInterval,
      repeats: false) { [weak self] _ in
        guard let self = self else { return }
        self.applyStyle(for: event)
      }
  }
  
  func applyStyle(for event: MorseCodePlaybackEvent) {
    switch event {
    case .off:
      self.backgroundColor = Const.rootViewBackgroundColor
      self.messageTextView.textColor = Const.lightMainColor
      self.lineView.backgroundColor = Const.darkMainColor
    case .on:
      self.backgroundColor = Const.lightMainColor
      self.messageTextView.textColor = Const.rootViewBackgroundColor
      self.lineView.backgroundColor = Const.darkMainColor
    }
  }
  
  func scheduleFinalResetTimer(at timeInterval: TimeInterval) {
    Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: false) { [weak self] _ in
        guard let self = self else { return }
        self.backgroundColor = Const.rootViewBackgroundColor
      }
  }
  
  func setupPlayButton() {
    playMessageButton.addTarget(
      self,
      action: #selector(playButtonTapped),
      for: .touchUpInside
    )
  }
  
  @objc func playButtonTapped(_ sender: UIButton) {
    guard let message = MorseCodeMessage(message: messageTextView.text ?? .empty)
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
    var startTimeInterval: TimeInterval = .zero
    message.playbackEvents.forEach { event in
      scheduleTimer(for: event, at: startTimeInterval)
      startTimeInterval += event.duration
    }
    scheduleFinalResetTimer(at: startTimeInterval)
  }
}
