//
//  ImagesCollectionViewCell.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 05/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

protocol ImagesDelegate: AnyObject {
    func setData(count: Int, _ favorite: Bool, _ descriptionText: String)
    func getIndex(indexPath: IndexPath)
}

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topHeaderConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomFooterConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var presentImageView: UIView!
    @IBOutlet weak var descriptionImageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favorite: Bool = false
    var indexPath: IndexPath?
    var index: Int = 1
    weak var delegate: ImagesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let longPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(longPress))
        let tapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        
        favoriteButton.addTarget(self, action: #selector(changeState(button:)), for: .touchUpInside)
        
        topHeaderConstrain.constant -= headerView.frame.size.height
        bottomFooterConstrain.constant -= footerView.frame.size.height
        
        descriptionTextField.delegate = self
        descriptionTextField.isHidden = true
        descriptionImageLabel.isUserInteractionEnabled = true
        descriptionImageLabel.addGestureRecognizer(longPressRecognizer)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapPressRecognizer)
        
        
        
    }
    
    func setState(indexPath: IndexPath, image: UIImage, favorite: Bool, descriptionText: String){
        self.indexPath = indexPath
        self.favorite = favorite
        imageView.image = image
        changeState(self.favorite)
        descriptionImageLabel.text = descriptionText
    }
    
    @IBAction func longPress(){
        descriptionImageLabel.isHidden = true
        descriptionTextField.isHidden = false
        
        descriptionTextField.text = descriptionImageLabel.text
    }
    
    @IBAction func tapPressed(){
        if self.topHeaderConstrain.constant > 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.topHeaderConstrain.constant -= self.headerView.frame.size.height
                self.bottomFooterConstrain.constant -= self.footerView.frame.size.height
                self.layoutIfNeeded()
            }) { (_) in
                print("Done")
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.topHeaderConstrain.constant = 5
                self.bottomFooterConstrain.constant = 5
                self.layoutIfNeeded()
            }) { (_) in
//                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
//                    UIView.animate(withDuration: 0.3, animations: {
//                        self.topHeaderConstrain.constant -= self.headerView.frame.size.height
//                        self.bottomFooterConstrain.constant -= self.footerView.frame.size.height
//                        self.layoutIfNeeded()
//                    }) { (_) in
//                        print("Done")
//                    }
//                }
                
                
            }
            
            
        }
    }
    
    @IBAction func changeState(button: UIButton){
        favorite = !favorite
        changeState(favorite)
        
        self.delegate?.setData(count: indexPath!.item, favorite, descriptionImageLabel.text!)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        if frame.origin.y == 0{
            frame.origin.y -= keyboardFrame.height
        }

    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        if frame.origin.y != 0{
            frame.origin.y += keyboardFrame.height
        }

    }
    
    func changeState(_ favorite: Bool){
        if !favorite {
            favoriteButton.setImage(UIImage(named: "heart_unfollow"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }

}

extension ImagesCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        print("Start")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End")
        descriptionImageLabel.text = textField.text
        descriptionTextField.isHidden = true
        descriptionImageLabel.isHidden = false
        self.delegate?.setData(count: indexPath!.item, favorite, descriptionImageLabel.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

