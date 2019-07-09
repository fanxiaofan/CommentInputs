//
//  FFYEmojiKeyBoard.swift
//  FFF
//
//  Created by fanfengyan on 2019/6/5.
//  Copyright © 2019 com.advance. All rights reserved.
//

import UIKit
import SnapKit

protocol EmojiKeyBoardViewDelegate: class {
    func emojiKeyBoard(_ keyboard: EmojiKeyBoardViewDelegate, didSelectAt emoji: String) -> Void
    func emojiKeyBoardDidClickBackSpace(_ keyboard: EmojiKeyBoardViewDelegate) -> Void
}

protocol ScrollCardBoundaryDelegate {
    func scrollToBoundary(offset: CGFloat) -> Void
    func switchToPrevCategory(prev: Bool) -> Void
}

class FFYEmojiKeyBoard: UIView {
    private var emojiScrollViews = [UIView]()
    private var emojiDictionary = [String: [String]]()
    private var allKeysArray = [String]()
    var horizoneNumberOfElements: Int = 8
    var verticalNumberOfElements: Int = 4
    weak var keyboardDelegate:EmojiKeyBoardViewDelegate? {
        didSet {
            for scrollView in emojiScrollViews {
                if let scrollView = scrollView as? FFYEmojiScrollView {
                    scrollView.delegate = keyboardDelegate
                }
            }
        }
    }
    
    private var scrollViewContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        return container
    }()
    
    private var segmentControl: UISegmentedControl?
    struct LayoutConstant {
        static var segmentHeight: CGFloat = 30
        static var segmentBottom: CGFloat = 10
    }
    
    var categorySwitching: Bool = false
    
    init(frame: CGRect, emojiKeyboard: EmojiKeyBoardViewDelegate) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.keyboardDelegate = emojiKeyboard
        getEmojisFromFile()
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getScrollView(frame: CGRect) -> FFYEmojiScrollView {
        let emojiScrollView = FFYEmojiScrollView(frame:frame, horizoneNumbers: horizoneNumberOfElements, verticalNumbers: verticalNumberOfElements)
        return emojiScrollView
    }
    
    private func getEmojisFromFile() {
        guard let emojiFilePath = Bundle.main.path(forResource: "EmojisList", ofType: "plist") else { return }
        guard let emojiDictionary = NSDictionary(contentsOfFile: emojiFilePath) as? [String: [String]] else { return }
        self.allKeysArray = Array(emojiDictionary.keys).sorted()
        self.emojiDictionary = emojiDictionary
    }
    
    private func setUpSubViews()  {
        
        
        if self.allKeysArray.count > 1 {
            let segmentControl = UISegmentedControl(items: self.allKeysArray)
            segmentControl.addTarget(self, action: #selector(switchCategory(segmentControl:)), for: .valueChanged)
            segmentControl.selectedSegmentIndex = 0
            addSubview(segmentControl)
            segmentControl.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(LayoutConstant.segmentHeight)
                make.bottom.equalTo(-LayoutConstant.segmentBottom)
            }
            self.segmentControl = segmentControl
        }
        //self.bounds.inset(by: .init(top: 0, left: 0, bottom: LayoutConstant.setmentBottom + LayoutConstant.segmentHeight, right: 0)
        let scrollFrame = segmentControl == nil ? self.bounds : .init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - LayoutConstant.segmentBottom -  LayoutConstant.segmentHeight)
        for (index, categoryKey) in allKeysArray.enumerated() {
            let scrollView = getScrollView(frame: scrollFrame)
            scrollView.scrollBoundaryDelegate = self
            scrollView.delegate = keyboardDelegate
            scrollView.emojiArray = emojiDictionary[categoryKey]
            scrollViewContainer.addSubview(scrollView)
            scrollView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(self.frame.width)
                if index == 0 {
                    make.left.equalToSuperview()
                }else {
                    if let prevScrollView = emojiScrollViews.last {
                        make.left.equalTo(prevScrollView.snp.right)
                    }
                }
            }
            emojiScrollViews.append(scrollView)
        }
        
        guard let lastScrollView = emojiScrollViews.last else { return }
        addSubview(scrollViewContainer)
        scrollViewContainer.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalTo(lastScrollView)
            if let segmentControl = segmentControl {
                make.bottom.equalTo(segmentControl.snp.top)
            }else {
                make.bottom.equalToSuperview()
            }
        }
        
        
        let lineGray = UIView()
        lineGray.backgroundColor = UIColor.ffy.gray.sepratorGray
        addSubview(lineGray)
        lineGray.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc private func switchCategory(segmentControl:UISegmentedControl) {
        scrollViewContainer.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(-CGFloat(segmentControl.selectedSegmentIndex) * self.bounds.width)
        }
    }
}

extension FFYEmojiKeyBoard: ScrollCardBoundaryDelegate  {
    func switchToPrevCategory(prev: Bool) {
        categorySwitching = true
        guard let segmentControl = segmentControl else { return }
        let currentCategoryIndex = segmentControl.selectedSegmentIndex
        var netxtCategoryIndex: Int = currentCategoryIndex
        if (currentCategoryIndex == 0 && prev) || (currentCategoryIndex == segmentControl.numberOfSegments - 1 && !prev) {
            netxtCategoryIndex = currentCategoryIndex
        }else if prev {
            netxtCategoryIndex = currentCategoryIndex - 1
        }else {
            netxtCategoryIndex = currentCategoryIndex + 1
        }
        let baseOffSet:CGFloat   = CGFloat(netxtCategoryIndex) *  self.frame.width
        UIView.animate(withDuration:0.5, animations: {
            self.scrollViewContainer.snp.updateConstraints { (make) in
                make.left.equalTo(-baseOffSet)
            }
            segmentControl.selectedSegmentIndex = netxtCategoryIndex
        }) { (finish) in
            self.categorySwitching = false
        }
    }
    
    func scrollToBoundary(offset: CGFloat) {
        guard !categorySwitching else { return }
        guard let segmentControl = segmentControl else { return }
        let currentCategoryIndex = segmentControl.selectedSegmentIndex
        let baseOffSet:CGFloat   = CGFloat(currentCategoryIndex) *  self.frame.width
        scrollViewContainer.snp.updateConstraints { (make) in
            make.left.equalTo(-baseOffSet - offset)
        }
    }
}

