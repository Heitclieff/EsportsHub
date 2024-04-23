//
//  MemberForms.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 18/4/2567 BE.
//

import Foundation
import SwiftUI
import PhotosUI

struct MemberForms : View {
    @EnvironmentObject var registerModel: RegisterModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var roaster : [MemberInfo]
    @State var field2: String = ""
    @State private var selectedPhotos :PhotosPickerItem? = nil
    @State var PreviewImage : Data? = nil
    @State private var ShowingAlert = false
    @State private var alertDialog = ""
    @State var roasterInformation = MemberInfo(
        name : "",
        image : nil ,
        national: ""
    )
    
    var body : some View {
        VStack {
            List() {
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
                                
                                roasterInformation.image = data
                                PreviewImage = data
                            }
                        }  
                    }
                
                TextField("Player name", text: $roasterInformation.name).environment(\.isEnabled, true)
                TextField("Nationality", text: $roasterInformation.national).environment(\.isEnabled, true)
                Button(){
                    let isError = registerModel.MemberRegisterValidation(information: roasterInformation);
                    ShowingAlert = isError.error
                    alertDialog = isError.task
                    
                    if(!isError.error) {
                        self.roaster.append(roasterInformation)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                        .frame(height : 28)
                }
                .padding(.vertical, 12)
                .buttonStyle(.borderedProminent)
                .listRowBackground(EmptyView())
                .listRowInsets(EdgeInsets())
                
                .alert(alertDialog , isPresented: $ShowingAlert) {
                           Button("OK", role: .cancel) { }
                }
            }
        }
    }
}

//
//struct  MemberForms_previews : PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MemberForms(roaster : myroaster)
//        }
//    }
//}
