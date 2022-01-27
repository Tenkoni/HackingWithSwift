import UIKit

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration, delay: 0) { [weak self] in
            self?.transform.scaledBy(x: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
view.backgroundColor = .red
view.layer.cornerRadius = 125
view.bounceOut(duration: 5)



extension Int {
    func times(_ doAction: () -> Void) {
        for _ in 0..<abs(self) {
            doAction()
        }
    }
}

6.times {
    print("Hello World!")
}
let minus = -2
minus.times {
    print("Negative Hello world?!")
}

extension Array where Element: Comparable{
    mutating func remove(item: Element) {
        guard let elementToRemove = self.firstIndex(of: item) else { return }
        self.remove(at: elementToRemove)
    }
}

var testArray = ["Sauna", "Mämmi", "Suomi", "Finland", "Sauna"]

testArray.remove(item: "Sauna")

print(testArray)
