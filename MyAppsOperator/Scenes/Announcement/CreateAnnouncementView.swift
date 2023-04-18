//
//  CreateAnnouncementView.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/18.
//

import SwiftUI

struct CreateAnnouncementView: View {
    
    enum Field: Hashable {
        case title
        case content
    }
    
    @State private var title = ""
    @State private var content = ""
    let contentPlaceholder = "여기에 공지할 내용을 작성하세요."
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            TextField(
                "Title",
                text: $title
            )
            .font(.title)
            .focused($focusedField, equals: .title)
            .onSubmit {
                focusedField = .content
            }
            
            TextEditor(text: $content)
                .scrollContentBackground(.hidden)
                .focused($focusedField, equals: .content)
                .background(alignment: .topLeading) {
                    TextEditor(text: .constant(content.isEmpty ? contentPlaceholder : ""))
                        .foregroundColor(.gray)
                }
        }
        .onAppear {
            focusedField = .title
        }
        .padding()
    }
}

struct CreateAnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAnnouncementView()
    }
}
