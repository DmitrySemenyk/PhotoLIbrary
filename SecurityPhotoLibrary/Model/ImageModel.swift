//
//  ImageModel.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 12/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation

class ImageModel: NSObject, Codable {

    var uuid: String
    var name: String?
    var score: Int?
    var time: Int?
    
    public enum CodingKeys: String, CodingKey {
        case uuid, name, score, time
    }
    
    public override init() {
        uuid = UUID.init().uuidString
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String()
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.score = try container.decodeIfPresent(Int.self, forKey: .score)
        self.time = try container.decodeIfPresent(Int.self, forKey: .time)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.time, forKey: .time)
    }
    
}
