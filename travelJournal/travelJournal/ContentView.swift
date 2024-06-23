import SwiftUI

// This structure represents an item in the itinerary
struct ItineraryItem: Identifiable {
    var id = UUID() // Unique id made for all of the items
    var title: String // The title of the itinerary item
    var details: String // The details about the event
    var image: UIImage? // The user can input a picture if they want but don't have to
}

// This structure defines the user interface
struct ContentView: View {
    // Declare variables
    @State private var itineraryItems: [ItineraryItem] = []
    @State private var showingAddItemView = false
    @State private var newItemTitle = ""
    @State private var newItemDetails = ""
    @State private var newItemImage: UIImage?
    @State private var showingImagePicker = false

    // body handles the layout and resizes the pictures so we can preview them from the main page
    var body: some View {
        NavigationView {
            List {
                // For every item in the itinerary it shows the smaller picture, the title, and the detials.
                ForEach(itineraryItems) { item in
                    HStack {
                        if let image = item.image {
                            // This resizes the picture
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        // This displays the title and details on the main page
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.details)
                                .font(.subheadline)
                        }
                    }
                }
                // This enables the ios swipe to delete function
                .onDelete(perform: deleteItems)
            }
            // This section handles the navigation part up top
            .navigationBarTitle("Travel Journal Itinerary")
            .navigationBarItems(
                leading: EditButton(), // leading mean its on the left
                trailing: Button(action: { // trailing mean its on the right
                    showingAddItemView.toggle() // this toggle controls if we can see the screen with the add item page
                }) {
                    Image(systemName: "plus")
                }
            )
            // This section handles the screen where we add items
            .sheet(isPresented: $showingAddItemView) {
                // This is layout on the add screen
                VStack {
                    TextField("Title", text: $newItemTitle)
                        .padding()
                    TextField("Details", text: $newItemDetails)
                        .padding()
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Select Photo")
                    }
                    .padding()
                    if let image = newItemImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    // When this button is selected the information is added to the itinerary item list
                    Button("Add Item") {
                        let newItem = ItineraryItem(title: newItemTitle, details: newItemDetails, image: newItemImage)
                        itineraryItems.append(newItem)
                        newItemTitle = ""
                        newItemDetails = ""
                        newItemImage = nil
                        showingAddItemView = false
                    }
                    .padding()
                }
                .padding()
                // This screen is what pops up when selecting an image. The code for ImagePicker is in a seperate file
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $newItemImage)
                }
            }
        }
    }

    // This function deletes the selected item from the list
    private func deleteItems(at offsets: IndexSet) {
        itineraryItems.remove(atOffsets: offsets)
    }
}
