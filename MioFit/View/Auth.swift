import SwiftUI

struct Auth: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    //TODO: Вынести поля в VM
    @State var loginInput: String = ""
    @State var passwordInput: String = ""

    var isNotEmpty: Bool { !loginInput.isEmpty && !passwordInput.isEmpty }
    var body: some View {
        ZStack {
            Color.mainColorBG
            VStack {
                Text("МиоТренинг")
                    .font(.largeTitle).bold()
                    .foregroundStyle(Color.mainColorBlack)
                LoginInputField(label: "Логин",placeholder: "Введите логин", isPassword: false, input: $loginInput)
                    .padding(.bottom,4)
                LoginInputField(label: "Пароль",placeholder: "Введите пароль", isPassword: true ,input: $passwordInput)
                Button (
                    action: {
                        
                    }, label: {
                        Text("Войти")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(isNotEmpty ? Color.blue : Color.blue.opacity(0.5))

                            }

                    }
                )
                .disabled(!isNotEmpty)
                .padding()
                
                Button (
                    action: {
                        
                    }, label: {
                        Text("Забыли пароль?")
                    }
                )
 

            }
            .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
        }
        .onTapGesture(count: 2) {
            isDarkMode.toggle()
        }
        .ignoresSafeArea()
    }
}
struct LoginInputField: View {
    var label: String
    var placeholder: String
    var isPassword: Bool
    @Binding var input: String
    @State var isPrivate: Bool = false
    

    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .foregroundStyle(Color.lightGrayText)
                    .padding(.leading, 16)
                Spacer()
            }
            
            //TODO: пофиксить скрывающуюся клавиатуру при смене приватности пароля
            if isPrivate {
                SecureField(placeholder, text: $input)
                    .passwordFieldStyle()
                    .eye(isPassword, $isPrivate, isEyeOpened: isPrivate)
            } else {
                TextField(placeholder, text: $input)
                    .passwordFieldStyle()
                    .eye(isPassword, $isPrivate, isEyeOpened: isPrivate)
            }

        }
        .padding(.horizontal)
    }
}
extension Color {
    static var lightGrayBackground: Color { Color.gray.opacity(0.2)}
    static var lightGrayText: Color { .black.opacity(0.6)}
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension View {
    func passwordFieldStyle() -> some View {
        self
            .textFieldStyle(.plain)
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background() {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        }
    }
    func eye(_ isPassword: Bool, _ isPrivate:  Binding<Bool>, isEyeOpened: Bool)  -> some View {
        self
            .overlay {
            if isPassword
                {
                HStack {
                    Spacer()
                        Button(
                            action: {
                                withAnimation(.easeInOut(duration:0.2)) {
                                    isPrivate.wrappedValue.toggle()
                                }
                            },
                            label: {
                                Image(systemName: isEyeOpened ? "eye.slash" : "eye")
                                    .foregroundStyle(Color.lightGrayText)
                            }
                        )
                        .padding(.trailing)
                    }
                }
        }
    }
}
#Preview {
    Auth()
}
