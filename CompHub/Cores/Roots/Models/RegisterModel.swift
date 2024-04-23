
import Foundation
import Firebase
import SwiftUI


struct PlayerInfo {
    var name : String
    var fname : String
    var lname : String
    var national : String
    var phone : String
}

struct TeamInfo {
    var name : String
    var identity : String
    var image : Data?
}

struct MemberInfo : Identifiable {
    var id = UUID()
    var name : String
    var image : Data?
    var national : String
}

struct ErrorResponse {
    var error : Bool
    var task : String
}

class RegisterModel : ObservableObject {
    var error = ErrorResponse(error: false , task: "")
    var db  = Firestore.firestore()
    var user_id = UserDefaults.standard.string(forKey: "user_id") ?? ""
    
    func PlayerRegister (doc_id : String , information : PlayerInfo) -> ErrorResponse {
        let eventRef = db.collection("events").document(doc_id);
        let participantRef = eventRef.collection("participants").document()
        
        participantRef.setData([
            "register_id" : self.user_id,
            "name" : information.name,
            "fname" : information.fname,
            "lname" : information.lname,
            "national" : information.national,
            "phone" : information.phone
        ])
        
        return ErrorResponse(error:false , task : "")
    }
    
    func TeamRegister (doc_id : String , information : TeamInfo , roaster : [MemberInfo], completion: @escaping (ErrorResponse) -> Void)  {
        let Orgs = OrgViewModel()
        let eventRef = db.collection("events").document(doc_id)
        let participantRef = eventRef.collection("participants");
        let teamRef  = db.collection("teams").document()
        let currentDate = Date()
        let timestamp  = Timestamp(date : currentDate)
        var isError = self.error
        
        Orgs.uploadFiles(fileURL: information.image , path: "teams") { url in
            var downloadURL = ""
            if(url != nil) {
                if let url  = url {
                    downloadURL = url.absoluteString
                }
            }
            teamRef.setData([
                "createAt" : timestamp,
                "name" : information.name,
                "image" : downloadURL,
                "teams_text" : information.identity
            ])
            
            let documentID =  teamRef.documentID
            let roasterRef =  self.db.collection("teams").document(documentID).collection("roaster");
            let dispatchGroup = DispatchGroup()

            roaster.forEach { member in
                dispatchGroup.enter()
                Orgs.uploadFiles(fileURL: member.image, path: "players") { url in
                    print("Roaster Player append :" , member.name)
                    var downloadURL = ""
                    if let url = url {
                        downloadURL = url.absoluteString
                        roasterRef.addDocument(data :[
                          "name": member.name,
                          "image": downloadURL,
                          "national" : member.national
                        ])
                        
                        participantRef.addDocument(data: ["id" : teamRef.path , "register_id" : self.user_id])
                      } else {
                          isError = ErrorResponse(error : true ,task : "Failed to upload file.")
                          print("Failed to upload file for: \(member.name)")
                      }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(isError)
                print("success appends." )
            }
            
        }
    }
    
    func isLimitParticipants (doc_id : String , isLimit : Int , completion: @escaping (Bool) -> Void) {
        let eventRef = db.collection("events").document(doc_id)
        let participantRef = eventRef.collection("participants")
        
        participantRef.getDocuments { snapshot, error in
               guard error == nil else {
                   print("Error fetching documents: \(error!.localizedDescription)")
                   return
               }
               if let snapshot = snapshot {
                   let count = snapshot.documents.count
                   if(count >= isLimit) {
                       completion(true)
                       return
                   }
                   completion(false)
                  
               } else {
                   print("Snapshot is nil")
               }
           }
    }
    
    func PlayerRegisterValidation (information : PlayerInfo) -> ErrorResponse {
        var isError = ErrorResponse(error: false , task : "")
        if (information.fname.isEmpty || information.lname.isEmpty || information.name.isEmpty || information.national.isEmpty || information.phone.isEmpty) {
            isError =  ErrorResponse(error: true, task: "Please Enter your information.")
        }
        return isError
    }
    
    func MemberRegisterValidation (information : MemberInfo) -> ErrorResponse {
        var isError = ErrorResponse(error:false , task: "")
        if(information.name.isEmpty || information.national.isEmpty || information.image == nil) {
            isError = ErrorResponse(error : true , task: "Please Enter member Information.")
        }
        return isError
    }
    
    func TeamRegisterValidation (information : TeamInfo , isLimit : Int, roaster : [MemberInfo]) -> ErrorResponse {
        var isError = self.error
        if(information.name.isEmpty || information.identity.isEmpty || information.image == nil) {
            isError = ErrorResponse(error : true , task: "Please Enter Team Information.")
            
            return isError
        }

        if(roaster.count != isLimit) {
            isError = ErrorResponse(error : true , task: "Please Add your Roaster Member.")
            
            return isError
        }
        return isError
    }
}
