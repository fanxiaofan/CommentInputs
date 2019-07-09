//
//  FFYCommonTextInputView.swift
//  FFF
//
//  Created by Just Do It on 2019/7/9.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation
import SnapKit

//normal InputView
class InputNormalView: UIView {
    var delegate: InputNormalElementViewDelegate?
    var textView: UITextField?
    var elements:[InputNormalElement]
    var elementViews: [UIView]!
    fileprivate var commentCountLabel: UIButton?
    
    init(frame: CGRect = .zero, elements:[InputNormalElement]) {
        self.elements = elements
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        
        let textView = UITextField(frame: .zero)
        textView.layer.cornerRadius = FFYInputViewController.KeyBoardHeight.textViewDefaultHeight / 2
        textView.backgroundColor = UIColor.ffy.gray.inputBackground
        textView.font = UIFont.systemFont(ofSize: 12)
        addSubview(textView)
        self.textView = textView
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-30)
            make.top.equalTo(FFYInputViewController.KeyBoardHeight.expandTop)
            make.height.equalTo(FFYInputViewController.KeyBoardHeight.textViewDefaultHeight)
            make.centerY.equalToSuperview()
        }
        //margin
        let leftMargin = UIView()
        leftMargin.frame = .init(x: 0, y: 0, width: 10, height: 10)
        textView.leftView = leftMargin
        textView.leftViewMode = .always
        
        //border
        let lineGray = UIView()
        lineGray.backgroundColor = UIColor.ffy.gray.sepratorGray
        addSubview(lineGray)
        lineGray.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        //element views
        elementViews = [UIView]()
        if elements.count > 0 {
            var preView: UIView!
            for (index,element) in elements.enumerated() {
                if index > 0 { preView = elementViews.last! }
                let elementView = createElementView(element: element)
                addSubview(elementView)
                elementView.snp.makeConstraints { (make) in
                    make.centerY.equalTo(textView)
                    make.width.equalTo(30)
                    if index > 0 {
                        make.right.equalTo(preView.snp.left).offset(-10)
                    }else {
                        make.right.equalTo(-20)
                    }
                }
                elementViews.append(elementView)
                preView = elementView
                
                //for comment count
                if element == .commentArea {
                    if let commentCountView = createElementView(element: .commentArea) as? UIButton {
                        let countViewHeight:CGFloat = 12
                        commentCountView.setImage(nil, for: .normal)
                        commentCountView.titleLabel?.font = UIFont.systemFont(ofSize: 8)
                        commentCountView.backgroundColor = UIColor.ffy.red.like //E02020
                        commentCountView.layer.cornerRadius = countViewHeight / 2
                        commentCountView.setTitle("  ", for: .normal)
                        commentCountView.setTitleColor(UIColor.white, for: .normal)
                        commentCountView.isHidden = true
                        commentCountView.contentEdgeInsets = .zero
                        commentCountView.titleEdgeInsets = .zero
                        commentCountView.contentHorizontalAlignment = .center
                        addSubview(commentCountView)
                        commentCountView.snp.makeConstraints { (make) in
                            make.left.equalTo(elementView.snp.right).offset(-15)
                            make.bottom.equalTo(elementView.snp.top).offset(5)
                            make.height.equalTo(countViewHeight)
                            make.width.equalTo(10)
                        }
                        commentCountLabel = commentCountView
                    }
                }
            }
            preView = elementViews.last!
            textView.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(preView.snp.left).offset(-15)
                make.top.equalTo(FFYInputViewController.KeyBoardHeight.expandTop)
                make.height.equalTo(FFYInputViewController.KeyBoardHeight.textViewDefaultHeight)
                make.centerY.equalToSuperview()
            }
        }
        
        
    }
    
    
    func createElementView(element: InputNormalElement) -> UIView {
        let elementView = UIButton(type: .custom)
        elementView.addTarget(self, action: #selector(elementClicked(button:)), for: .touchUpInside)
        elementView.setImage(element.image, for: .normal)
        elementView.restorationIdentifier = element.rawValue
        return elementView
    }
    
    @objc func elementClicked(button: UIButton) {
        guard let element = InputNormalElement(rawValue: button.restorationIdentifier ?? String()) else { return }
        delegate?.normalElementClicked(element: element)
    }
}


//expand InputView
class InputExpandView: UIView {
    var delegate: InputExpandElementViewDelegate?
    var textView: UITextView?
    var sendButton: UIButton?
    var emojiInUse: Bool = false;
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = FFYInputViewController.KeyBoardHeight.textViewDefaultHeight / 2
        textView.backgroundColor = UIColor.ffy.gray.inputBackground
        textView.returnKeyType = .send
        let insets: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        textView.textContainerInset = insets
        addSubview(textView)
        self.textView = textView
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(FFYInputViewController.KeyBoardHeight.expandTop)
            make.height.equalTo(FFYInputViewController.KeyBoardHeight.textViewDefaultHeight)
            make.centerY.equalToSuperview()
        }
        
        let lineGray = UIView()
        lineGray.backgroundColor = UIColor.ffy.gray.sepratorGray
        addSubview(lineGray)
        lineGray.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let sendView = UIButton(type: .custom)
        sendView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendView.setTitleColor(UIColor.ffy.gray.gray, for: .normal)
        sendView.setTitleColor(UIColor.ffy.blue.commentSend, for: .selected)
        sendView.setTitle("Send", for: .normal)
        sendView.setTitle("Send", for: .selected)
        sendView.addTarget(self, action: #selector(clickSendAction(sendButton:)), for: .touchUpInside)
        addSubview(sendView)
        sendView.snp.makeConstraints { (make) in
            make.left.equalTo(textView.snp.right).offset(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(textView)
            make.width.equalTo(50)
        }
        sendButton = sendView
        
    }
    
    
    @objc func clickSendAction(sendButton: UIButton) {
        self.delegate?.sendViewClicked()
    }
}

class InputAccssoryView: UIView {
    var delegate: InputExpandElementViewDelegate?
    var elementContainer: UIView?
    var elements:[InputExpandElement]
    var elementViews: [UIView]!
    
    init(frame: CGRect = .zero, elements:[InputExpandElement]) {
        self.elements = elements
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.elementContainer = containerView
        
        elementViews = [UIView]()
        guard elements.count > 0 else { return }
        for (_,element) in elements.enumerated() {
            let elementView = createElementView(element: element)
            containerView.addSubview(elementView)
            elementView.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.centerY.equalToSuperview()
                if let preView = elementViews.last {
                    make.right.equalTo(preView.snp.left).offset(-15)
                }else {
                    make.right.equalTo(-20)
                }
                make.height.equalTo(25)
            }
            elementViews.append(elementView)
        }
    }
    
    func createElementView(element: InputExpandElement) -> UIView {
        let elementView = UIButton(type: .custom)
        elementView.addTarget(self, action: #selector(elementClicked(button:)), for: .touchUpInside)
        elementView.setImage(element.image, for: .normal)
        elementView.restorationIdentifier = element.rawValue
        return elementView
    }
    
    @objc func elementClicked(button: UIButton) {
        guard let element = InputExpandElement(rawValue: button.restorationIdentifier ?? String()) else { return }
        delegate?.expandElementClicked(element: element)
    }
    
    
}


extension FFYInputViewController {
    struct KeyBoardHeight {
        static var normalHeight: CGFloat = 50
        
        static var textViewDefaultHeight: CGFloat = 30
        static var expandTop: CGFloat = 10
        static var expandHeight: CGFloat {
            return textViewDefaultHeight + 2 * expandTop
        }
        
        static var accessViewHeight: CGFloat = 40
        
        
    }
}


protocol InputElementViewDelegate: InputNormalElementViewDelegate, InputExpandElementViewDelegate{
    func placeHolerForInput() -> String
    func inputViewWillBeginEditting(inputController: FFYInputViewController) -> Void
    func inputViewContentWillChange(controller: FFYInputViewController) -> Void
}

class FFYInputViewController: NSObject {
    var keyboardHeight: CGFloat = 0
    var keyboardVisiable: Bool  = false
    var maxNumberOfLine: Int = 4
    
    var delegate: InputElementViewDelegate? {
        didSet {
            normalSubViewContainer.delegate = self.delegate
            expandSubViewContainer.delegate = self.delegate
        }
    }
    
    var normalSubViewContainer: InputNormalView!
    var expandSubViewContainer: InputExpandView!
    var emojiKeyboard: FFYEmojiKeyBoard?
    
    private var tapGesture: UITapGestureRecognizer?
    
    init(normalElements:[InputNormalElement], expandElements: [InputExpandElement], delegate: InputElementViewDelegate? = .none) {
        super.init()
        self.delegate = delegate
        setUpSubViews(normalElements:normalElements, expandElements: expandElements)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpCommentsCount(count: Int) {
        guard count > 0 else {
            normalSubViewContainer.commentCountLabel?.isHidden = true
            return
        }
        var titleContent: String
        if count < 999 {
            titleContent = "\(count)"
        }else {
            titleContent = " 999+ "
        }
        let buttonFont = normalSubViewContainer.commentCountLabel?.titleLabel?.font ?? UIFont.systemFont(ofSize: 8)
        let attributeTitle = NSMutableAttributedString(string: titleContent, attributes: [.font : buttonFont])
        let (buttonSize,_) = attributeTitle.renderSize(in: .init(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        normalSubViewContainer.commentCountLabel?.setTitle(titleContent, for: .normal)
        normalSubViewContainer.commentCountLabel?.snp.updateConstraints { (make) in
            make.width.equalTo(buttonSize.width + 12)
            //            make.height.equalTo(buttonSize.height + 10)
        }
        normalSubViewContainer.commentCountLabel?.isHidden = false
    }
    
    private func setUpSubViews(normalElements:[InputNormalElement], expandElements: [InputExpandElement]) {
        let normalInputView = InputNormalView(elements: normalElements)
        normalSubViewContainer = normalInputView
        normalSubViewContainer.delegate = self
        normalSubViewContainer.textView?.delegate = self
        normalSubViewContainer.textView?.placeholder = delegate?.placeHolerForInput()
        
        let expandInputView = InputExpandView()
        expandSubViewContainer = expandInputView
        expandSubViewContainer.delegate = self
        expandSubViewContainer.textView?.delegate = self
        
        let inputAccessView = InputAccssoryView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: FFYInputViewController.KeyBoardHeight.accessViewHeight), elements: expandElements)
        inputAccessView.delegate = self
        expandInputView.textView?.inputAccessoryView = inputAccessView
    }
    
    @objc private func dismissKeyBoard(gesture: UITapGestureRecognizer) {
        if let tapView = gesture.view {
            tapView.removeGestureRecognizer(gesture)
        }
        self.tapGesture = nil
        expandSubViewContainer.textView?.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let userInfo = notification.userInfo else {return}
        //keyboardFrame
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.keyboardHeight = keyboardFrame.height
        if keyboardVisiable {
            self.expandSubViewContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(-keyboardHeight)
            }
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        let curve: UIView.AnimationCurve =  UIView.AnimationCurve(rawValue: curveValue ?? 0) ?? .linear
        guard let superView = self.expandSubViewContainer.superview else { return }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard(gesture:)))
        superView.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        superView.setNeedsLayout()
        self.expandSubViewContainer.snp.updateConstraints { (make) in
            make.bottom.equalTo(-keyboardHeight)
        }
        superView.layoutIfNeeded()
        UIView.commitAnimations()
        self.keyboardVisiable = true
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        guard let userInfo = notification.userInfo else {return}
        //keyboardFrame
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = keyboardFrame.height
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        let curve: UIView.AnimationCurve =  UIView.AnimationCurve(rawValue: curveValue ?? 0) ?? .linear
        guard let superView = self.expandSubViewContainer.superview else { return }
        let expandViewHeight = self.expandSubViewContainer.bounds.height
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration + 0.1)
        UIView.setAnimationCurve(curve)
        superView.layoutIfNeeded()
        self.expandSubViewContainer.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(expandViewHeight)
        }
        UIView.commitAnimations()
        keyboardVisiable = false
        if let tapGesture = self.tapGesture {
            superView.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }
    
    
    func clearData()  {
        expandSubViewContainer.textView?.text = nil
        expandSubViewContainer.sendButton?.isSelected = false
        expandSubViewContainer.textView?.snp.updateConstraints { (make) in
            make.height.equalTo(KeyBoardHeight.textViewDefaultHeight)
        }
    }
}

extension FFYInputViewController: UITextViewDelegate, UITextFieldDelegate {
    //tf
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        delegate?.inputViewWillBeginEditting(inputController: self)
        DispatchQueue.main.asyncAfter(deadline: 0.1) {
            self.expandSubViewContainer.textView?.becomeFirstResponder()
        }
        return false
    }
    
    //tv
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        //hightlight @
        var newText: String = ""
        if let selectedRange = textView.markedTextRange {
            newText = textView.text(in: selectedRange) ?? ""
        }
        if newText.count < 1 {
            let range = textView.selectedRange
            let mutableAttributeString = NSMutableAttributedString(string: textView.text)
            mutableAttributeString.addAttribute(.foregroundColor, value: UIColor.black, range: .init(location: 0, length: mutableAttributeString.length))
            let matches = findAllAt(string: mutableAttributeString.string)
            for match in matches {
                mutableAttributeString.addAttribute(.foregroundColor, value: UIColor.blue, range: .init(location: match.range.location, length: match.range.length - 1))
            }
            textView.attributedText = mutableAttributeString
            textView.selectedRange = range
        }
        
        //update height
        let contentHeight = textView.contentSize.height
        guard let font = textView.font else { return }
        let lineHeight = font.lineHeight
        let textLineNumber = Int((contentHeight) / lineHeight)
        var actualHeight = CGFloat(textLineNumber) * lineHeight
        let maxHeight = CGFloat(maxNumberOfLine) * lineHeight
        if actualHeight < KeyBoardHeight.textViewDefaultHeight {
            actualHeight = KeyBoardHeight.textViewDefaultHeight
        }else if actualHeight > maxHeight{
            actualHeight = maxHeight
        }else {
        }
        textView.snp.updateConstraints { (make) in
            make.height.equalTo(actualHeight)
        }
        if let content = textView.text, content.count > 0 {
            self.expandSubViewContainer.sendButton?.isSelected = true
        }else {
            self.expandSubViewContainer.sendButton?.isSelected = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            DispatchQueue.main.asyncAfter(deadline: 0.1) {
                if textView.text.count > 0 {
                    textView.resignFirstResponder()
                    self.expandElementClicked(element: .send)
                }
            }
            return false
        }else if text == "@" {
            expandElementClicked(element: .at)
        }else if text == "" {
            if textView.selectedRange.length > 0 { return true}
            if let fullString = textView.text {
                var originalString = fullString
                let matches = findAllAt(string: originalString)
                var inAt = false
                var index = range.location
                for match in matches {
                    let newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
                    if (NSLocationInRange(range.location, newRange)) {
                        inAt = true
                        index = match.range.location
                        let start = originalString.index(originalString.startIndex, offsetBy: match.range.location)
                        let end   = originalString.index(originalString.startIndex, offsetBy: match.range.location + match.range.length
                        )
                        originalString = originalString.replacingCharacters(in: start..<end, with: "")
                        break;
                    }
                }
                
                if inAt {
                    textView.text = originalString
                    textView.selectedRange = .init(location: index, length: 0)
                    return false
                }
            }
        }
        return true
        
    }
    
    func findAllAt(string: String) -> [NSTextCheckingResult] {
        do {
            
            let regex:NSRegularExpression = try NSRegularExpression(pattern: "@\\w+\\s+", options: .caseInsensitive)
            let matches = regex.matches(in: string, options: .reportProgress, range: .init(location: 0, length: NSString(string: string).length))
            return matches;
        } catch let error as NSError{
            print(error)
        }catch {
        }
        return [NSTextCheckingResult]();
    }
    
}

extension FFYInputViewController: InputNormalElementViewDelegate, InputExpandElementViewDelegate  {
    func normalElementClicked(element: InputNormalElement) {
        delegate?.normalElementClicked(element: element)
    }
    
    func sendViewClicked() {
        delegate?.sendViewClicked()
        clearData()
        expandSubViewContainer.textView?.resignFirstResponder()
    }
    
    func expandElementClicked(element: InputExpandElement) {
        switch element {
        case .emoji:
            useEmoji()
            break
        default:
            break
        }
        print(element.rawValue)
        delegate?.expandElementClicked(element: element)
    }
    
    
    func useEmoji() {
        if emojiKeyboard == nil {
            let keyboard = FFYEmojiKeyBoard(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240), emojiKeyboard: self)
            keyboard.keyboardDelegate = self
            emojiKeyboard = keyboard
        }
        if !expandSubViewContainer.emojiInUse {
            expandSubViewContainer.textView?.inputView = emojiKeyboard
        }else {
            expandSubViewContainer.textView?.inputView = nil
        }
        expandSubViewContainer.emojiInUse = !expandSubViewContainer.emojiInUse
        expandSubViewContainer.textView?.reloadInputViews()
    }
}


extension FFYInputViewController: EmojiKeyBoardViewDelegate {
    func emojiKeyBoard(_ keyboard: EmojiKeyBoardViewDelegate, didSelectAt emoji: String) {
        expandSubViewContainer.textView?.insertText(emoji)
    }
    
    func emojiKeyBoardDidClickBackSpace(_ keyboard: EmojiKeyBoardViewDelegate) {
        expandSubViewContainer.textView?.deleteBackward()
    }
    
}
