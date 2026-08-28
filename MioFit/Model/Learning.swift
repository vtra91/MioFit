import SwiftUI

struct Learning: View {
    @State var isOn = false
    var body: some View {
        ZStack {
            Color.red
            VStack {
                Form {
                    Text("dsfadf")
                    List {
                        Text("123")
                        Circle() .frame(width: 30)
                        Text("45")
                    }
                    Section(header: Toggle(isOn: $isOn) { Text("123")}) {
                        Text("123")
                        Circle() .frame(width: 30)
                        Text("45")
                    }
                }
            }
        }
    }
}

#Preview {
    Learning()
}
