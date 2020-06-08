//
//  ImagePresent.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 16/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class ImagePresent: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionTextField: UILabel!
    
    var buttonState: Bool = true
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: frame.size))
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    @IBAction func followChange(_ sender: Any?) {
        self.buttonState = !self.buttonState
        self.followIcon(state: self.buttonState)
    }
    
    static func instanceFromNib() -> ImagePresent {
        return UINib(nibName: "ImagePresent", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ImagePresent ?? ImagePresent()
    }
    
    func load(image: UIImage, favorite: Bool, description: String){
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.blue.cgColor
        dropShadow()
        
        self.descriptionTextField.textDropShadow()
        
        self.image.image = image
        self.buttonState = favorite
        self.followIcon(state: favorite)
        self.descriptionTextField.text = description
        
        
        
        self.nibStyle()
    }
    
    func followIcon(state: Bool){
        if state{
            self.favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }else{
            self.favoriteButton.setImage(UIImage(named: "heart_unfollow"), for: .normal)
        }
    }
    
    func nibStyle(){
        self.image.clipsToBounds = true
        self.image.layer.cornerRadius = 20
        layer.cornerRadius = 20
    }

}
