//
//  Image500px.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation

//    "name": "Orange or lemon",
//    "description": "",
//    "times_viewed": 709,
//    "rating": 97.4,
//    "created_at": "2012-02-09T02:27:16-05:00",
//    "category": 0,
//    "privacy": false,
//    "width": 472,
//    "height": 709,
//    "votes_count": 88,
//    "comments_count": 58,
//    "nsfw": false,
//    "image_url": "http://pcdn.500px.net/4910421/c4a10b46e857e33ed2df35749858a7e45690dae7/2.jpg"

struct Image500px {
    let id: Int
    let name: String
    let description: String?
    let timesViewed: Int
    let rating: Float
    let created_at: Date
    let category: API500px.Category
    let privacy: Bool
    let origWidth: Int
    let origHeight: Int
    let curSize: API500px.ImageSize
    let votesCount: Int
    let commentsCount: Int
    let nsfw: Bool
    let imageURL: String
    let feature: API500px.Feature
}
