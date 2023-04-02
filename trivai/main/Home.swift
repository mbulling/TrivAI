//
//  Home.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import SwiftUI

let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
let screen = UIScreen.main.bounds


struct Home: View {
    
    @State var show = (LocalStorage.myValue == "")
    @State var showProfile = false
    @State var userName: String = LocalStorage.myValue
    @State var name = LocalStorage.myValue
    
    init() {
        if LocalStorage.myValue != "" {
            self.name = LocalStorage.myValue
            self.show = true
        }
    }
    
    func setName(name: String) {
        LocalStorage.myValue = name
        show = false
    }
    
    var body: some View {
       
        ZStack(alignment: .top) {
            HomeList(name: name)
                .blur(radius: show ? 20 : 0)
                .scaleEffect(showProfile ? 0.95 : 1)
                .animation(.default)
            
            ContentView()
                .frame(minWidth: 0, maxWidth: 712)
                .cornerRadius(30)
                .shadow(radius: 20)
                .animation(.spring())
                .offset(y: showProfile ? statusBarHeight + 40 : UIScreen.main.bounds.height)
            
            
        }
        .background(Color("background"))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $show) {
            VStack(alignment: .leading) {
                
                Text("What is your first name?")
                    .fontWeight(.heavy)
                    .padding(.top, 30)
                    .foregroundColor(Color("background3"))
                    //.hAlign(.leading)
                    .padding(.leading, 30)
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                
                VStack {
                    TextField("NAME", text: $name)
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("background3"), lineWidth: 1)
                        )
                    
                   
                    
                }
                VStack {
                    Button("Save") {
                        self.setName(name: name)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("background3"))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    //.padding(10)
                }.background(Color("background3"))
                    .cornerRadius(10)
                    .padding(.top, 20)
            }.padding(.trailing, 30)
                .padding(.leading, 30)
                    }
                }      
    
}


class LocalStorage {
    
    private static let myKey: String = "myKey"
    private static let myGames: String = "myGames"
    private static let myWins: String = "myWins"
    
    public static var myValue: String {
        set {
            UserDefaults.standard.set(newValue, forKey: myKey)
        }
        get {
            return UserDefaults.standard.string(forKey: myKey) ?? ""
        }
    }
    
    public static var myGamesV: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: myGames)
        }
        get {
            return UserDefaults.standard.integer(forKey: myGames) ?? 0
        }
    }
    
    public static var myWinsV: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: myWins)
        }
        get {
            return UserDefaults.standard.integer(forKey: myWins) ?? 0
        }
    }
    
    public static func removeValue() {
        UserDefaults.standard.removeObject(forKey: myKey)
    }
    
}

#if DEBUG
struct Home_Previews: PreviewProvider {
   static var previews: some View {
      Home()
         .previewDevice("iPhone X")
   }
}
#endif

struct MenuRow: View {

   var image = "creditcard"
   var text = "My Account"

   var body: some View {
      return HStack {
         Image(systemName: image)
            .imageScale(.large)
            .foregroundColor(Color("icons"))
            .frame(width: 32, height: 32)

         Text(text)
            .font(.headline)
            .foregroundColor(.primary)

         Spacer()
      }
   }
}

struct Menu: Identifiable {
   var id = UUID()
   var title: String
   var icon: String
}

let menuData = [
   Menu(title: "My Account", icon: "person.crop.circle"),
   Menu(title: "Settings", icon: "gear"),
]

struct MenuView: View {

   var menu = menuData
   @Binding var show: Bool
   @State var showSettings = false

   var body: some View {
      return HStack {
         VStack(alignment: .leading) {
            ForEach(menu) { item in
               if item.title == "Settings" {
                  Button(action: { self.showSettings.toggle() }) {
                     MenuRow(image: item.icon, text: item.title)
                        .sheet(isPresented: self.$showSettings) { Settings() }
                  }
               } else {
                  MenuRow(image: item.icon, text: item.title)
               }
            }
            Spacer()
         }
         .padding(.top, 20)
         .padding(30)
         .frame(minWidth: 0, maxWidth: 360)
         .background(Color("button"))
         .cornerRadius(30)
         .padding(.trailing, 60)
         .shadow(radius: 20)
         .rotation3DEffect(Angle(degrees: show ? 0 : 60), axis: (x: 0, y: 10.0, z: 0))
         .animation(.default)
         .offset(x: show ? 0 : -UIScreen.main.bounds.width)
         .onTapGesture {
            self.show.toggle()
         }
         Spacer()
      }
      .padding(.top, statusBarHeight)
   }
}

struct CircleButton: View {

   var icon = "person.crop.circle"

   var body: some View {
      return HStack {
         Image(systemName: icon)
            .foregroundColor(.primary)
      }
      .frame(width: 44, height: 44)
      .background(Color("button"))
      .cornerRadius(30)
      .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
   }
}

struct MenuButton: View {
   @Binding var show: Bool

   var body: some View {
      return ZStack(alignment: .topLeading) {
         Button(action: { self.show.toggle() }) {
            HStack {
               Spacer()

               Image(systemName: "list.dash")
                  .foregroundColor(.primary)
            }
            .padding(.trailing, 18)
            .frame(width: 90, height: 60)
            .background(Color("button"))
            .cornerRadius(30)
            .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
         }
         Spacer()
      }
   }
}

struct MenuRight: View {

   @Binding var show: Bool
   @State var showUpdate = false

   var body: some View {
      return ZStack(alignment: .topTrailing) {
         HStack {
            Button(action: { self.show.toggle() }) {
               CircleButton(icon: "person.crop.circle")
            }
            Button(action: { self.showUpdate.toggle() }) {
               CircleButton(icon: "bell")
                  .sheet(isPresented: self.$showUpdate) { UpdateList() }
            }
         }
         Spacer()
      }
   }
}
