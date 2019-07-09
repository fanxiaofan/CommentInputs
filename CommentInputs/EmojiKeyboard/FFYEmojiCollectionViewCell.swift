//
//  FFYEmojiCollectionViewCell.swift
//  FFF
//
//  Created by fanfengyan on 2019/6/5.
//  Copyright © 2019 com.advance. All rights reserved.
//

import UIKit

protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String {get}
}

extension ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return NSStringFromClass(self as! AnyClass)
    }
}

class FFYEmojiPageView: UIView {
    var delegate: EmojiKeyBoardViewDelegate?
    var emojiArray:[String]! {
        didSet {
            reloadData()
        }
    }
    private var  elementViews = [UIButton]()
    private var horizoneNumberOfElements: Int = 6
    private var verticalNumberOfElements: Int = 5
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    fileprivate init(horizoneNumbers: Int = 6, verticalNumbers: Int = 6) {
        horizoneNumberOfElements = horizoneNumbers
        verticalNumberOfElements = verticalNumbers
        super.init(frame: .zero)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        for index in 0..<horizoneNumberOfElements * verticalNumberOfElements {
            let elementButton = elementViews[index]
            if index < emojiArray.count {
                elementButton.setTitle(emojiArray[index], for: .normal)
            }else {
                elementButton.setTitle(nil, for: .normal)
            }
        }
    }
    
    func setupSubViews() {
        
        let stackContainer = UIStackView(frame: .zero)
        stackContainer.axis = .vertical
        stackContainer.distribution = .fillEqually
        stackContainer.spacing = 10
        stackContainer.alignment = .fill
        addSubview(stackContainer)
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        for _ in 0..<verticalNumberOfElements {
            let stackView = getVerticalStackView()
            stackContainer.addArrangedSubview(stackView)
        }
    }
    
    
    private func getElementView() -> UIButton {
        let customView = UIButton(type: .custom)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.setTitle("", for: .normal)
        customView.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        customView.addTarget(self, action: #selector(clickMe(element:)), for: .touchUpInside)
        return customView
    }
    
    @objc private func clickMe(element:UIButton) {
        guard let textString = element.currentTitle else { return }
        if let emojiKeyboardDelegate = delegate {
            emojiKeyboardDelegate.emojiKeyBoard(emojiKeyboardDelegate, didSelectAt: textString)
        }
        
    }
    
    private func getVerticalStackView() -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        for _ in 0..<horizoneNumberOfElements {
            let elementView = getElementView()
            elementViews.append(elementView)
            stackView.addArrangedSubview(elementView)
        }
        return stackView
    }
    
}


class FFYEmojiCollectionViewCell: UICollectionViewCell {
    
    var emojiView: FFYEmojiPageView?
    var horizoneNumberOfElements: Int = 6
    var verticalNumberOfElements: Int = 5
    weak var keyboardDelegate: EmojiKeyBoardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(horizoneNumbers: Int = 6, verticalNumbers: Int = 6) {
        horizoneNumberOfElements = horizoneNumbers
        verticalNumberOfElements = verticalNumbers
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        guard emojiView == nil else { return }
        let emojiView = FFYEmojiPageView(horizoneNumbers: horizoneNumberOfElements, verticalNumbers: verticalNumberOfElements)
        emojiView.delegate = keyboardDelegate
        contentView.addSubview(emojiView)
        emojiView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.emojiView = emojiView
    }
    
    func setupCell(with delegate: EmojiKeyBoardViewDelegate?, emojis: [String]?) {
        emojiView?.emojiArray = emojis
        emojiView?.delegate   = delegate
    }
}


extension UICollectionViewCell: ReuseIdentifierProtocol {}
