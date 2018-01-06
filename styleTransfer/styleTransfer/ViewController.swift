//
//  ViewController.swift
//  styleTransfer
//
//  Created by njindal on 1/4/18.
//  Copyright © 2018 adobe. All rights reserved.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var styleImageView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var outputImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var isStyleImage = false
    let url = "http://nipun-precision-t1700.corp.adobe.com:9000/stylize"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        activityIndicator.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loadStyleImage(_ sender: Any) {
        self.checkPermission()
        isStyleImage = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loadContentImage(_ sender: Any) {
        self.checkPermission()
        isStyleImage = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if isStyleImage {
                styleImageView.image = pickedImage
            } else {
                contentImageView.image = pickedImage
                // stylize
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                Stylize.stylize(withStyleImage: styleImageView.image, andContentImage: contentImageView.image, withOutputImage: { (image: UIImage?) in
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.outputImageView.image = image
                    }
                })
            }
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}

