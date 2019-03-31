//
//  GroupViewController.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/29.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class GroupViewController: UICollectionViewController {
    
    let group = ["A", "B", "C", "D"]
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var voteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UINib(nibName: "GroupViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        flowLayout.itemSize = CGSize(width: (collectionView.bounds.width - 42) / 2.0, height: (collectionView.bounds.width - 42) / 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "A") != nil &&
            UserDefaults.standard.object(forKey: "B") != nil &&
            UserDefaults.standard.object(forKey: "C") != nil &&
            UserDefaults.standard.object(forKey: "D") != nil {
            voteButton.isEnabled = true
        }
        collectionView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VoteViewController
        vc.groupName = sender as? String
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return group.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupViewCell
    
        cell.groupLabel.text = group[indexPath.item]
        let names = UserDefaults.standard.object(forKey: group[indexPath.item]) as? [String]
        if names != nil {
            cell.vote1Label.text = names?[0]
            cell.vote2Label.text = names?[1]
        } else {
            cell.vote1Label.text = ""
            cell.vote2Label.text = ""
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toVoteView", sender: group[indexPath.item])
    }

    @IBAction func vote(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "投票", message: "", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "投票する", style: .default) { (_) in
            let id = UserDefaults.standard.object(forKey: "ID") as! String
            for room in self.group {
                self.vote(id: id, group: room)
                UserDefaults.standard.removeObject(forKey: room)
                self.dismiss(animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func vote(id: String, group: String) {
        if let names = UserDefaults.standard.object(forKey: group) as? [String], let room = UserDefaults.standard.object(forKey: "Room") as? String {
            for name in names {
                Database.database().reference().child("vote").child(room).child(group).child(name).updateChildValues([id:true])
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
