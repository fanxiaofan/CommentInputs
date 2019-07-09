//
//  UserListViewController.swift
//  FFF
//
//  Created by Just Do It on 2019/7/9.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation
import UIKit


struct User {
    var name: String
    var id: String
}

protocol UserSelectedProtocol: class {
    func didSelectedUser(user: User) -> Void
}

class UserListViewController: UIViewController {
    lazy var tableView: UITableView = {
        var tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    var userArray = [User]()
    weak var userSelectDelegate: UserSelectedProtocol?
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}


extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        aCell.textLabel?.text = userArray[indexPath.row].name
        return aCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userSelectDelegate?.didSelectedUser(user: userArray[indexPath.row]);
        self.navigationController?.popViewController(animated: true)
    }
    
}
