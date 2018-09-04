//
//  AlbumsTableViewController.swift
//  ios-albums
//
//  Created by Conner on 9/2/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    albumController.getAlbums(completion: { (error) in
      if let error = error {
        NSLog("Error getting albums in tableview \(error)")
      }

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    })
  }

  override func viewWillAppear(_ animated: Bool) {
    albumController.getAlbums(completion: { (error) in
      if let error = error {
        NSLog("Error getting albums in tableview \(error)")
      }

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    })
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albumController.albums.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
    cell.detailTextLabel?.text = albumController.albums[indexPath.row].artist
    cell.textLabel?.text = albumController.albums[indexPath.row].name
    return cell
  }

  // MARK: - Navigation/Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "AddAlbumSegue":
      if let vc = segue.destination as? AlbumDetailTableViewController {
        vc.albumController = albumController
      }
    case "ShowAlbumDetailSegue":
      if let vc = segue.destination as? AlbumDetailTableViewController {
        vc.albumController = albumController
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        vc.album = albumController.albums[indexPath.row]
      }
    default: break
    }
  }

  var albumController = AlbumController()

}
