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
    @IBOutlet var sliderView: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterView: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet weak var redButton:UIButton!
    @IBOutlet var greenButton:UIButton!
    @IBOutlet var blueButton:UIButton!
    @IBOutlet var yellowButton:UIButton!
    @IBOutlet var purpleButton:UIButton!
    
    @IBOutlet var originalImageLabel: UILabel!
    @IBOutlet var minSliderLabel:UILabel!
    @IBOutlet var maxSliderLabel:UILabel!
    
    @IBOutlet var intensitySlider: UISlider!
    
    func togglingButtons(senderButton:UIButton! = nil) {
        redButton.isSelected = false
        greenButton.isSelected = false
        blueButton.isSelected = false
        yellowButton.isSelected = false
        purpleButton.isSelected = false
        
        if senderButton != nil {
            senderButton.isSelected = true
            originalImageLabel.isHidden = false
            compareButton.isSelected = false
            compareButton.isEnabled = true
            editButton.isSelected = false
            editButton.isEnabled = true
        }
        else {
            compareButton.isSelected = false
            compareButton.isEnabled = false
            editButton.isSelected = false
            editButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false
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
        if sender.isSelected {
            sender.isSelected = false
            if editButton.isSelected {
                hideSlider()
            }
            togglingButtons()
            hideSecondaryMenu()
            imageColoring(returnImageViewToOriginalImage: true)
            filteredImageDeactivate()
            selectedFilter = nil
        } else {
            sender.isSelected = true
            selectedFilter = "Red"
            togglingButtons(senderButton: redButton)
            imageColoring()
            showSecondaryMenu()
            compareButton.isEnabled = true
            originalImageLabel.isHidden = true
            filteredImageActivate()
        }
    }
    
    func showSecondaryMenu() {
        
        secondaryMenu.isHidden = false
        secondaryMenu.isUserInteractionEnabled = true
        
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 55)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.8) {
            self.secondaryMenu.alpha = 1
        }
       
    }
    
    func showSlider(){
        view.addSubview(sliderView)

        let bottomConstraint = sliderView.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = sliderView.heightAnchor.constraint(equalToConstant: 69)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            self.sliderView.alpha = 1
        }
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.8,
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
    
    func hideSlider(){
        UIView.animate(withDuration: 0.8,
            animations: {
                self.sliderView.alpha = 0
            },
            completion:  { finished in
                    if finished {
                        self.sliderView.removeFromSuperview()
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
        
        UIView.animate(withDuration: 0.8,
            animations: {
                self.filterView.alpha = 1
            }
        )
    }
    
    func imageColoring(returnImageViewToOriginalImage: Bool = false,previousFilter:String? = nil,redColor: Int = 127,greenColor: Int = 127,blueColor: Int = 127,yellowColor: Int = 55, purpleColor: Int = 65) {
        
        let image = originalImage!
        
        var rgbaImage = RGBAImage(image: image)!
        
        if returnImageViewToOriginalImage {
            let result = rgbaImage.toUIImage()
            imageView.image = result
            originalImageLabel.isHidden = false
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
                    
                    let valueForColoring = min(255, Int(round(Double(avgRed) + modifier * Double(redDelta))))
                    
                    pixel.red = UInt8(max(valueForColoring, redColor))
                }
                else if selectFilter == "Green" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.green) < avgGreen) {
                        modifier = 1
                    }
                    
                    let valueForColoring = min(255, Int(round(Double(avgGreen) + modifier * Double(greenDelta))))
                    
                    pixel.green = UInt8(max(valueForColoring, greenColor))
                }
                else if selectFilter == "Blue" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.blue) < avgBlue) {
                        modifier = 1
                    }
                    
                    let valueForColoring = min(255, Int(round(Double(avgBlue) + modifier * Double(blueDelta))))
                    
                    pixel.blue = UInt8(max(valueForColoring, blueColor))
                }
                else if selectFilter == "Purple" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.green) < avgGreen) {
                        modifier = 1
                    }
                    
                    let valueForColoring = min(purpleColor, Int(round(Double(avgGreen) + modifier * Double(greenDelta))))
                    
                    pixel.green = UInt8(max(Float(valueForColoring), 0))
                }
                else if selectFilter == "Yellow" {
                    var modifier = 1 + 4 * (Double(y)/Double(rgbaImage.height))
                    if (Int(pixel.blue) < avgBlue) {
                        modifier = 1
                    }
                    
                    let valueForColoring = min(yellowColor, Int(round(Double(avgBlue) + modifier * Double(blueDelta))))
                    
                    pixel.blue = UInt8(max(valueForColoring, 0))
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
        UIView.animate(withDuration: 0.8,
            animations: {
                self.filterView.alpha = 0
            },
            completion: {
                finished in
                if finished {
                    self.filterView.removeFromSuperview()
                
                }
            }
        )
    }
    
    @IBAction func compare(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            originalImageLabel.isHidden = true
            
            UIView.animate(withDuration: 1.5,
                animations: {
                    self.filterView.alpha = 1
                }
            )
            
        }
        else {
            sender.isSelected = true
            originalImageLabel.isHidden = true
            
            UIView.animate(withDuration: 1.5,
                animations: {
                    self.filterView.alpha = 0
                }
            )
            
            imageColoring(returnImageViewToOriginalImage: true)
        }
    }
    
    @IBAction func touchFilteredImage(_ gesture: UILongPressGestureRecognizer){
        
        switch gesture.state {
        case .began:
            UIView.animate(
                withDuration: 0.8,
                animations: {
                    self.filterView.alpha = 0
                }
            )
            imageColoring(returnImageViewToOriginalImage: true)
       
        default:
            UIView.animate(
                withDuration: 0.8,
                animations: {
                    self.filterView.alpha = 1
                }
            )
        }
    }
    
    @IBAction func editButtonTouched(sender: UIButton!) {
        if !sender.isSelected {
            sender.isSelected = true
            secondaryMenu.isHidden = true
            secondaryMenu.isUserInteractionEnabled = false
            
            switch selectedFilter {
            case "Yellow","Purple":
                minSliderLabel!.text = "max"
                maxSliderLabel!.text = "min"
                intensitySlider.minimumValue = 0
                intensitySlider.maximumValue = 130
                intensitySlider.value = 65
            default:
                minSliderLabel!.text = "min"
                maxSliderLabel!.text = "max"
                intensitySlider.minimumValue = 0
                intensitySlider.maximumValue = 255
                intensitySlider.value = 127
            }
            
            showSlider()
        }
        else {
            sender.isSelected = false
            hideSlider()
            secondaryMenu.isHidden = false
            secondaryMenu.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider){
        let colorIntensity = Int(round(sender.value))
        
        switch selectedFilter {
        case "Red":
            imageColoring(redColor: colorIntensity)
        case "Green":
            imageColoring(greenColor: colorIntensity)
        case "Blue":
            imageColoring(blueColor: colorIntensity)
        case "Yellow":
            imageColoring(yellowColor: colorIntensity)
        default:
            imageColoring(purpleColor: colorIntensity)
        }
    }
    
    @IBAction func hi(sender: UIButton){
        
        var previousSelectedFilter = selectedFilter
        selectedFilter = sender.currentTitle!
        
        if previousSelectedFilter == nil { // original image in imageView
            togglingButtons(senderButton: sender)
            imageColoring()
            filteredImageActivate()
            compareButton.isEnabled = true
            originalImageLabel.isHidden = true
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
            compareButton.isSelected = false
            originalImageLabel.isHidden = true
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


