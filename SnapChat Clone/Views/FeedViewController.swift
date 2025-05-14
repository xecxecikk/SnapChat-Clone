//
//  FeedViewController.swift
//  SnapChat Clone
//
//  Created by XECE on 9.05.2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth




class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
     
      var snapArray = [Snap]()
      var chosenSnap: Snap?

      override func viewDidLoad() {
          super.viewDidLoad()
          
          // TableView yapılandırması
          tableView.delegate = self
          tableView.dataSource = self
          tableView.rowHeight = UITableView.automaticDimension
          tableView.estimatedRowHeight = 250

          // Önce kullanıcı adı yüklensin, sonra snap'ler çekilsin
          getUserInfo { [weak self] in
              self?.getSnapsFromRealtimeDatabase()
          }
      }

      func getUserInfo(completion: @escaping () -> Void) {
          guard let email = Auth.auth().currentUser?.email else {
              completion()
              return
          }
          let databaseRef = Database.database().reference()
                databaseRef.child("UserInfo").observeSingleEvent(of: .value) { snapshot in
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot,
                           let dict = snap.value as? [String: Any],
                           let userEmail = dict["email"] as? String,
                           let username = dict["username"] as? String,
                           userEmail == email {
                            // Kullanıcı bilgilerini Singleton'a kaydediyoruz
                            UserSingleton.sharedUserInfo.email = userEmail
                            UserSingleton.sharedUserInfo.username = username
                            print("✅ Username yüklendi: \(username)")
                            break
                        }
                    }
                    completion()
                }
            }

            // Realtime Database'den Snap'leri çekme
            func getSnapsFromRealtimeDatabase() {
                let snapsRef = Database.database().reference().child("Snaps")
                snapArray.removeAll()

                snapsRef.observe(.value) { snapshot in
                    self.snapArray.removeAll()
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot,
                           let snapDict = snap.value as? [String: Any],
                           let username = snapDict["snapOwner"] as? String,
                           let imageUrlArray = snapDict["imageUrlArray"] as? [String],
                           let timestamp = snapDict["date"] as? Double {

                            let date = Date(timeIntervalSince1970: timestamp / 1000)
                            let difference = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0

                            if difference < 24 && !username.isEmpty {
                                let snapModel = Snap(username: username, imageUrlArray: imageUrlArray, date: date, timeDifference: 24 - difference)
                                self.snapArray.append(snapModel)
                            } else if difference >= 24 {
                                snapsRef.child(snap.key).removeValue()
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }

            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return snapArray.count
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FeedCell else {
                    return UITableViewCell()
                }
                let snap = snapArray[indexPath.row]
                cell.configure(with: snap)
                return cell
            }

            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                chosenSnap = snapArray[indexPath.row]
                performSegue(withIdentifier: "toSnapVC", sender: nil)
            }

            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "toSnapVC",
                   let destinationVC = segue.destination as? SnapViewController {
                    destinationVC.selectedSnap = chosenSnap
                }
            }
        }
