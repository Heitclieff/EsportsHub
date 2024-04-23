//
//  AccountModel.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 5/4/2567 BE.
//

import Foundation
import Firebase
import FirebaseStorage

struct Account : Identifiable {
    var id : String
    var name : String
    var image : String
    var email : String
}


struct updateResponse {
    var response : Response
    var downloadURL : String
}

struct Response {
    var success : Bool
    var error : String
}

struct AccEvent  : Identifiable {
    var id : String
    var account : Account
    var myevents: [EventTask]
}



let GuideAccount = AccEvent(
    id : "abc",
    account : Account(
        id : "HRIo2hP8uQlTk17JVee9" ,
        name : "Heitcleiff" ,
        image : "https://i.pinimg.com/736x/4b/73/dc/4b73dc1055a27d3a5b9e2a37be344b41.jpg" ,
        email : "kittituch.pulp@bumail.net"
    ),
    myevents : [
        EventTask (
            id : "1",
            title : "Event",
            images : "",
            description: "",
            games : "",
            type : "",
            pattern : "",
            areavisiblity : 0,
            participants : 0,
            startAt: "24 Wed",
            endAt : "26 Fri",
            isMatched: false
        )
    ]
)

class AccountModel: ObservableObject {
    @Published
    var account : [Account] = []
    var myevents : [EventTask] = []
    var ErrorTask : [String]   = []
    
    private var db = Firestore.firestore()
    
    func fetchAccount (id : String, completion: @escaping ([AccEvent]) -> Void) {
        let eventModel = EventViewModel()
        let docRef = db.collection("users").document(id)
            docRef.getDocument { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let snapshot = snapshot {
                    guard let data = snapshot.data() else { return }
                    let myevents =  data["events"] as! [DocumentReference]
                    let pushItem = Account(
                        id: snapshot.documentID as String,
                        name: data["name"] as! String,
                        image: data["image"] as! String,
                        email: data["email"] as! String
                    )
                    
                    self.account.append(pushItem)
                    
                    for docs in myevents {
                        docs.getDocument{query , err  in
                            guard let data = query?.data() else { return }
                            
                            let startAt_timestamp = data["startAt"] as! Timestamp
                            let endAt_timestamp = data["endAt"] as! Timestamp
                            
                            let startAt = eventModel.transfromDate(date: startAt_timestamp.dateValue())
                            let endAt = eventModel.transfromDate(date: endAt_timestamp.dateValue())
                          
                            let doc_id =  docs.documentID as String
                            let item = EventTask(
                                id: doc_id,
                                title: data["title"] as? String ?? "",
                                images: data["images"] as? String ?? "",
                                description: data["description"] as? String ?? "",
                                games: data["games"] as? String ?? "",
                                type: data["type"] as? String ?? "",
                                pattern: data["pattern"] as? String ?? "",
                                areavisiblity: data["areavisiblity"] as? Int ?? 0,
                                participants: data["participants"] as? Int ?? 0,
                                startAt: startAt,
                                endAt: endAt,
                                isMatched: data["isMatched"] as? Bool ?? false
                            )
                            
                            self.myevents.append(item)
                            let accountWithEvent = [AccEvent(id: id , account: self.account[0] , myevents : self.myevents)]
                            completion(accountWithEvent)
                        }
                    }                   
                }
            }
        
    }
}


extension AccountModel {
    func getMyevents (reference : [DocumentReference]) -> [EventTask] {
        let eventModel = EventViewModel()
        var eventlist : [EventTask] = []
        for docs in reference {
            docs.getDocument{query , err  in
                guard let data = query?.data() else { return }
                
                let doc_id =  docs.documentID as String
                
                let startAt_timestamp = data["startAt"] as! Timestamp
                let endAt_timestamp = data["endAt"] as! Timestamp
                
                let startAt = eventModel.transfromDate(date: startAt_timestamp.dateValue())
                let endAt = eventModel.transfromDate(date: endAt_timestamp.dateValue())
              
                let item = EventTask(
                    id: doc_id,
                    title: data["title"] as? String ?? "",
                    images: data["images"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    games: data["games"] as? String ?? "",
                    type: data["type"] as? String ?? "",
                    pattern: data["pattern"] as? String ?? "",
                    areavisiblity: data["areavisiblity"] as? Int ?? 0,
                    participants: data["participants"] as? Int ?? 0,
                    startAt: startAt,
                    endAt: endAt,
                    isMatched: data["isMatched"] as? Bool ?? false
                )
                
                eventlist.append(item);
            }
        }
        return eventlist
    }
}


extension AccountModel {
    func PreferanceValidation (username : String , email : String  , password : String) -> [String] {
        self.ErrorTask = []
        
        if(username.isEmpty || email.isEmpty || password.isEmpty) {
            self.ErrorTask.append("Enter your in formation")
        }
        
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if(!emailPredicate.evaluate(with: email)) {
            self.ErrorTask.append("Invalid Email")
        }
        
        if(password.count < 6) {
            self.ErrorTask.append("Password should have more than 6 letters")
        }
        
        return self.ErrorTask
    }
}




extension AccountModel {
    func UpdatePreferance (id: String , image : Data? ,username : String , email : String , password : String , completion: @escaping (updateResponse) -> Void) {
        let docRef = db.collection("users").document(id);

        uploadFiles(fileURL: image) { url in
            var isSuccess = true
            var error = ""
            var urlString = ""
            if(url != nil) {
                if let url  = url {
                    urlString = url.absoluteString
                }
            }
            docRef.setData(["name" : username , "email" : email , "image" : urlString] , merge : true)
            let updateItem = Account(
                id: id ,
                name: username,
                image : "",
                email: email
            )
            self.account = [updateItem]
            completion(updateResponse(response : Response(success : isSuccess , error : error) , downloadURL: urlString))
        }
    }
    
    func uploadFiles(fileURL: Data?, completion: @escaping (URL?) -> Void) {
                if fileURL == nil { completion(nil) }
            
                if let fileURL,
                     let uiImage = UIImage(data: fileURL) {
                        guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else{ return }
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
                    
                        
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
