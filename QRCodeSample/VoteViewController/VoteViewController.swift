//
//  VoteViewController.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/29.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class VoteViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var names: [String] = []
    var groupName: String!
    var ref: DatabaseReference!
    
    var selectedNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = groupName
        
        self.tableView.register(UINib(nibName: "VoteViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        ref = Database.database().reference()
        ref.child("users").child(groupName).observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as! [String:Bool]
            self.names = [String](values.keys).sorted()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VoteViewCell

        cell.nameLabel.text = names[indexPath.item]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedNames.count < 2 {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            selectedNames.append(names[indexPath.item])
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        doneButton.isEnabled = selectedNames.count == 2
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        if names.contains(names[indexPath.item]) {
            selectedNames.remove(at: selectedNames.index(of: names[indexPath.item])!)
        }
        
        doneButton.isEnabled = selectedNames.count == 2
    }

    @IBAction func done(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(selectedNames, forKey: groupName)
        navigationController?.popViewController(animated: true)
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
