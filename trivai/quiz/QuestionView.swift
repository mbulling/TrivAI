import SwiftUI

struct QuestionView: View {
  @State private var currentQuestion = 0
  @State private var selectedAnswer: Int?
  @State private var showIndicator = false

  let questions: [QuizQuestion] = [
    QuizQuestion(
      question: "What is the why how and when where what is then he she when what why",
      answers: [
        "Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A Answer 1A",
        "Answer 1B", "Answer 1C", "Answer 1D",
      ],
      correctAnswer: 0),
    QuizQuestion(
      question: "Question 2", answers: ["Answer 2A", "Answer 2B", "Answer 2C", "Answer 2D"],
      correctAnswer: 1),
  ]

  var body: some View {
    ZStack {
      Color(hex: "#1a1a40")
        .edgesIgnoringSafeArea(.all)

      ScrollView {
        VStack(spacing: 20) {
          Text(questions[currentQuestion].question)
            .font(.title3)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding()

          ForEach(0..<questions[currentQuestion].answers.count) { index in
            AnswerButton(
              answer: questions[currentQuestion].answers[index],
              correctAnswer: questions[currentQuestion].correctAnswer,
              selectedAnswer: $selectedAnswer,
              showIndicator: $showIndicator,
              index: index)
          }

          Button(action: {
            if showIndicator {
              currentQuestion = (currentQuestion + 1) % questions.count
              selectedAnswer = nil
              showIndicator = false
            }
          }) {
            Text("Next")
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
          .frame(maxWidth: .infinity, alignment: .leading)

        if showIndicator
          && (selectedAnswer == index
            || (selectedAnswer != correctAnswer && index == correctAnswer))
        {
          if index == correctAnswer {
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

struct QuestionView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionView()
  }
}

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
