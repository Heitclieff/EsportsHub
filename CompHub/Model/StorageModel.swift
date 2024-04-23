//
//  StorageModel.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 28/3/2567 BE.
//

import Foundation
import Firebase
import FirebaseStorage

struct  Org : Identifiable {
    var id : String?
    var title : String
    var image : String
}


class OrgViewModel: ObservableObject {
    @Published var org : [Org] = []
    
    init() {
        fetchEvents()
    }
    
    private var db = Firestore.firestore()
    
    func fetchEvents() {
        let db = Firestore.firestore()
        let docRef = db.collection("events")

        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()

                    let doc_id = document.documentID as String
                    let title = data["title"] as? String ?? ""
                    let image = data["image"] as? String ?? ""
                    let item = Org(id: doc_id , title: title , image: image)
                    
                    self.org.append(item)
                }
            }
        }
    }
    
    
    func uploadFiles(fileURL: Data?, path : String ,completion: @escaping (URL?) -> Void) {
                if fileURL == nil { completion(nil) }
            
                if let fileURL,
                     let uiImage = UIImage(data: fileURL) {
                        guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else{ return }
                    
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let imageRef = storageRef.child("\(path)/\(UUID().uuidString).jpg")
                        let metadata  = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                    
                        _ = imageRef.putData(imageData, metadata: metadata) { metadata, error in
                            if let error = error {
                                print("Error uploading image: \(error.localizedDescription)")
                                return
                            }
                            imageRef.downloadURL { url, error in
                                if let error = error {
                                    print("Error getting download URL: \(error.localizedDescription)")
                                    return
                                }
                                completion(url)
                            }
                        }
                }
    }
    
}
