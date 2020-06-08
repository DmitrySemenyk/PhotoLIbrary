//
//  UserImageClass.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 16/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
import UIKit

class UserImageClass: NSObject, Codable {
    var uuid: String?
    var imagePath: URL?
    var name: String?
    var favorite: Bool?
    var descriptionImage: String?
    
    public enum CodingKeys: String, CodingKey {
        case uuid, imagePath, name, favorite, descriptionImage
    }

    public override init() {
        self.descriptionImage = nil
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        self.imagePath = try container.decodeIfPresent(URL.self, forKey: .imagePath)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite)
        self.descriptionImage = try container.decodeIfPresent(String.self, forKey: .descriptionImage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.imagePath, forKey: .imagePath)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.favorite, forKey: .favorite)
        try container.encode(self.descriptionImage, forKey: .descriptionImage)
    }
}
