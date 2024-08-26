//
//  VideoItem.swift
//  LetSwift_gallery
//
//  Created by Hyun A Song on 8/26/24.
//

import Foundation

struct VideoItem: Decodable, Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let thumbnails: Thumbnail
  let resourceId: ResourceId
}

struct Thumbnail: Decodable {
  let medium: ThumbnailDetails
}

struct ThumbnailDetails: Decodable {
  let url: String
  let width: Int
  let height: Int
}

struct ResourceId: Decodable {
  let videoId: String
}

struct VideoData: Decodable {
  let year: Int
  let items: [VideoItem]
}
