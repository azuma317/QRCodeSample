//
//  ResultViewController.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/30.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class ResultViewController: UITableViewController {
    
    var ref: DatabaseReference!
    
    let room = UserDefaults.standard.object(forKey: "Room") as! String
    var group: [String] = ["A", "B", "C", "D"]
    var results: [String:[String:[String:Bool]]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ResultViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        ref = Database.database().reference()
        ref.child("vote").child(room).observe(.value) { (snapshot) in
            let values = snapshot.value as? [String:[String:[String:Bool]]]
            self.results = values ?? [:]
            
            var count = 0
            if let results = self.results["A"] {
                for value in results.values {
                    count += value.count
                }
            }
            self.navigationItem.title = "結果(\(count/2)人中)"
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return group.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return group[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results[group[section]]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ResultViewCell

        let names = [String](results[group[indexPath.section]]!.keys)
        cell.nameLabel.text = names[indexPath.item]
        let count = results[group[indexPath.section]]?[names[indexPath.item]]?.count ?? 0
        cell.resultLabel.text = String(count)

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
