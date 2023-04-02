//
//  Load.swift
//  TrivAI
//
//  Created by Ryan Ho on 02/24/2023.
//

import SwiftUI
//import Firebase
//import FirebaseFirestoreSwift

struct Load: View {
    /// - View Properties
    @State private var quizInfo: Info? = Info(title: "Derivatives", peopleAttended: 2, rules: ["Answer the questions carefully"])
    @State private var questions: [Question] = [
        Question(question: "What notation describes a derivative?", options: ["d/dx", "dd", "dxd", "xdx"], answer_id: 0),
        Question(question: "What is the derivative of 2x?", options: ["0", "1", "x", "2"], answer_id: 3),
        ]
    @State private var startQuiz: Bool = false
    var body: some View {
        if let info = quizInfo{
            VStack(spacing: 10){
                VStack {
                    Text(info.title)
                        //.font(.title)
                        .textCase(.uppercase)
                        .fontWeight(.semibold)
                        .scaledToFill()
                        .font(.system(size: 42))
                        .hAlign(.leading)
                        .padding()
                    
                    Divider()
                        .padding(.horizontal,-15)
                    
                    HStack{
                        VStack {
                            CustomLabel("list.bullet.rectangle.portrait", "\(questions.count) Multiple", "Choice Questions")
                                .padding(.top,10)
                            
                            CustomLabel("book", "Medium", "Difficulty")
                                .padding(.top,10)
                            
                            CustomLabel("calendar", "3/5/2023", "Creation Date")
                                .padding(.top,10)
                            
                        }
                        //Spacer()
                    }.padding()
                    Spacer()
                }.padding()
                    .foregroundColor(.white)
                    .background {
                        Rectangle()
                            .fill(Color("background3"))
                            .ignoresSafeArea()
                    }
                    .shadow(color: Color("backgroundShadow4"), radius: 10.0)
                    .cornerRadius(30.0)
//                if !info.rules.isEmpty{
//                    RulesView(info.rules)
//                }
                Spacer()
                
                CustomButton(title: "Begin", onClick: {
                    startQuiz.toggle()
                })
               
            }
            .padding(15)
            .vAlign(.top)
            .fullScreenCover(isPresented: $startQuiz) {
                QuestionsView(info: info, questions: questions){
                    /// - User has Successfully finished the Quiz
                    /// - Thus Update the UI
//                    quizInfo?.peopleAttended += 1
                }
            }
        }else{
            /// - Presenting Progress View
            VStack(spacing: 4){
                ProgressView()
                Text("Please Wait")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .task {
//                do{
//                    try await fetchData()
//                }catch{
//                    print(error.localizedDescription)
//                }
            }
        }
    }
    
    /// - Rules View
    @ViewBuilder
    func RulesView(_ rules: [String])->some View{
        VStack(alignment: .leading, spacing: 15) {
            Text("Before you start")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom,12)
            
            ForEach(rules,id: \.self){rule in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                        .offset(y: 6)
                    Text(rule)
                        .font(.callout)
                        .lineLimit(3)
                }
            }
        }
    }
    
    /// - Custom Label
    @ViewBuilder
    func CustomLabel(_ image: String,_ title: String,_ subTitle: String)->some View{
        HStack(spacing: 12){
            Image(systemName: image)
                .font(.title3)
                .frame(width: 45, height: 45)
                .background {
                    Circle()
                        .fill(.gray.opacity(0.1))
                        .padding(-1)
                        .background {
                            Circle()
                                .stroke(Color("BG"),lineWidth: 1)
                        }
                }
            
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Text(subTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            .hAlign(.leading)
        }
    }
    
    /// - Fetching Quiz Info and Questions
//    func fetchData()async throws{
//        try await loginUserAnonymous()
//        let info = try await Firestore.firestore().collection("Quiz").document("Info").getDocument().data(as: Info.self)
//        let questions = try await Firestore.firestore().collection("Quiz").document("Info").collection("Questions").getDocuments()
//            .documents
//            .compactMap{
//                try $0.data(as: Question.self)
//            }
//        /// - UI Must be Updated on Main Thread
//        await MainActor.run(body: {
//            self.quizInfo = info
//            self.questions = questions
//        })
//    }
    
    /// - Login User as Anonymous For Firestore Access (Later You can Implement own user profile with this)
//    func loginUserAnonymous()async throws{
//        try await Auth.auth().signInAnonymously()
//    }
}

struct Load_Previews: PreviewProvider {
    static var previews: some View {
        Load()
    }
}

// MARK: View Extensions
/// - Useful for moving Views btw HStack and VStack
extension View{
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
}
