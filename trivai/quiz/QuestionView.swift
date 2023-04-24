import SwiftUI

var score = 0.0;
func updateScore(correctAnswer: Int, selectedAnswer: Int) -> Bool {
    if correctAnswer == selectedAnswer {
        score += 1.0;
    }
    return true;
}

struct QuestionsView: View {
    var info: Info
    /// - Making it a State, so that we can do View Modifications
    @State var questions: [ Question ]
    var onFinish: ()->()
    /// - View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var progress: CGFloat = 0
    @State private var currentIndex: Int = 0
    //@State private var score: CGFloat = 0
    @State private var showScoreCard: Bool = false
  @State private var currentQuestion = 0
  @State private var selectedAnswer: Int?
  @State private var showIndicator = false
    
    func updateUserInfo() {
        LocalStorage.myGamesV = LocalStorage.myGamesV + questions.count
        LocalStorage.myWinsV = LocalStorage.myWinsV + Int(score)
        score = 0.0;
    }
    
  var body: some View {
    ZStack {
      Color(hex: "#1a1a40")
        .edgesIgnoringSafeArea(.all)

      ScrollView {
        VStack(spacing: 20) {
          Text(questions[currentQuestion].question)
            .font(.title3)
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .padding()

          ForEach(0..<questions[currentQuestion].options.count) { index in
            AnswerButton(
              answer: questions[currentQuestion].options[index],
              correctAnswer: questions[currentQuestion].answer_id,
              selectedAnswer: $selectedAnswer,
              showIndicator: $showIndicator,
              index: index)
          }

          Button(action: {
              if currentQuestion == questions.count - 1 {
                  showScoreCard = true;
              }
            if showIndicator {
                if currentQuestion != questions.count - 1 {
                    currentQuestion = (currentQuestion + 1)
                }
              selectedAnswer = nil
              showIndicator = false
            }
          }) {
              Text((currentQuestion == questions.count) ? "Done" : "Next")
              .frame(maxWidth: .infinity)
              .padding()
              .background(showIndicator ? Color.white : Color.gray.opacity(0.5))
              .cornerRadius(16)
              .foregroundColor(Color(hex: "#423ed8"))
          }
          .disabled(!showIndicator)
        }
        .padding()
      }
    }.fullScreenCover(isPresented: $showScoreCard) {
        /// - Displaying in 100%
        ScoreCardView(score: score / CGFloat(questions.count) * 100){
            self.updateUserInfo()
            /// - Closing View
            dismiss()
            onFinish()
        }
    
}
  }
}

struct AnswerButton: View {
  let answer: String
  let correctAnswer: Int
  @Binding var selectedAnswer: Int?
  @Binding var showIndicator: Bool
  let index: Int
    

  var body: some View {
    Button(action: {
      if !showIndicator {
        selectedAnswer = index
        showIndicator = true
      }
    }) {
      HStack {
        Text(answer)
          .foregroundColor(.white)
          .padding()
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)

        if showIndicator
          && (selectedAnswer == index
            || (selectedAnswer != correctAnswer && index == correctAnswer))
        {
            if index == correctAnswer && updateScore(correctAnswer: correctAnswer, selectedAnswer: selectedAnswer!) {
            Image(systemName: "checkmark")
              .foregroundColor(.green)
          } else if selectedAnswer == index {
            Image(systemName: "xmark")
              .foregroundColor(.red)
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical)
    .background(
      Color(
        hex: selectedAnswer == index || (showIndicator && index == correctAnswer)
          ? (index == correctAnswer ? "#77DD76" : (selectedAnswer == index ? "#FF3B30" : "#9b6dff"))
          : "#2c2b6b")
    )
    .cornerRadius(16)
    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#b99aff"), lineWidth: 3))
  }
}

struct QuizQuestion {
  let question: String
  let answers: [String]
  let correctAnswer: Int
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:  // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
  }
}

//struct QuestionView_Previews: PreviewProvider {
//  static var previews: some View {
//    QuestionView()
//  }
//}

extension View {
  func hAlign(_ alignment: Alignment) -> some View {
    self
      .frame(maxWidth: .infinity, alignment: alignment)
  }

  func vAlign(_ alignment: Alignment) -> some View {
    self
      .frame(maxHeight: .infinity, alignment: alignment)
  }
}
