import SwiftUI
import Playgrounds

struct CardStackStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 100)
            .background(Color.gray.opacity(0.2))
    }
}

extension View {
    func cardStackStyle() -> some View {
        modifier(CardStackStyle())
    }
}

struct CaptchaTile: View {
    let id: Int
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text("\(id)")
                .cardStackStyle()
                .border(isSelected ? Color.blue : Color.clear, width: 3)
        }
        .buttonStyle(.plain)
    }
}

struct TileChallenge {
    let instructions: String
    let tileIds: Array<Int>
    let correctTiles: Set<Int>
}

struct ContentView: View {
    @State private var selectedTiles: Set<Int> = []
    @State private var verifyTapped: Bool = false
    
    let tileChallenge = TileChallenge(
        instructions: "Select tiles 2, 5, and 9",
        tileIds: Array(1...9),
        correctTiles: [2, 5, 9]
    )
    
    var body: some View {
        VStack {
            Text(tileChallenge.instructions)
            
            ScrollView {
                LazyVGrid(columns: [
                    .init(.fixed(100), spacing: 4),
                    .init(.fixed(100), spacing: 4),
                    .init(.fixed(100), spacing: 4)
                ], spacing: 4) {
                    ForEach(tileChallenge.tileIds, id: \.self) { index in
                        CaptchaTile(
                            id: index,
                            isSelected: selectedTiles.contains(index),
                            onTap: { toggleSelection(index) })
                    }
                }
            }
            
            Button("Verify") {
                verifyTapped = true
                print("Verify Clicked")
                for id in selectedTiles {
                    print("\(id)\n")
                }
            }
            .buttonStyle(.borderedProminent)
            
            if verifyTapped == true {
                if selectedTiles == tileChallenge.correctTiles {
                    Text("pass")
                } else {
                    Text("fail")
                }
            }
        }
        .padding()
    }
    
    private func toggleSelection(_ id: Int) {
        verifyTapped = false
        if selectedTiles.contains(id) {
            selectedTiles.remove(id)
        }
        else {
            selectedTiles.insert(id)
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
