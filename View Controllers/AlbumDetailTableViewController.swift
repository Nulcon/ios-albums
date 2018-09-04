//
//  AlbumDetailTableViewController.swift
//  ios-albums
//
//  Created by Conner on 9/2/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    updateViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    updateViews()
  }
  
  func updateViews() {
    guard isViewLoaded else { return }
    title = "New Album"
    guard let albumName = albumNameTextField,
      let artistName = artistNameTextField,
      let genres = genresTextField,
      let coverArt = coverArtTextField,
      let album = album else { return }
    
    albumController?.getAlbums(completion: { (error) in
      if let error = error {
        NSLog("Error getting album details: \(error)")
      }
    })
    
    title = album.name
    albumName.text = album.name
    artistName.text = album.artist
    genres.text = album.genres.joined(separator: ", ")
    coverArt.text = album.coverArt.joined(separator: ", ")
    tempSongs = album.songs
  }
  
  func addSong(with title: String, duration: String) {
    if let song = albumController?.createSong(duration: duration, title: title) {
      tempSongs.append(song)
      tableView.reloadData()
      tableView.scrollToRow(at: [0, tempSongs.count], at: .bottom, animated: true)
    }
  }
  
  @IBAction func save(_ sender: Any) {
    guard let albumName = albumNameTextField.text,
      let artistName = artistNameTextField.text,
      let genres = genresTextField.text,
      let coverArt = coverArtTextField.text else { return }
    
    if let album = album {
      albumController?.update(album: album, artist: artistName, coverArt: [coverArt], genres: [genres], id: album.id, name: albumName, songs: tempSongs)
    } else {
      albumController?.createAlbum(artist: artistName, coverArt: [coverArt], genres: [genres], id: UUID().uuidString, name: albumName, songs: tempSongs)
    }
    
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tempSongs.count + 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row > tempSongs.count-1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
      cell.delegate = self
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
      cell.delegate = self
      cell.song = tempSongs[indexPath.row]
      return cell
    }
  }
  
  @IBOutlet var albumNameTextField: UITextField!
  @IBOutlet var artistNameTextField: UITextField!
  @IBOutlet var genresTextField: UITextField!
  @IBOutlet var coverArtTextField: UITextField!
  
  var albumController: AlbumController?
  var album: Album? {
    didSet {
      updateViews()
    }
  }
  var tempSongs: [Song] = []
}
