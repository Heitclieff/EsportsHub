import SwiftUI


struct PlayerForms : View  {
    @EnvironmentObject var registerModel : RegisterModel
    @Environment(\.presentationMode) var presentationMode
    
    var doc_id : String
    @State var isLoading = false
    @State var ShowingAlert = false
    @State var Alertdialog = ""
    @Binding var isRegistered : Bool
    
    @State var information = PlayerInfo(
        name : "",
        fname : "",
        lname: "",
        national : "",
        phone : ""
    )
    

    var body : some View {
        VStack {
            List {
                Section(header: Text("Players")) {
                    TextField("Player name", text: $information.name).environment(\.isEnabled, true)
                    
                }
                Section(header: Text("Personal Information")) {
                    TextField("First name", text: $information.fname).environment(\.isEnabled, true)
                    TextField("Last name", text: $information.lname).environment(\.isEnabled, true)
                    TextField("Nationality", text: $information.national).environment(\.isEnabled, true)
                    TextField("Phone", text: $information.phone).environment(\.isEnabled, true)
                }
                
                Button() {
                    self.isLoading = true
                    let isError = registerModel.PlayerRegisterValidation(information: information)
                    
                    ShowingAlert = isError.error
                    Alertdialog = isError.task
                    
                    if(!isError.error) {
                       let isError =  registerModel.PlayerRegister(doc_id: doc_id,  information: information)
                        
                        if(!isError.error) {
                            print("Register successfully.")
                            self.isRegistered = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    self.isLoading = false
                 	
                }label : {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 30)
                    } else {
                        Text("Register")
                            .frame(maxWidth: .infinity, minHeight: 30)
                    }
                }
                .buttonStyle(.borderedProminent)
                .listRowBackground(EmptyView())
                .listRowInsets(EdgeInsets())
                    
            }
            .alert(Alertdialog, isPresented: $ShowingAlert) {
                       Button("OK", role: .cancel) { }
            }
            .navigationBarTitle(Text("Register Forms"))

        }
    }
}



//struct PlayerForms_previews : PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            PlayerForms(doc_id : "wg7EXyef09yAiFUn7CoH")
//                .environmentObject(RegisterModel())
//        }
//       
//    }
//}
