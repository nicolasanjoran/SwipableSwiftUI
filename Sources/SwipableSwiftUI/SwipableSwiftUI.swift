import SwiftUI
import UIKit

fileprivate struct SwipableContentSizeCalculator: ViewModifier {
    @Binding var size: CGSize
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

fileprivate extension View {
    func saveSwipableSize(in size: Binding<CGSize>) -> some View {
        modifier(SwipableContentSizeCalculator(size: size))
    }
}

public struct Swipable<Content: View> : View {
    private let content: Content
    @State private var contentSize = CGSize()
    
    @State private var offset: CGFloat = 0
    @GestureState private var dragOffset: CGSize = .zero
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    @State private var selection : HorizontalAlignment?
    
    private var leadingColor = Color.purple
    private var trailingColor = Color.blue
    private var leadingIcon = Image(systemName: "placeholdertext.fill")
    private var trailingIcon = Image(systemName: "placeholdertext.fill")
    private var leadingAction : (() -> Void)?
    private var trailingAction : (() -> Void)?
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public func swipeLeading(icon: Image, color: Color, action: @escaping ()->Void) -> Swipable {
        var newView = self
        newView.leadingIcon = icon
        newView.leadingColor = color
        newView.leadingAction = action
        return newView
    }
    
    public func swipeTrailing(icon: Image, color: Color, action: @escaping ()->Void) -> Swipable {
        var newView = self
        newView.trailingIcon = icon
        newView.trailingColor = color
        newView.trailingAction = action
        return newView
    }

    public var body: some View {
        VStack {
            content
                .background(Color.black.opacity(0.00000001))
                .saveSwipableSize(in: $contentSize)
                .overlay(
                    ZStack {
                        HStack {
                            Spacer()
                            leadingIcon
                                .font(.title3)
                                .padding()
                                .foregroundColor(.white)
                                .opacity(offset > 0 ? 1 : 0)
                        }
                        .frame(maxHeight: .infinity)
                        .background(leadingColor)
                        .offset(CGSize(width: -(contentSize.width), height: 0))
                        HStack {
                            trailingIcon
                                .font(.title3)
                                .padding()
                                .foregroundColor(.white)
                                .opacity(offset < 0 ? 1 : 0)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                        .background(trailingColor)
                        .offset(CGSize(width: contentSize.width, height: 0))
                    }
                )
                .offset(CGSize(width: offset, height: 0))
                .highPriorityGesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onChanged { v in
                            var dragOffset = v.translation.width
                            
                            if leadingAction == nil {
                                dragOffset = max(0, dragOffset)
                            }
                            if trailingAction == nil {
                                dragOffset = min(0, dragOffset)
                            }
                            
                            offset = dragOffset
                            if selection == nil {
                                if offset > contentSize.width / 2  {
                                    selection = .leading
                                    impactFeedbackGenerator.impactOccurred()
                                } else if offset < -contentSize.width / 2  {
                                    selection = .trailing
                                    impactFeedbackGenerator.impactOccurred()
                                }
                            } else {
                                if abs(offset) < (contentSize.width / 2 - 20) {
                                    selection = nil
                                    impactFeedbackGenerator.impactOccurred()
                                }
                            }
                        }
                        .updating($dragOffset) { value, state, transaction in
                            state = value.translation
                        }
                        .onEnded { _ in
                            withAnimation {
                                if selection == .leading {
                                    self.leadingAction?()
                                } else if selection == .trailing {
                                    self.trailingAction?()
                                }
                                offset = 0
                                selection = nil
                            }
                        }
                )
        }.frame(maxWidth: .infinity)
            .clipped()
    }
}

