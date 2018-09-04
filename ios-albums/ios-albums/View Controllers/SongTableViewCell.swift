//
//  SongTableViewCell.swift
//  ios-albums
//
//  Created by Conner on 9/2/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
  func updateViews() {
    if let song = song {
      songTitleTextView.text = song.title
      songDurationTextView.text = song.duration
      addSongButton.isHidden = true
    }
  }
  
  override func prepareForReuse() {
    songTitleTextView.text = ""
    songDurationTextView.text = ""
    addSongButton.isHidden = false
  }
  
  @IBAction func addSong(_ sender: Any) {
    guard let songTitle = songTitleTextView.text,
      let songDuration = songDurationTextView.text else { return }
    delegate?.addSong(with: songTitle, duration: songDuration)
  }
  
  @IBOutlet var songTitleTextView: UITextField!
  @IBOutlet var songDurationTextView: UITextField!
  @IBOutlet var addSongButton: UIButton!
  
  var song: Song? {
    didSet {
      updateViews()
    }
  }
  
  weak var delegate: SongTableViewCellDelegate?
}

protocol SongTableViewCellDelegate: class {
  func addSong(with title: String, duration: String)
}
