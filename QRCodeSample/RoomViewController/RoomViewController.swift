//
//  RoomViewController.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/30.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class RoomViewController: UITableViewController {
    
    var isOwner = UserDefaults.standard.bool(forKey: "Admin")
    @IBOutlet weak var addRoomButton: UIBarButtonItem!
    
    var rooms: [String] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "RoomViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        ref = Database.database().reference()
        ref.child("rooms").observe(.value) { (snapshot) in
            guard let values = snapshot.value as? [String:Bool] else { return }
            self.rooms = [String](values.keys)
            self.tableView.reloadData()
        }
        
        addRoomButton.isEnabled = isOwner
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RoomViewCell
        
        cell.roomLabel.text = rooms[indexPath.item]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(rooms[indexPath.item], forKey: "Room")
        if isOwner {
            performSegue(withIdentifier: "toResultView", sender: nil)
        } else {
            performSegue(withIdentifier: "toCameraView", sender: nil)
        }
    }

    @IBAction func addRoom(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "新規追加", message: "投票のグループを作ります", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let doneAction = UIAlertAction(title: "追加", style: .default) { (_) in
            let textField = alert.textFields?.first
            if textField?.text?.count ?? 0 > 0 {
                let name = textField!.text!
                Database.database().reference().child("rooms").updateChildValues([name:true])
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
