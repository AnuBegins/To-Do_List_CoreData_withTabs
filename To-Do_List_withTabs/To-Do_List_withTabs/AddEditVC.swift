//
//  AddEditVC.swift
//  To-Do_List_withTabs
//
//  Created by Arun Ram on 7/25/18.
//  Copyright © 2018 Arun Ram. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController {

    var indexPath: IndexPath?
    var item: String = ""
    

    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier:"unwindSegueFromAddEditVC", sender: sender)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For new to-do's, the text field initially displays an empty string by default. For editing existing to-do's, text field is pre-populated with string passed to variable 'item' via prepare method in ToDoVC.swift
        textField.text = item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
