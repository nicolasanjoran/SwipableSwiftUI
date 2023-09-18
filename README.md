# SwipableSwiftUI

A small package to make a view swipable like native List rows (or UITableView rows), outside of a List, for example in a ScrollView.

> [!IMPORTANT]
> This package only supports "full" swipes, with a single action for each side.

**Requirements:**
- iOS 14+

## Example

```swift
VStack {
    Swipable {
        Button {
            print("Button tapped")
        } label: {
            HStack {
                Image(systemName: "person.crop.circle.fill").font(.largeTitle)
                VStack(alignment: .leading) {
                    Text("Person Name").foregroundColor(.primary)
                    Text("Job name").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .padding()
        }
    }
    .swipeLeading(icon: Image(systemName: "text.line.first.and.arrowtriangle.forward"), color: Color.purple) {
        print("Leading Action!!!!")
    }
    .swipeTrailing(icon: Image(systemName: "text.line.last.and.arrowtriangle.forward"), color: Color.blue) {
        print("Trailing Action!!!!")
    }
}
```
