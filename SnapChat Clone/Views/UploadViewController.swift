//
//  UploadViewController.swift
//  SnapChat Clone
//
//  Created by XECE on 9.05.2025.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    
    var isUserLoaded = false

       override func viewDidLoad() {
           super.viewDidLoad()
           
           uploadImage.isUserInteractionEnabled = true
           let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
           uploadImage.addGestureRecognizer(gestureRecognizer)
           
           // Kullanıcı bilgilerini yükle
           getUserInfo { [weak self] in
               self?.isUserLoaded = true
               print("✅ Kullanıcı yüklendi: \(UserSingleton.sharedUserInfo.username)")
           }
       }

       // Resim seçme fonksiyonu
       @objc func choosePicture() {
           let picker = UIImagePickerController()
           picker.delegate = self
           picker.sourceType = .photoLibrary
           present(picker, animated: true, completion: nil)
       }

       // Resim seçildikten sonra işlemler
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           uploadImage.image = info[.originalImage] as? UIImage
           dismiss(animated: true, completion: nil)
       }
    
    @IBAction func uploadBttn(_ sender: Any) {
        // Kullanıcı bilgileri yüklenmediyse işlem yapılmasın
               guard isUserLoaded else {
                   makeAlert(title: "Yükleniyor", message: "Kullanıcı bilgileri henüz alınmadı.")
                   return
               }
               
               // Kullanıcı adı boşsa hata mesajı göster
               guard !UserSingleton.sharedUserInfo.username.isEmpty else {
                   makeAlert(title: "Hata", message: "Kullanıcı adı boş. Tekrar giriş yapmayı deneyin.")
                   return
               }
               
               // Seçilen resim yoksa hata mesajı göster
               guard let data = uploadImage.image?.jpegData(compressionQuality: 0.5) else {
                   makeAlert(title: "Hata", message: "Resim seçilmedi.")
                   return
               }

               // Resmi Firebase Storage'a yükle
               let uuid = UUID().uuidString
               let imageReference = Storage.storage().reference().child("media").child("\(uuid).jpg")
               
               imageReference.putData(data, metadata: nil) { [weak self] metadata, error in
                   guard let self = self else { return }
                   
                   if let error = error {
                       self.makeAlert(title: "Yükleme Hatası", message: error.localizedDescription)
                       return
                   }
                   
                   // Resim URL'si alındıktan sonra veritabanına kaydet
                   imageReference.downloadURL { url, error in
                       if let error = error {
                           self.makeAlert(title: "URL Hatası", message: error.localizedDescription)
                           return
                       }
                       
                       guard let imageUrl = url?.absoluteString else { return }
                       self.saveSnapToDatabase(imageUrl: imageUrl)
                   }
               }
           }

           // Veritabanına snap kaydetme fonksiyonu
           private func saveSnapToDatabase(imageUrl: String) {
               let databaseRef = Database.database().reference()
               let username = UserSingleton.sharedUserInfo.username
               let snapsRef = databaseRef.child("Snaps")

               // Kullanıcının daha önce yüklediği snap'leri kontrol et
               snapsRef.queryOrdered(byChild: "snapOwner").queryEqual(toValue: username).observeSingleEvent(of: .value) { snapshot in
                   if snapshot.exists() {
                       // Var olan snap'lere yeni resmi ekle
                       for child in snapshot.children {
                           if let snap = child as? DataSnapshot,
                              var snapDict = snap.value as? [String: Any],
                              var imageUrlArray = snapDict["imageUrlArray"] as? [String] {
                               imageUrlArray.append(imageUrl)
                               snapDict["imageUrlArray"] = imageUrlArray
                               
                               snapsRef.child(snap.key).setValue(snapDict) { error, _ in
                                   if error == nil {
                                       self.uploadCompleted()
                                   } else {
                                       self.makeAlert(title: "Hata", message: error!.localizedDescription)
                                   }
                               }
                           }
                       }
                   } else {
                       // İlk kez snap yükleniyorsa yeni bir snap kaydet
                       let snapDict: [String: Any] = [
                           "imageUrlArray": [imageUrl],
                           "snapOwner": username,
                           "date": ServerValue.timestamp()
                       ]
                       
                       snapsRef.childByAutoId().setValue(snapDict) { error, _ in
                           if error == nil {
                               self.uploadCompleted()
                           } else {
                               self.makeAlert(title: "Hata", message: error!.localizedDescription)
                           }
                       }
                   }
               }
           }

           // Yükleme tamamlandığında yapılacak işlemler
           private func uploadCompleted() {
               self.tabBarController?.selectedIndex = 0
               self.uploadImage.image = UIImage(named: "select.png")  // Resim ikonunu sıfırlama
           }

           // Kullanıcı bilgilerini Realtime Database'den almak
           private func getUserInfo(completion: @escaping () -> Void) {
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

           // Hata mesajlarını gösterme fonksiyonu
           private func makeAlert(title: String, message: String) {
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               let okButton = UIAlertAction(title: "OK", style: .default)
               alert.addAction(okButton)
               present(alert, animated: true)
           }
       }
