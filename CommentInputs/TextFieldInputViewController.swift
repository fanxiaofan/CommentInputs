//
//  TextFieldInputViewController.swift
//  FFF
//
//  Created by fanfengyan on 2019/6/3.
//  Copyright © 2019 com.advance. All rights reserved.
//

import UIKit


class TextViewCell: UITableViewCell {
    
    var textView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews()  {
        let tv = UITextView(frame: .zero)
//        tv.backgroundColor = UIColor.ffy.gray.background
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.textContainerInset = .zero
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        contentView.addSubview(tv)
        textView = tv
        
        tv.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.leading.equalTo(15)
        }
    }
}

class TextFieldInputViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        var tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.tableFooterView = UIView()
        return tv
    }()
    
    var comments = [String]()
    
    var commentInputController: FFYInputViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(FFYInputViewController.KeyBoardHeight.normalHeight)
        }
        tableView.register(TextViewCell.self, forCellReuseIdentifier: "TextViewCell")
        
        
        let commentTextInputViewController = FFYInputViewController(normalElements: [.commentArea, .like], expandElements: [.at, .emoji], delegate: self)
        view.addSubview(commentTextInputViewController.normalSubViewContainer)
        commentTextInputViewController.normalSubViewContainer.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(commentTextInputViewController.expandSubViewContainer)
        commentTextInputViewController.expandSubViewContainer.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(60)
        }
        
        commentInputController = commentTextInputViewController
    }
    
    @objc func dismiss(tap: UITapGestureRecognizer) {
        
    }
}

extension TextFieldInputViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var aCell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewCell
        if aCell == nil {
            aCell = TextViewCell(style: .default, reuseIdentifier: "TextViewCell")
        }
        let commentString = comments[indexPath.row]
        configCellWithComment(cell: aCell!,comment: commentString)
        return aCell!
    }
    
    
    func configCellWithComment(cell: TextViewCell, comment: String) {
        let mutableAttributeString = NSMutableAttributedString(string:comment)
        mutableAttributeString.addAttribute(.foregroundColor, value: UIColor.black, range: .init(location: 0, length: mutableAttributeString.length))
        if let matchs = commentInputController?.findAllAt(string: comment) {
            for match in matchs {
                mutableAttributeString.addAttribute(.foregroundColor, value: UIColor.blue, range: .init(location: match.range.location, length: match.range.length - 1))
            }
        }
        cell.textView.attributedText = mutableAttributeString
    }
    
}

extension TextFieldInputViewController: UserSelectedProtocol {
    func didSelectedUser(user: User) {
        commentInputController?.expandSubViewContainer.textView?.insertText(user.name + " ")
    }
}

extension TextFieldInputViewController: InputElementViewDelegate {
    func placeHolerForInput() -> String {
        return "Please Say Somthing..."
    }
    
    func inputViewWillBeginEditting(inputController: FFYInputViewController) {
        
    }
    
    func inputViewContentWillChange(controller: FFYInputViewController) {
        
    }
    
    
    func normalElementClicked(element: InputNormalElement) {
        
    }
    
    func sendViewClicked() {
        if let comment = commentInputController?.expandSubViewContainer?.textView?.text {
            comments.append(comment)
            tableView.reloadData()
        }
    }
    
    func expandElementClicked(element: InputExpandElement) {
        if element == .at {
            let userList = UserListViewController()
            userList.userArray = [User(name: "JackLi_ooh", id: "1"), User(name: "Tom", id: "2"),User(name: "Jerry", id: "3")]
            userList.userSelectDelegate = self
            self.navigationController?.pushViewController(userList, animated: true)
        }
    }
    
}


