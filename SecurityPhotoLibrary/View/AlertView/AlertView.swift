//
//  AlertView.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 13/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet weak var notificationView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        styleInit(frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    static func instanceFromNib() -> AlertView {
        return UINib(nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? AlertView ?? AlertView()
    }
    
   
    
}

private extension AlertView {
    func styleInit(_ frameD: CGRect){
        frame = frameD
        backgroundColor = UIColor.clear
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.layer.cornerRadius = 10
        notificationView.layer.backgroundColor = UIColor.red.cgColor

    }
}
