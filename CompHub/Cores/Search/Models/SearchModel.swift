import Firebase


class SearchModel: ObservableObject {
    @Published
    var results : [EventTask] = []
    
    
    func SearchFromQuery(searchQuery : String) {
        let eventModel = EventViewModel()
        let db = Firestore.firestore()
        self.results = []
        db.collection("events").whereField("searchQuery" , isGreaterThanOrEqualTo: searchQuery.lowercased())
            .getDocuments {snapshot ,error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
              
               
                if let snapshot = snapshot {
                    for documents in snapshot.documents {
                        let data = documents.data()
     
                        let doc_id = documents.documentID as String
                        let containsId = self.results.contains(where: {$0.id == doc_id})
                        
                        let startAt_timestamp = data["startAt"] as! Timestamp
                        let endAt_timestamp = data["endAt"] as! Timestamp
                        
                        let startAt = eventModel.transfromDate(date: startAt_timestamp.dateValue())
                        let endAt = eventModel.transfromDate(date: endAt_timestamp.dateValue())
                      
                        let res = EventTask(
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
                        if(!containsId) {
                            self.results.append(res)
                        }
                    }
                }
            }
    }
   
}

