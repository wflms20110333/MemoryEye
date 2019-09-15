//
//  MemoryListViewController.swift
//  MemoryEye
//
//  Created by Peter T Tran on 9/14/19.
//  Copyright © 2019 Peter T Tran. All rights reserved.
//

import UIKit

class MemoryListViewController: UIViewController {
    
    @IBOutlet weak var memoryTable: UITableView?
    @IBOutlet weak var imageCell: UIImageView?
    @IBOutlet weak var nameCell: UILabel?
    @IBOutlet weak var locationCell: UILabel?
    @IBOutlet weak var dateCell: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

class Memory {
    var name: String?
    var pictureUrl: String?
    init(json: [String: Any]) {
        self.name = json[“name”] as? String
        self.pictureUrl = json[“pictureUrl”] as? String
    }
}

protocol MemoryViewModelItem {
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

class ProfileViewModeFriendsItem: MemoryViewModelItem {
    var sectionTitle: String {
        return "List of Memories"
    }
    var rowCount: Int {
        return memories.count
    }
    var memories: [Memory]
    
    init(memories: [Memory]) {
        self.memories = memories
    }
}

extension ViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we will configure the cells here
    }
}

class FriendCell: UITableViewCell {
    var item: Memory? {
        didSet {
            guard let item = item else {
                return
            }
            if let pictureUrl = item.pictureUrl {
                pictureImageView?.image = UIImage(named: pictureUrl)
            }
            nameLabel?.text = item.name
        }
    }
}
