//
//  Album.swift
//  ios-albums
//
//  Created by Conner on 9/2/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
  static func == (lhs: Album, rhs: Album) -> Bool {
    return lhs.id == rhs.id
  }
  
  var artist: String
  var coverArt: [String]
  var genres: [String]
  var id: String
  var name: String
  var songs: [Song]

  enum AlbumCodingKeys: String, CodingKey {
    case artist
    case coverArt
    case genres
    case id
    case name
    case songs

    enum AlbumDetailCodingKeys: String, CodingKey {
      case url
      case genre
    }
  }
  
  init(artist: String,
       coverArt: [String],
       genres: [String],
       id: String,
       name: String,
       songs: [Song]) {
    self.artist = artist
    self.coverArt = coverArt
    self.genres = genres
    self.id = id
    self.name = name
    self.songs = songs
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AlbumCodingKeys.self)
    let artist = try container.decode(String.self, forKey: .artist)
    let id = try container.decode(String.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)

    var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
    var coverArtURLs: [String] = []

    while !coverArtContainer.isAtEnd {
      let coverArt = try coverArtContainer.nestedContainer(keyedBy: AlbumCodingKeys.AlbumDetailCodingKeys.self)
      let coverArtURL = try coverArt.decode(String.self, forKey: .url)
      coverArtURLs.append(coverArtURL)
    }

    var genreContainer = try container.nestedUnkeyedContainer(forKey: .genres)
    var genres: [String] = []

    while !genreContainer.isAtEnd {
      let genre = try genreContainer.decode(String.self)
      genres.append(genre)
    }

    var songContainer = try container.nestedUnkeyedContainer(forKey: .songs)
    var songs: [Song] = []

    while !songContainer.isAtEnd {
      let song = try songContainer.decode(Song.self)
      songs.append(song)
    }

    self.artist = artist
    self.id = id
    self.name = name
    self.coverArt = coverArtURLs
    self.genres = genres
    self.songs = songs
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: AlbumCodingKeys.self)
    try container.encode(artist, forKey: .artist)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)

    var coverArtItemsContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
    for coverArtItem in coverArt {
      var coverArtItemContainer = coverArtItemsContainer.nestedContainer(keyedBy: AlbumCodingKeys.AlbumDetailCodingKeys.self)
      try coverArtItemContainer.encode(coverArtItem, forKey: .url)
    }

    var genreContainer = container.nestedUnkeyedContainer(forKey: .genres)
    for genre in genres {
      try genreContainer.encode(genre)
    }

    var songContainer = container.nestedUnkeyedContainer(forKey: .songs)
    for song in songs {
      try songContainer.encode(song)
    }
  }
}

struct Song: Codable {
  let duration: String
  let id: String
  let title: String

  enum SongCodingKeys: String, CodingKey {
    case id
    case duration
    case name

    enum SongDetailsCodingKeys: String, CodingKey {
      case duration
      case title
    }
  }
  
  init(duration: String, id: String, title: String) {
    self.duration = duration
    self.id = id
    self.title = title
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: SongCodingKeys.self)
    let id = try container.decode(String.self, forKey: .id)

    let durationContainer = try container.nestedContainer(keyedBy: SongCodingKeys.SongDetailsCodingKeys.self, forKey: .duration)
    let duration = try durationContainer.decode(String.self, forKey: .duration)

    let nameContainer = try container.nestedContainer(keyedBy: SongCodingKeys.SongDetailsCodingKeys.self, forKey: .name)
    let title = try nameContainer.decode(String.self, forKey: .title)

    self.id = id
    self.duration = duration
    self.title = title
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: SongCodingKeys.self)
    try container.encode(id, forKey: .id)

    var durationContainer = container.nestedContainer(keyedBy: SongCodingKeys.SongDetailsCodingKeys.self, forKey: .duration)
    try durationContainer.encode(duration, forKey: .duration)

    var nameContainer = container.nestedContainer(keyedBy: SongCodingKeys.SongDetailsCodingKeys.self, forKey: .name)
    try nameContainer.encode(title, forKey: .title)
  }
}
