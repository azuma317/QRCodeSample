//
//  PDFViewController.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/04/04.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import CoreImage
import PDFKit
import FirebaseDatabase

class PDFViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let room = UserDefaults.standard.object(forKey: "Room") as! String
        ref = Database.database().reference().child("qr").child(room)
    }
    
    @IBAction func pdfAction(_ sender: Any) {
        let alert = UIAlertController(title: "QRコードを生成しますか？", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        let done = UIAlertAction(title: "生成", style: .default) { (_) in
            let textField = alert.textFields!.first!
            guard let count = Int(textField.text!) else { return }
            self.createPDF(count: count)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(done)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func createPDF(count: Int) {
        guard let path = Bundle.main.path(forResource: "Sample", ofType: "pdf") else { return }
        let pdfURL = URL(fileURLWithPath: path)
        guard let document = PDFDocument(url: pdfURL) else { return }
        for i in 0..<count {
            let random = randomString(length: 12)
            ref.updateChildValues([random:true])
            let randomData = random.data(using: String.Encoding.utf8)!
            let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": randomData, "inputCorrectionLevel": "M"])!
            let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
            let qrImage = qr.outputImage!.transformed(by: sizeTransform)
            let image = UIImage(ciImage: qrImage)
            guard let page = PDFPage(image: image) else { return }
            document.insert(page, at: i+1)
        }
        let data = document.dataRepresentation()!
        let activityItems = ["QRCode", data] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
