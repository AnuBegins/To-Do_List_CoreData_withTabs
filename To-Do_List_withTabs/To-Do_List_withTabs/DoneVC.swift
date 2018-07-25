//
//  DoneVC.swift
//  To-Do_List_withTabs
//
//  Created by Arun Ram on 7/25/18.
//  Copyright © 2018 Arun Ram. All rights reserved.
//

import UIKit
import CoreData

class DoneVC: UITableViewController {

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
        let predicate       = NSPredicate(format: "completed = 1") // filter items whose 'completed' boolean = True
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
    
// TABLE VIEW FUNCTIONS ----------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath)
        let task = tableData[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MMM-yyyy"
        cell.detailTextLabel?.text  = formatter.string(from: task.completed_at!)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task            = tableData[indexPath.row]
        task.completed_at   = nil
        task.completed      = false
        
        print(tableData)
        self.saveContext()
        
        self.tableData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left) // then delete the row from the view
     //   tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction (
            style: .destructive,
            title: "Delete",
            handler: {
                action, view, done in
                
                self.context.delete(self.tableData[indexPath.row])
                self.saveContext()
                
                
                self.tableData.remove(at: indexPath.row)    // first remove the data from the database
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom) // then delete the row from the view
                done(true)
            }
        )
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}




    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

