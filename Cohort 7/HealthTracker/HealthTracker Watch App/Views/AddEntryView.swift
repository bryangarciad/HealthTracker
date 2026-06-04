import SwiftUI
import WatchKit

struct AddEntryView: View {
    @ObservedObject var healtViewModel: HealthViewModel
    let entryType: EntryType
    
    @State private var selectedAmount: Double = 100.0
    @Environment(\.dismiss) private var dismiss
    
    let presets: [Double] = [200, 300, 500]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: entryType.icon)
                    .font(.system(size: 24))
                    .foregroundColor(entryType.color)
                
                Text("Add \(entryType.rawValue)")
                    .font(.system(size: 12, weight: .medium))
                
                Text("\(Int(selectedAmount))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(entryType.color)
                
                HStack(spacing: 8) {
                    ForEach(presets, id: \.self) { preset in
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            selectedAmount = preset
                        } label: {
                            Text("+\(Int(preset))")
                                .font(.system(size: 12, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .background(selectedAmount == preset ? entryType.color : Color.gray.opacity(0.3))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddEntryView(healtViewModel: HealthViewModel(), entryType: .calories)
    }
}
