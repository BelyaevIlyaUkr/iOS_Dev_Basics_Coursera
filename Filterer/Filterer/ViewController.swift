//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    
    enum filterColors {
        case red,green,blue,yellow,purple
    }
    
    var selectedFilter:filterColors?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterImageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterView: UIView!
    
    @IBOutlet var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

// Local variable inserted by Swift 4.2 migrator.
//let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        dismiss(animated: true, completion: nil)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage as UIImagePickerController.InfoKey)] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
           
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    
    func filteredImageActivate() {
        view.addSubview(filterView)
    
        let bottomConstraint = filterView.bottomAnchor.constraint(equalTo: secondaryMenu.topAnchor)
        let leftConstraint = filterView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = filterView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let topConstraint = filterView.topAnchor.constraint(equalTo: view.topAnchor)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, topConstraint])
        
        view.layoutIfNeeded()
        
        self.filterView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.filterView.alpha = 1.0
        }
    }
    
    func imageColoring(){
        let image = UIImage(named: "scenery")!
        
        var rgbaImage = RGBAImage(image: image)!
        
        let avgRed = 107
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                
                var pixel = rgbaImage.pixels[index]
                
                let redDelta = Int(pixel.red) - avgRed
                
                
                var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                if (Int(pixel.red) < avgRed) {
                    modifier = 1
                }
                
                pixel.red = UInt8(max(min(255, Int(round(Double(avgRed) + modifier * Double(redDelta)))), 0))
                rgbaImage.pixels[index] = pixel
            }
        }
        
        let result = rgbaImage.toUIImage()
        filterImageView.image = result
    }
    
    @IBAction func hi(sender: UIButton){
        let colorDictionary = ["Red": filterColors.red , "Green": filterColors.green, "Blue": filterColors.blue, "Yellow": filterColors.yellow, "Purple": filterColors.purple]
        
        if selectedFilter == nil { // original image in imageView
            filteredImageActivate()
            imageColoring()
        }
        else if colorDictionary[sender.currentTitle!] == selectedFilter {  // cancel filtering
            
        }
        else { // choose other filter
            
        }
        selectedFilter = colorDictionary[sender.currentTitle!]
        
        
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue as String
}


