//
//  CreateAnnouncementView.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/18.
//

import SwiftUI

protocol CreateAnnouncementViewState {
    var createAlert: CreateAnnouncementErrorAlert { get }
}

struct CreateAnnouncementView: View, CreateAnnouncementViewState {
   
    enum Field: Hashable {
        case title
        case content
    }
    
    // Components
    
    private var announcementWorker = AnnouncementWorker(
        network: NetworkDataCodableService(
            network: NetworkService(
                configuration: NetworkAPIConfiguration(
                    baseURL: URL(string: "http://127.0.0.1:8080/announcements")!
                )
            )
        )
    )
    
    var interactor: CreateAnnouncementInteractor
    @State var model = AnnouncementViewModel()
    @StateObject var createAlert: CreateAnnouncementErrorAlert
    
    // UI
    
    @FocusState private var focusedField: Field?
    let contentPlaceholder = "여기에 공지할 내용을 작성하세요."
    
    var body: some View {
        VStack {
            TextField(
                "제목",
                text: $model.title
            )
            .tint(.red)
            .font(.title)
            .focused($focusedField, equals: .title)
            .onSubmit {
                focusedField = .content
            }
            
            TextEditor(text: $model.content)
                .scrollContentBackground(.hidden)
                .focused($focusedField, equals: .content)
                .background(alignment: .topLeading) {
                    TextEditor(text: .constant(model.content.isEmpty ? contentPlaceholder : ""))
                        .foregroundColor(.gray)
                }
            Button {
                Task {
                        try await interactor.create(
                            title: model.title,
                            content: model.content
                        )
                }
            } label: {
                Text("공지하기")
                    .frame(maxWidth: .infinity)
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
            .padding([.leading, .trailing], 5.0)
            .controlSize(.large)
            .alert(
                createAlert.title,
                isPresented: $createAlert.didError,
                presenting: createAlert
            ) { _ in
            } message: { alert in
                Text(alert.content)
            }
        }
        .onAppear {
            focusedField = .title
        }
        .padding()
    }
 
    init() {
        let interactor = CreateAnnouncementInteractor()
        var stateController = CreateAnnouncementStateController()
        let createAnnouncementErrorAlert = CreateAnnouncementErrorAlert()
        stateController.createAlert = createAnnouncementErrorAlert
        _createAlert = StateObject(wrappedValue: { createAnnouncementErrorAlert }())
        interactor.worker = announcementWorker
        interactor.stateController = stateController
        self.interactor = interactor
    }
}

struct CreateAnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAnnouncementView()
    }
}
