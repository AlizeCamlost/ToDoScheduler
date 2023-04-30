//
//  SecondUserDataView.swift
//  ToDoScheduler
//
//  Created by Tiancheng Xu on 23/4/2023.
//
import SwiftUI

struct UserSettingView: View {
    @EnvironmentObject var taskData: Tasks
    
    @State private var name = ""

    @State private var d1 = ""
    @State private var t1 = ""

    @State private var address = ""
    @State private var mode = false
    @State private var birthday = Date()
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    @AppStorage("isDarkMode") private var isDark = false
    @State var showWorkDayView = false

//    @State var days: [String] = []
//    let dayNames = ["Sun","Mon","Tue","Wed","Thur","Fri","Sat"]

    func saveUser(){
        print("saved!")

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let birthdayStr = dateformatter.string(from: birthday)
        if name != ""{
            taskData.globalStoreData.username = name
        }
        if address != ""{
            taskData.globalStoreData.userAddress = address
        }
        taskData.globalStoreData.userBirthday = birthdayStr
        taskData.testprint()
        taskData.saveData()
    }
    
    var body: some View {
        
        NavigationView{
            Form{
                general
                setting
                //statistic
            }
            .navigationTitle("Account")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button{
                        hideKeyboard()
                    }label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    Button("Save",action:saveUser)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
        .environment(\.colorScheme, isDark ? .dark : .light)

    }
}


private extension UserSettingView{
    var general: some View{
        Section(header:Text("Peronal Infomation")){
            VStack{
                Button{
                    shouldShowImagePicker.toggle()
                }label: {
                    VStack{
                        if let img = self.image{
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width:100, height: 100)
                                .cornerRadius(80)
                            
                        }else{
                            Image(systemName:"person.fill")
                                .font(.system(size:60))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                    }.overlay(RoundedRectangle(cornerRadius: 80)
                        .stroke(Color.black, lineWidth: 2))
                }
                Spacer()
                if (taskData.globalStoreData.username == ""){
                    TextField("Enter your name", text: $name)
                }else{
                    TextField("name", text: $taskData.globalStoreData.username)
                }
                
                DatePicker("Birthdate", selection: $birthday, displayedComponents: .date)

                if (taskData.globalStoreData.userAddress == ""){
                    TextField("Enter your address", text: $address)
                }else{
                    TextField("name", text: $taskData.globalStoreData.userAddress)
                }
            }
        }
    }
}

private extension UserSettingView{

    var setting: some View{
        Section(header:Text("Settings")){
            Toggle("Dark Mode", isOn: $isDark)
            HStack{
                Text("WorkDays")
                Spacer()

                
                Image(systemName: "chevron.right")
                    .opacity(0.5)
                    .font(.system(size:14))

            }
            .onTapGesture {showWorkDayView = true}
            .sheet(isPresented: $showWorkDayView){
                AddWorkDay()
            }
            

        }
    }
}

private extension UserSettingView{
    var statistic: some View{
        Section(header:Text("Settings")){
            HStack{
                TextField("statistic 1", text: $t1)

            }

        }
    }
}

struct ImagePicker: UIViewControllerRepresentable{
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        let parent: ImagePicker
        init(parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }

}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
            .environmentObject(Tasks())
    }
}
