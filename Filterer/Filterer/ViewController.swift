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
    var originalImage = UIImage(named: "scenery")
    
    var selectedFilter:String?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterImageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterView: UIView!
    
    @IBOutlet var filterButton: UIButton!
    
    @IBOutlet weak var redButton:UIButton!
    @IBOutlet var greenButton:UIButton!
    @IBOutlet var blueButton:UIButton!
    @IBOutlet var yellowButton:UIButton!
    @IBOutlet var purpleButton:UIButton!
    
    func togglingButtons(senderButton:UIButton! = nil) {
        redButton.isSelected = false
        greenButton.isSelected = false
        blueButton.isSelected = false
        yellowButton.isSelected = false
        purpleButton.isSelected = false
        
        if senderButton != nil {
            senderButton.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController:UIActivityViewController
        
        if selectedFilter != nil {
            activityController = UIActivityViewController(activityItems: ["Check out our really cool app", filterImageView.image!], applicationActivities: nil)
        }
        else {
            activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        }
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

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage as UIImagePickerController.InfoKey)] as? UIImage {
            imageView.image = image
            originalImage = image
        }
         dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.isSelected) {
            togglingButtons()
            imageColoring(returnImageViewToOriginalImage: true)
            filteredImageDeactivate()
            hideSecondaryMenu()
            selectedFilter = nil
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
            self.secondaryMenu.alpha = 1
        }
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4,
            animations: {
                self.secondaryMenu.alpha = 0
            },
            completion:  { finished in
                    if finished {
                        self.secondaryMenu.removeFromSuperview()
                    }
            }
        )
    }
    
    
    func filteredImageActivate() {
        filterView.alpha = 0
        
        view.addSubview(filterView)
        
        let bottomConstraint = filterView.bottomAnchor.constraint(equalTo: secondaryMenu.topAnchor)
        
        let leftConstraint = filterView.leftAnchor.constraint(equalTo: view.leftAnchor)
        
        let rightConstraint = filterView.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let topConstraint = filterView.topAnchor.constraint(equalTo: view.topAnchor)
            
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, topConstraint])
            
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1,
            animations: {
                self.view.subviews[self.view.subviews.count - 1].alpha = 1
            }
        )
    }
    
    func imageColoring(returnImageViewToOriginalImage: Bool = false,previousFilter:String? = nil) {
        
        let image = originalImage!
        
        var rgbaImage = RGBAImage(image: image)!
        
        if returnImageViewToOriginalImage {
            let result = rgbaImage.toUIImage()
            imageView.image = result
            return
        }
        
        var selectFilter = ""
        
        if previousFilter == nil {
            selectFilter = self.selectedFilter!
        }
        else{
            selectFilter = previousFilter!
        }
    
        let avgRed = 107,avgGreen = 109,avgBlue = 110
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                
                var pixel = rgbaImage.pixels[index]
                
                let redDelta = Int(pixel.red) - avgRed
                let greenDelta = Int(pixel.green) - avgGreen
                let blueDelta = Int(pixel.blue) - avgBlue
                
                if selectFilter == "Red" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.red) < avgRed) {
                        modifier = 1
                    }
                    
                    pixel.red = UInt8(max(min(255, Int(round(Double(avgRed) + modifier * Double(redDelta)))), 0))
                }
                else if selectFilter == "Green" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.green) < avgGreen) {
                        modifier = 1
                    }
                    pixel.green = UInt8(max(min(255, Int(round(Double(avgGreen) + modifier * Double(greenDelta)))), 0))
                }
                else if selectFilter == "Blue" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.blue) < avgBlue) {
                        modifier = 1
                    }
                    pixel.blue = UInt8(max(min(255, Int(round(Double(avgBlue) + modifier * Double(blueDelta)))), 0))
                }
                else if selectFilter == "Purple" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.green) < avgGreen) {
                        modifier = 1
                    }
                    
                    pixel.green = UInt8(max(min(110, Int(round(Double(avgGreen) + modifier * Double(greenDelta)))), 20))
                }
                else if selectFilter == "Yellow" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.blue) < avgBlue) {
                        modifier = 1
                    }
                    
                    pixel.blue = UInt8(max(min(50, Int(round(Double(avgBlue) + modifier * Double(blueDelta)))),0))
                }
                
                rgbaImage.pixels[index] = pixel
            }
        }
        
        let result = rgbaImage.toUIImage()
        if previousFilter == nil {
            filterImageView.image = result
        }
        else {
            imageView.image = result
        }
    }
    
    
    func filteredImageDeactivate(){
        UIView.animate(withDuration: 1,
            animations: {
                self.view.subviews[self.view.subviews.count - 1].alpha = 0
            },
            completion: {
                finished in
                if finished {self.view.subviews[self.view.subviews.count - 1].removeFromSuperview()}
            }
        )
    }
    
    @IBAction func hi(sender: UIButton){
        
        var previousSelectedFilter = selectedFilter
        selectedFilter = sender.currentTitle!
        
        if previousSelectedFilter == nil { // original image in imageView
            togglingButtons(senderButton: sender)
            imageColoring()
            filteredImageActivate()
        }
        else if sender.currentTitle! == previousSelectedFilter { //cancel filter color
            togglingButtons()
            selectedFilter = nil
            previousSelectedFilter = nil
            imageColoring(returnImageViewToOriginalImage: true)
            filteredImageDeactivate()
        }
        else { // choose other filter
            imageColoring(previousFilter: previousSelectedFilter)
            imageColoring()
            filteredImageActivate()
            togglingButtons(senderButton: sender)
        }
        
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


