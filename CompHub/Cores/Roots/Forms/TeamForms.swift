import SwiftUI
import PhotosUI

struct TeamForms : View  {
    @EnvironmentObject var registerModel : RegisterModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isRegistered : Bool
    @State var field2: String = ""
    @State var roaster : [MemberInfo]  = []
    @State private var ShowingAlert = false
    @State private var alertdialog = ""
    @State private var isLoading = false
    @State private var selectedPhotos :PhotosPickerItem? = nil
    @State var PreviewImage : Data? = nil
    @State var TeamInformation = TeamInfo(
        name : "",
        identity : "",
        image : nil
    )
    
    var doc_id : String
    var participants : Int
    let teams_limit : Int = 5
    var body : some View {
        VStack {
            List {
                Section(header: Text("Teams")) {
                    PhotosPicker (
                        selection : $selectedPhotos,
                        matching : .images,
                        photoLibrary: .shared()){
                            VStack () {
                                if(PreviewImage == nil) {
                                    VStack {
                                        Image(systemName: "photo").padding(5)
                                        Text("Select a Photos")
                                    }
                                    .padding()
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(style: StrokeStyle(lineWidth : 1 , dash : [10]))
                                    )
                                }
                                else {
                                    if let PreviewImage,
                                       let uiImage = UIImage(data: PreviewImage) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 130)
                                    }
                                    Text("Select a Photos")
                                        .foregroundColor(.blue)
                                }
                                
                            }
                            .frame(maxWidth : .infinity)
                            .frame(height : 120)
                        }
                        .onChange(of: selectedPhotos){ newImage in
                            Task {
                                if let data = try? await newImage?.loadTransferable(type: Data.self) {
                                    PreviewImage = data
                                    TeamInformation.image = data
                                }
                            }
                    }
                    TextField("Teams name", text: $TeamInformation.name).environment(\.isEnabled, true)
                    TextField("Identity (GEN , PRX)", text: $TeamInformation.identity).environment(\.isEnabled, true)
                }
               
                Section(header: Text("Roaster (\(String(teams_limit)) Vs \(String(teams_limit)))")) {
                    if(roaster.count == 0) {
                        Text("")
                    }
                    
                    else{
                        ForEach(roaster , id: \.id) { member in
                                Text(member.name)
                        }
                    }
                }
                NavigationLink() {
                    MemberForms(roaster : $roaster)
                        .environmentObject(RegisterModel())
                } label : {
                    Text("Add Roaster ")
                            .frame(maxWidth: .infinity)
                            .frame(height : 40)
                }
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(7)
                .listRowBackground(EmptyView())
                .listRowInsets(EdgeInsets())
                .disabled(roaster.count == teams_limit)
            }
            .toolbar {
                Button() {
                    self.isLoading = true
                    let isError = registerModel.TeamRegisterValidation(information: TeamInformation , isLimit: teams_limit , roaster: roaster)
                    ShowingAlert = isError.error
                    alertdialog = isError.task
                    
                    if(!isError.error) {
                        registerModel.isLimitParticipants(doc_id: doc_id , isLimit: participants){ isFull in
                            if(isFull) {
                              ShowingAlert = true
                                alertdialog = "Sorry Participants is Full now."
                                self.isLoading = false
                            }else {
                                registerModel.TeamRegister(doc_id: doc_id, information: TeamInformation, roaster: roaster) {response in
                                    ShowingAlert = response.error
                                    alertdialog = response.task
                                    self.isLoading = false
                                    
                                    if(!response.error) {
                                        self.isRegistered = true
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }else {
                        self.isLoading = false
                    }
                } label: {
                    if(isLoading) {
                        ProgressView()
                    }else {
                        Text("Register")
                    }
                }
            }
            .alert(alertdialog , isPresented: $ShowingAlert) {
                       Button("OK", role: .cancel) { }
            }
            .navigationBarTitle(Text("Register Forms"))
        }
    }
}

//struct TeamForms_previews : PreviewProvider {
//
//    static var previews: some View {
//        NavigationView {
//            TeamForms(doc_id : "wg7EXyef09yAiFUn7CoH")
//                .environmentObject(RegisterModel())
//        }
//
//    }
//}
