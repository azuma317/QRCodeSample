//
//  CameraViewController.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/31.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class CameraViewController: UIViewController {

    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    private lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    private lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer
    }()
    
    private var captureInput: AVCaptureInput!
    private lazy var captureOutput: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()
    
    private var certs: [String:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarcodeCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let room = UserDefaults.standard.object(forKey: "Room") as! String
        Database.database().reference().child("qr").child(room).observeSingleEvent(of: .value) { (snapshot) in
            guard let values = snapshot.value as? [String:Bool] else { return }
            self.certs = values
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        capturePreviewLayer.frame = self.captureView.bounds
    }
    
    private func setupBarcodeCapture() {
        do {
            captureInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(captureInput) {
                captureSession.addInput(captureInput)
            }
            if captureSession.canAddOutput(captureOutput) {
                captureSession.addOutput(captureOutput)
            }
            captureOutput.metadataObjectTypes = captureOutput.availableMetadataObjectTypes
            capturePreviewLayer.frame = self.captureView.bounds
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureView.layer.addSublayer(capturePreviewLayer)
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()
        var detectioinString: String? = nil
        let barcodeTypes = [AVMetadataObject.ObjectType.qr]
        for metadataObject in metadataObjects {
            loop: for barcodeType in barcodeTypes {
                guard metadataObject.type == barcodeType else { continue }
                guard self.capturePreviewLayer.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    detectioinString = object.stringValue
                    break loop
                }
            }
            guard let value = detectioinString else { continue }
            if self.certs[value] ?? false {
                DispatchQueue.main.async {
                    self.setStatus(value)
                    UserDefaults.standard.set(value, forKey: "ID")
                    self.performSegue(withIdentifier: "toGroupView", sender: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.warningLabel.isHidden = false
                }
            }
        }
        self.captureSession.startRunning()
    }
    
    private func setStatus(_ value: String) {
        let room = UserDefaults.standard.object(forKey: "Room") as! String
        Database.database().reference().child("qr").child(room).updateChildValues([value:false])
    }
}
