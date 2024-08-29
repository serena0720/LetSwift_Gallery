//
//  VideoItem.swift
//  LetSwift_gallery
//
//  Created by Hyun A Song on 8/26/24.
//

import Foundation

struct Conference: Decodable {
  let year: Int
  let items: [VideoItem]
}

struct VideoItem: Decodable, Identifiable {
  let id = UUID()
  let title: String
  let speaker: String
  let timeLine: String
  let referenceLink: String
  let thumbnail: String
  let videoID: String
}
