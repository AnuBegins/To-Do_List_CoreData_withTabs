//
//  ToDoVC.swift
//  To-Do_List_withTabs
//
//  Created by Arun Ram on 7/25/18.
//  Copyright © 2018 Arun Ram. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: UITableViewController {

    // COREDATA managed object set-up -------------------------------------------------------
   
    let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    
    // STANDARD table variables & function overrides ----------------------------------------------
    
    var tableData: [Task] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.rowHeight     = 70
        
        fetchAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllData()
        tableView.reloadData()
    }
    
    
    func fetchAllData() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate       = NSPredicate(format: "completed = 0") // filter items whose 'completed' boolean = False
        request.predicate   = predicate
        
        do {
            tableData = try context.fetch(request)
        }
        catch {
            print("No data in database", error)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
// SEGUE Methods -----------------------------------------------------------------
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "seguetoAddEditVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath    = sender as? IndexPath {
            let task        = tableData[indexPath.row]
            let dest        = (segue.destination as! UINavigationController).topViewController as! AddEditVC
            
            dest.indexPath  = indexPath
            dest.item       = task.title!
        }
    }
    
    
    @IBAction func unwindSegueFromAddEditVC(segue: UIStoryboardSegue) {
        let src         = segue.source as! AddEditVC
        let taskText    = src.textField.text!
        
        // for returning an edited 'task' item. If the indexPath variable in AddEditVC has been initialized, then a row in ToDoVC controller was tapped and, therefore, an existing task item is being edited
        if let indexPath = src.indexPath {
            tableData[indexPath.row].title = taskText
            saveContext()
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
            
        // for creating a new To Do entry. If no indexPath exists, then we are creating a new 'To Do' item
        else {
            let task        = Task(context: context)
            task.title      = taskText
            task.completed  = false
            saveContext()
            
            tableData.append(task)
            let newIndexPath = IndexPath(row: tableData.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.bottom)
        }
    }
    

// TableView Methods -----------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.delegate   = self
        cell.indexPath  = indexPath
        
        let task = tableData[indexPath.row]
        cell.titleLabel.text = task.title
        
        return cell
    }
    
    
    // tap on a row to bring up the 'Edit' view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "seguetoAddEditVC", sender: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction (
            style: .destructive,
            title: "Delete",
            handler: {
                action, view, done in
                
                self.context.delete(self.tableData[indexPath.row])   // first remove the data from the database
                self.saveContext()
                
                self.tableData.remove(at: indexPath.row)   // remove entry from the tableData array
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom) // then delete the row from the view
                done(true)
            }
        )
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit",
            handler: {
                action, view, done in
                self.performSegue(withIdentifier: "seguetoAddEditVC", sender: indexPath)
                done(true)
            }
        )
        
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

}


// ---------------------------------------------------------------------------------
extension ToDoVC: CustomCellDelegate {
    func taskCompleted(sender: CustomCell, indexPath: IndexPath) {
        tableData[indexPath.row].completed = true
        tableData[indexPath.row].completed_at = Date()
        saveContext()
        
        tableData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        
        print(tableData)
    }
}
