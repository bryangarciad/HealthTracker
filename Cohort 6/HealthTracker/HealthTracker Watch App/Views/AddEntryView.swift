import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: HealtTrackerViewModel
    let entryType: EntryType
    
    @State private var selectedAmount: Double = 0
    @Environment(\.dismiss) private var dismiss
    
    private var quickAddOptions: [Double] {
        return [100, 200, 300, 500]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(systemName: entryType.icon)
                    .font(.system(size: 28))
                    .foregroundColor(entryType.color)
                
                Text("Add \(entryType.displayName)")
                    .font(.system(size: 14, weight: .medium))
                
                Text("\(Int(selectedAmount))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(entryType.color)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    ForEach(quickAddOptions, id: \.self) { amount in
                        Button {
                            selectedAmount = amount
                        } label: {
                            Text("+\(Int(amount))")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedAmount == amount ? entryType.color : entryType.color.opacity(0.3))
                                .foregroundColor(selectedAmount == amount ? .black : .white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                HStack {
                    // Minus
                    Button {
                        selectedAmount = max(0, selectedAmount - 10)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    Text("Adjust")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Spacer()
                    
                    Button {
                        selectedAmount += 10
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 8)
                
                Button {
                    if entryType == .calories {
                        viewModel.addCalories(selectedAmount)
                    } else {
                        viewModel.addWater(selectedAmount)
                    }
                    dismiss()
                } label: {
                    Text("Add")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedAmount > 0 ? entryType.color : Color.gray.opacity(0.3))
                        .foregroundColor(selectedAmount > 0 ? .black : .gray)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(selectedAmount == 0)
            }
            .padding(8)
        }
        .navigationTitle(entryType.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddEntryView(
        viewModel: HealtTrackerViewModel(), entryType: .calories
    )
}
