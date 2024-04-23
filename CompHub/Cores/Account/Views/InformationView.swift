
import SwiftUI
import PhotosUI


struct InformationView : View {
    @Binding var account : AccEvent
    @Environment(\.presentationMode) var presentationMode
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = "12"
    @State private var selectedPhotos : PhotosPickerItem? = nil
    @State var PreviewImage : Data? = nil
    @State var showingAlert: Bool = false
    @State private var isLoading = false
    @State var Alertdialog : String = ""
    @EnvironmentObject var accountModel : AccountModel
    
    
    var body : some View {
        VStack {
      
                Text("Preferance")
                    .font(.system(size : 27 ,weight : .bold))
                    .padding(.top)
                VStack () {
                    VStack {
                        if(PreviewImage == nil) {
                            AsyncImage(url : URL(string : account.account.image)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode : .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 250, height: 250)
                            .clipped()
                        }else {
                            if let PreviewImage,
                                 let uiImage = UIImage(data: PreviewImage) {
                                  Image(uiImage: uiImage)
                                      .resizable()
                                      .scaledToFit()
                                      .frame(width: 250, height: 200)
                            }
                        }
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .clipped()
                    
                    PhotosPicker (
                        selection : $selectedPhotos,
                        matching : .images,
                        photoLibrary: .shared()){
                            Text("Select a Photo")
                                .foregroundColor(.blue)
                        }
                        .onChange(of: selectedPhotos){ newImage in
                            Task {
                                if let data = try? await newImage?.loadTransferable(type: Data.self) {
                                    PreviewImage = data
                                }
                            }
                        }
                }
                .foregroundColor(.black)
                
                VStack {
                        List () {
                            Section(header: Text("General")) {
                                TextField("Username", text: $username)
                                TextField("Email", text: $email).environment(\.isEnabled, true)
                            }
                            Section(header: Text("Password")) {
                                SecureField("Password", text: $password).environment(\.isEnabled, true)
                            }
                            Button() {
                                self.isLoading = true
                                let error = accountModel.PreferanceValidation(username: username, email: email, password: password)
                                
                                if(error.count > 0 ) {
                                    showingAlert = true
                                    Alertdialog = error[0]
                                    self.isLoading = false
                                    return
                                }
                                
                                accountModel.UpdatePreferance(
                                    id : account.account.id ,
                                    image : PreviewImage ?? nil,
                                    username :username,
                                    email : email,
                                    password : password
                                ) { response in
                                    if(response.response.success) {
                                        self.account.account.name = username
                                        self.account.account.email = email
                                        
                                        if(PreviewImage != nil) {
                                            self.account.account.image = response.downloadURL
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                    
                                    self.isLoading = false
                                }
                                
                            }
                            label: {
                           
                                if isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity, minHeight: 27)
                                } else {
                                    Text("Confirm")
                                        .frame(maxWidth: .infinity, minHeight: 27)
                                }
                            
                            }
                            .padding(.vertical, 12)
                            .buttonStyle(.borderedProminent)
                            .listRowBackground(EmptyView())
                            .listRowInsets(EdgeInsets())
                        }
                    
                    }
            }
        .background(Color(red: 0.949, green: 0.949, blue: 0.969))
        .alert(Alertdialog, isPresented: $showingAlert) {
                   Button("OK", role: .cancel) { }
               }
        .onAppear {
            username = account.account.name
            email = account.account.email
        }
    }
}



//
//struct InformationView_Previews : PreviewProvider {
//    static var previews: some View {
//
//        InformationView(account : $GuideAccount)
//            .environmentObject(AccountModel())
//
//    }
//}
