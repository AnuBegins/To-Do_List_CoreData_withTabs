//
//  CustomCell.swift
//  To-Do_List_withTabs
//
//  Created by Arun Ram on 7/25/18.
//  Copyright © 2018 Arun Ram. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func taskCompleted(sender: CustomCell, indexPath: IndexPath)
}

class CustomCell: UITableViewCell {

    var delegate: CustomCellDelegate!
    var indexPath: IndexPath?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        delegate.taskCompleted(sender: self, indexPath: indexPath!)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
