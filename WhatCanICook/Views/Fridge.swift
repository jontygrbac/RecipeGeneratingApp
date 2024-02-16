//
//  Fridge.swift
//  WhatCanICook
//
//  Created by Jonty Grbac on 4/10/2023.
//

import SwiftUI

struct Fridge: View {
    /// Core Data context
    @Environment(\.managedObjectContext) var context
    /// Variable to hold ChatGPT messages
    @State private var chatMessages: [ChatMessage] = []
    /// Variable to hold the body of the API request
    @State private var message: String = ""
    /// Variable used to hold who sent the last message, would be used in multiple regeneration
    @State var lastMessageID: String = ""
    /// Variable to hold temp recipe name
    @State var unsavedRecipeName = ""
    /// Variable to hold temp recipe ingredient
    @State var unsavedRecipeIngredient = ""
    /// Variable to hold temp recipe method
    @State var unsavedRecipeMethod = ""
    /// Variable to hold temp icon, using the option selected
    @State var unsavedIcon = ""
    /// Object used for creating the recipe
    @State private var recipe: RecipeCoreItem = RecipeCoreItem()
    
    /// Array  to hold ingredients
    @State private var ingredients: [String] = [];
    /// String to contain textfield entry
    @State private var ingredient: String = "";
    
    /// Array to hold customization
    @State private var selection = "Breakfast"
    let options = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    /// IsLoading is used to display progress view and ensure that multiple API requests aren't sent
    @State var isLoading = false
    /// toggleView is utilized to update the view to the temporary recipe
    @State var toggleView = false
    /// Set to true after a recipe has been created, adds a return button to the generate recipe screen
    @State var toggleReturn = false
    
    /// Fetching allergie requirements
    /// Allergies is an array that contains the results of the fetch
    @FetchRequest(
        entity: AllergiesCoreItem.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \AllergiesCoreItem.id, ascending: false) ])
    var allergies: FetchedResults<AllergiesCoreItem>
    
    /// Fetching Diet requirements
    /// Diet is an array holding the results of the fetch
    @FetchRequest(
        entity: DietCoreItem.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \DietCoreItem.id, ascending: false) ])
    var diet: FetchedResults<DietCoreItem>
    
    var body: some View {
        NavigationView{
            if toggleView{
                ScrollView{
                    HStack{
                        Button(){
                            toggleView = false
                        }
                    label: {
                        Text("Return")
                        Image(systemName: "arrow.counterclockwise")
                    }.padding().background(.blue).foregroundColor(.white).cornerRadius(20).font(.title2)
                        Button(){
                            saveRecipe()
                            //to be implemented
                        }label: {
                            Text("Save")
                            Image(systemName: "heart.fill")
                        }.padding().background(.red).foregroundColor(.white).cornerRadius(20).font(.title2)
                        
                    }
                    UnsavedRecipe(name: unsavedRecipeName, ingredient: unsavedRecipeIngredient, method: unsavedRecipeMethod)
                }.frame(maxWidth: .infinity)
                    .background(.green.opacity(0.2))
            }
            else{
                VStack(spacing: 20) {
                    /// Page Title
                    HStack {
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundColor(.black) /// Adjusted color
                        Text("Ingredients")
                            .font(.custom("Arial Rounded MT Bold", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.primary) /// Adjusted color
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundColor(.black) /// Adjusted color
                    }
                    .padding(.vertical, 10)
                    
                    /// Ingredient Enter Field
                    HStack(spacing: 10) {
                        TextField(
                            "Enter Ingredient",
                            text: $ingredient
                        )
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 10) /// Added horizontal padding
                        
                        Button(action: {
                            if ingredient != "" {
                                ingredients.append(ingredient)
                                ingredient = ""
                            }
                        }) {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus.square.fill")
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .font(.title2)
                        }
                    }
                    .padding()
                    
                    /// Generating Recipe, send API message to ChatGPT
                    HStack{
                        if toggleReturn {
                            Button{
                                toggleView = !toggleView
                            } label: {
                                HStack{
                                    Text("Return")
                                    Image(systemName: "arrow.counterclockwise")
                                }.padding().background(.blue).foregroundColor(.white).cornerRadius(20).font(.title2)
                            }
                        }
                        
                        Button{
                            Task {
                                await sendMessage()
                            }
                        } label: {
                            if !isLoading {
                                HStack{
                                    Text("Generate Recipe")
                                    Image(systemName: "arrow.right.circle.fill")
                                }.padding().background(.black).foregroundColor(.white).cornerRadius(20).font(.title2)
                            } else {
                                /// Show spinning progress wheel
                                VStack{
                                    Text("Generating Recipe...")
                                    ProgressView().progressViewStyle(.automatic).controlSize(.large)
                                }
                            }
                        }.disabled(isLoading)
                        if !toggleReturn {
                            Picker("Select an option", selection: $selection) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .font(.title2)
                        }
                    }
                    
                    if toggleReturn {
                        Picker("Select an option", selection: $selection) {
                                        ForEach(options, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .font(.title2)
                    }
                    

                    
                    /// Movable and Deletable list items
                    VStack { /// add a box for the user to view the recipes and knowing where it will be added
                        List {
                            ForEach(ingredients, id: \.self) { ingredient in
                                HStack {
                                    Text(ingredient)
                                        .font(.title2)
                                }
                                .padding(.vertical, 5)
                            }
                            .onDelete { index in
                                ingredients.remove(atOffsets: index)
                            }
                            .onMove { from, to in
                                ingredients.move(fromOffsets: from, toOffset: to)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(10)

                        /// Add a box around the List
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 5)
                        )
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(10)
                }.background(.green.opacity(0.2))
            }
        }
    }
    
    /**
     ## Description
     Function used to create the API request, handles the general pipeline of the request.
     
     It calls the function getOpenAIChatResponse()
     
     Also calls the recipeSplit() function
    */
    func sendMessage() async {
        guard !ingredients.isEmpty else {return}
        message = "Generate a "
        if diet.count == 1{
            if diet[0].name != "Default"{
                message += "\(diet[0].name) "
                
            }
        }
        message += selection
        message += " recipe with the following ingredients: "
        chatMessages.removeAll()
        
        let items: String = ingredients.joined(separator: ", ")
        message += items
        
        if allergies.count != 0 {
            message += ". Please exclude the following ingredients for allergies:"
            
            for index in 0..<allergies.count{
                if index == (allergies.count - 1){
                    message += " \(allergies[index].name)."
                }
                else {
                    message += " \(allergies[index].name),"
                }
            }
        }
        else {
            message += ". You can add or remove any ingredients based on what you may need."
        }
        
        message += " Reply in the format of title: title of recipe, ingredients, method."
        
        /// set loading state
        isLoading = true
        
        /// create a message object and store it to display
        let userMessage = ChatMessage(id: UUID().uuidString, content: message, createdAt: Date(), sender: .user)
        chatMessages.append(userMessage)
        lastMessageID = userMessage.id
        
        /// create the body for the request
        let currentMessages: [Message] = chatMessages.map { Message(role: ($0.sender == .user) ? "user" : "system", content: $0.content) }
        
        chatMessages.removeLast()
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: currentMessages)
        
        guard let openAIResult = await getOpenAIChatResponse(body)
        else {
            isLoading = false
            return
        }
        
        // get the text response and create a new message from it
        guard let textResponse = openAIResult.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
        
        /// create the message
        let systemMessage = ChatMessage(id: openAIResult.id, content: textResponse, createdAt: Date(), sender: .system)
        
        /// append the latest message and update last id
        chatMessages.removeAll()
        chatMessages.append(systemMessage)
        lastMessageID = systemMessage.id
        
        /// reset message after send
        recipeSplit(full_recipe: chatMessages[0].content)
        message = ""
        ingredients = []
        isLoading = false
        toggleView = true
    }
    
    /**
     ## Description
     Function used to handle URL session
     
     Returns the results of the API request
    */
    func getOpenAIChatResponse(_ body: OpenAIChatBody) async -> OpenAIResult? {
        /// create a messsage request with the bearer token in the header
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.addValue("Bearer \(Constants.OPEN_API_KEY)", forHTTPHeaderField: "Authorization")
        
        /// set the content type to json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.timeoutInterval = 60
        /// encode the body as json
        let jsonData = try? JSONEncoder().encode(body)
        
        print(body)
        /// set request to post type and set the body
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        /// call the api and decode the response
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(OpenAIResult.self, from: data)
        } catch {
            print("Unable to send message or decode response: \(error)")
            return nil
        }
        
    }
    
    /**
     ## Description
     Function used to split up the recipe into it's individual sections; title, ingredient and method
     
     Sets the temporary fields to these values
    */
    func recipeSplit (full_recipe: String){
        /// Splitting the recipe based on title, ingredients and method
        let x = full_recipe.split(separator: "Title:")
        
        let y = String(x[0]).split(separator: "Ingredients:")
        
        var z: Array<Substring>
        
        /// Sanity checks to ensure that if split failed we return
        if y.count > 1  {
            z = String(y[1]).split(separator: "Method:")
        }
        else {
            print("Returning as y = 1")
            return
        }
        
        let name = String(y[0])
        var i: String
        var method: String
        
        /// Sanity check to ensure that final split has worked
        if z.count > 1{
            i = String(z[0])
            method = String(z[1])
        }
        else {
            print("Returning because z < 2")
            return
        }
        
        /// Set temporary fields to split api response
        unsavedRecipeName = name
        unsavedRecipeIngredient = i
        unsavedRecipeMethod = method
        unsavedIcon = selection
        toggleReturn = true
    }
    /**
     ## Description
     Function used to handle the creation and saving of recipes to Core Data
     
     Returns nil
    */
    func saveRecipe() {
        /// Create new recipe
        let newRecipe = RecipeCoreItem(context: context)
        
        /// Save neccessary values
        newRecipe.id = UUID()
        newRecipe.name = unsavedRecipeName
        newRecipe.ingredients = unsavedRecipeIngredient
        newRecipe.method = unsavedRecipeMethod
        newRecipe.priority = .normal
        newRecipe.icon = unsavedIcon
        
        /// Store to context
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}



struct Fridge_Previews: PreviewProvider {
    static var previews: some View {
        Fridge().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

