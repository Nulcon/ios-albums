//
//  AlbumController.swift
//  ios-albums
//
//  Created by Conner on 9/3/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation


class AlbumController {
  func getAlbums(completion: @escaping (Error?) -> Void) {
    let url = AlbumController.baseURL.appendingPathExtension("json")
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: url) { (data, _, error) in
      if let error = error {
        NSLog("Error GET albums: \(error)")
        return
      }
      
      if let data = data {
        do {
          let decoder = JSONDecoder()
          let albums = try decoder.decode([String: Album].self, from: data)
          self.albums = albums.compactMap { $0.value }
          completion(nil)
        } catch let error {
          NSLog("Error decoding data from GET: \(error)")
        }
      }
    }.resume()
  }
  
  func put(album: Album) {
    let url = AlbumController.baseURL.appendingPathComponent(album.id).appendingPathExtension("json")
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "PUT"
    
    do {
      let encoder = JSONEncoder()
      urlRequest.httpBody = try encoder.encode(album)
    } catch {
      NSLog("Error with encoding album: \(error)")
    }
    
    URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
      if let error = error {
        NSLog("Error with PUTting albums: \(error)")
        return
      }

    }.resume()
  }
  
  func createAlbum(artist: String,
                   coverArt: [String],
                   genres: [String],
                   id: String,
                   name: String,
                   songs: [Song]) {
    let album = Album(artist: artist,
                      coverArt: coverArt,
                      genres: genres,
                      id: id,
                      name: name,
                      songs: songs)
    albums.append(album)
    put(album: album)
  }
                   
  func createSong(duration: String, title: String) -> Song {
    return Song(duration: duration, id: UUID().uuidString, title: title)
  }
  
  func update(album: Album,
              artist: String,
              coverArt: [String],
              genres: [String],
              id: String,
              name: String,
              songs: [Song]) {
    if let index = albums.index(of: album) {
      var scratch = album
      scratch.artist = artist
      scratch.coverArt = coverArt
      scratch.genres = genres
      scratch.id = id
      scratch.name = name
      scratch.songs = songs
      
      albums.remove(at: index)
      albums.insert(scratch, at: index)
      put(album: scratch)
    }
  }
  
  static let baseURL = URL(string: "https://ios-albums.firebaseio.com/")!
  var albums: [Album] = []
}
