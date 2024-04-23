import Foundation
import Firebase
import FirebaseStorage

let SelectionTypes = ["Games" , "Sports"]
let SelectionPatterns = ["Swiss State" , "Group State"]
let SelectionGames = ["Valorant" , "Leauge of legends" , "Dota2" , "Counter Strike 2" , "Rainbow six siege"]
let SelectionParticipants = ["10" , "20" , "30" , "40"]
let SelectionEnable = [true ,false]

struct EventResponse  {
    var response : Response
    var eventTask : EventTask
    var docId : String
}


struct EventInformation {
    var title : String
    var description : String
    var images : String 
    var startAt : Date
    var endAt : Date
    var type : String
    var games : String
    var pattern : String
    var participation : String
    var isEnable : Bool
}
extension EventViewModel {
    func EventValidation (fields : EventInformation) -> [String] {
        self.errortask = []
        
        if(fields.title.isEmpty || fields.games.isEmpty || fields.pattern.isEmpty || fields.type.isEmpty || fields.participation.isEmpty) {
            self.errortask.append("Enter your Information")
        }
        
        return self.errortask
    }
    
    func createEvent (fields : EventInformation , image: Data? , completion: @escaping (EventResponse) -> Void) {
        let Orgs = OrgViewModel()
        let id = UserDefaults.standard.string(forKey: "user_id") ?? ""
        let docRef = db.collection("events").document()
        let userRef = db.collection("users").document(id)
        let docId = docRef.documentID
        var res = Response(success : false , error: "Error : Cannot founds createBy ID")
        
        
        
        Orgs.uploadFiles(fileURL: image , path: "events") {url in
            var downloadURL = ""
            if(url != nil) {
                if let url  = url {
                    downloadURL = url.absoluteString
                }
            }
            let startAt_timestamp = Timestamp(date: fields.startAt)
            let endAt_timestamp = Timestamp(date : fields.endAt)
            
            if(!id.isEmpty) {
                docRef.setData([
                    "title" : fields.title ,
                    "description" : fields.description,
                    "images" : downloadURL,
                    "games" : fields.games.lowercased() ,
                    "pattern" : fields.pattern,
                    "types" : fields.type,
                    "participants" : Int(fields.participation) ?? 0,
                    "createBy" : id,
                    "areavisibility" : 20 ,
                    "searchQuery" : fields.title.lowercased(),
                    "startAt" : startAt_timestamp,
                    "endAt" : endAt_timestamp,
                    "isMatched" : false
                ])
      
                userRef.setData(["events" : FieldValue.arrayUnion([docRef])] , merge:true)
                
                
                let startAt = self.transfromDate(date: fields.startAt)
                let endAt = self.transfromDate(date: fields.endAt)
                
                let task = EventTask(
                    id: docId,
                    title: fields.title,
                    images: downloadURL,
                    description: fields.description,
                    games : fields.games,
                    type : fields.type,
                    pattern: fields.pattern,
                    areavisiblity: 20,
                    participants: Int(fields.participation) ?? 0,
                    startAt: startAt,
                    endAt: endAt,
                    isMatched: false
                )
                
                res =  Response(success:true , error : "")
                completion(EventResponse(response: res, eventTask: task , docId : docId))
            }
           
        }
    }
}

