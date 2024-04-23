import SwiftUI
import PhotosUI

struct CreateEventView: View {
  @Binding var event : AccEvent
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var createModel : EventViewModel

  @State var EventFields = EventInformation(
    title : "" ,
    description : "",
    images : "" ,
    startAt : Date.now,
    endAt : Date.now,
    type : SelectionTypes[0],
    games : SelectionGames[0],
    pattern : SelectionPatterns[0],
    participation : SelectionParticipants[0],
    isEnable: true
  )
    @State private var selectedPhotos : PhotosPickerItem? = nil
    @State var PreviewImage : Data? = nil
    @State private var isAlert = false
    @State private var Alertdialog = ""
    @State private var isLoading = false

    var body: some View {
        VStack {
            List { // works if this is VStack or Form
                VStack (alignment: .center) {
                    if(PreviewImage != nil)  {
                        if let PreviewImage,
                             let uiImage = UIImage(data: PreviewImage) {
                              Image(uiImage: uiImage)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 300 , height : 250)
                        }
                        
                    }
                    PhotosPicker (
                            selection : $selectedPhotos,
                            matching : .images,
                            photoLibrary: .shared()
                    ){

                            if(PreviewImage != nil)  {
                                Text("Select a Photos")
                            }else {
                                VStack {
                                    Image(systemName: "photo").padding(5)
                                    Text("Select a Photos")
                                }
                                .frame(width : 300 , height : 150)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(style: StrokeStyle(lineWidth : 1 , dash : [10]))
                                )
                            }
                            
                        }
                        .onChange(of: selectedPhotos){ newImage in
                            Task {
                                if let data = try? await newImage?.loadTransferable(type: Data.self) {
                                    PreviewImage = data
                                }
                            }
                        }
                    
                }
                .padding()
                Section(header: Text("General")) {
                    TextField("Event name", text: $EventFields.title).environment(\.isEnabled, true)
                    TextEditorWithPlaceholder(text : $EventFields.description)
                }
                Section(header: Text("Event Duration")) {
                    DatePicker("Start at",
                               selection: $EventFields.startAt,
                               in: Date()...,
                               displayedComponents: [.date]
                               
                    )
                    .datePickerStyle(.compact)
                    .environment(\.locale, .init(identifier: "en"))
                    DatePicker("End at",
                               selection: $EventFields.endAt,
                               in: Date()...,
                               displayedComponents: [.date]
                               
                    )
                    .datePickerStyle(.compact)
                    .environment(\.locale, .init(identifier: "en"))
                }
                Section(header: Text("Event Settings")) {
                    Picker("Type", selection :$EventFields.type) {
                        ForEach(SelectionTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Games", selection :$EventFields.games) {
                        ForEach(SelectionGames, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Pattern", selection: $EventFields.pattern) {
                        ForEach(SelectionPatterns, id: \.self) {
                            Text($0)
                        }
                    }
                
                }
                Section(header: Text("Participants Settings")) {
                    Picker("Enable", selection: $EventFields.isEnable) {
                        ForEach(SelectionEnable, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Participation", selection: $EventFields.participation) {
                        ForEach(SelectionParticipants, id: \.self) {
                            Text($0)
                        }
                    }
                    .disabled(!EventFields.isEnable)
                }
             }
        }
        .alert(isPresented: $isAlert) {
                Alert(
                    title: Text(Alertdialog),
                    dismissButton: .default(Text("OK"), action: {
                        isAlert = false
                    })
                )
        }
        
        .navigationBarTitle(Text("New Event"))
        .toolbar {
            if(isLoading) {
                ProgressView()
            } else{
                Button("Create"){
                    self.isLoading = true
                    let error = createModel.EventValidation(fields: EventFields)
                    if(error.count > 0) {
                        Alertdialog = error[0]
                        isAlert.toggle()
                        return
                    }
                    
                    createModel.createEvent(fields: EventFields, image: PreviewImage ?? nil) {response in
                        if(response.response.success) {
                            
                            self.event.myevents.append(response.eventTask)
                            presentationMode.wrappedValue.dismiss()
                        }
                        self.isLoading = false
                    }
                }
            }
        }
    }
 
}

struct TextEditorWithPlaceholder: View {
        @Binding var text: String
        
        var body: some View {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                   VStack {
                        Text("Description")
                            .padding(.top, 10)
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .frame(minHeight: 150, maxHeight: 300)
                        .opacity(text.isEmpty ? 0.85 : 1)
                    Spacer()
                }
            }
        }
}

    

//struct CreateEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            CreateEventView()
//                .environmentObject(EventViewModel())
//        }
//
//    }
//}

