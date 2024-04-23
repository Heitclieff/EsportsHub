
import Firebase

struct RegisterRes {
    var isError : Bool
    var task : String
}

class ValidationModel : ObservableObject {
    @Published
    var db = Firestore.firestore()
    
    func Loginvalidation (email : String , password : String) -> RegisterRes {
        if(email.isEmpty || password.isEmpty) {
            return RegisterRes(isError : true , task: "Please enter information")
        }
        return RegisterRes(isError : false , task: "")
    }
    
    func FindLoginAccount (email : String , password : String , completion : @escaping (RegisterRes) -> Void) {
            let userRef = db.collection("users")
            
            userRef.whereField("email", isEqualTo: email)
               .whereField("password", isEqualTo: password)
               .getDocuments { snapshot, error in
                   guard let documents = snapshot?.documents else {
                       return
                   }
                   
                   if let document = documents.first {
                       let data = document.data()
                       
                       let id = document.documentID as String
                       
                       if(!id.isEmpty) {
                           UserDefaults.standard.set(id , forKey: "user_id")
                       }
                       
                       let register_task = RegisterRes(isError: false , task: "")
                       completion(register_task)
                   } else {
                       completion(RegisterRes(isError: true , task: "Not founds any account."))
                   }	    
               }
    }
    
    func RegisterValidation (username : String , email : String, password: String) -> RegisterRes {
            
        if(username.isEmpty || email.isEmpty || password.isEmpty) {
            return RegisterRes(isError : true , task: "Please enter information")
        }
        
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if(!emailPredicate.evaluate(with: email)) {
            return RegisterRes(isError : true , task: "Invaid Email")
        }
        
        if(password.count < 6) {
            return RegisterRes(isError : true , task: "Password should have more than 6 letters")
        }
        
        return RegisterRes(isError : false , task : "")
    }
    
    func Registerusers (username : String , email : String, password: String) {
        let userRef = db.collection("users").document()
        
        let current_date = Date.now
        let date_timestamp = Timestamp(date: current_date)
        
        userRef.setData([
            "username" : username,
            "email" : email ,
            "password" : password,
            "createAt" : current_date
        ])
    }
}
