import UIKit

let name = "TayTay"

for letter in name {
    print("Give me a \(letter)...")
}

//we can't directly subscript a string, because they're not arrays, they're different
//some strings have special characters and so on
//so the next sentece is invalid
// print(name[3])

//if we wanted to do subscripting we could write the following

let letter = name[name.index(name.startIndex, offsetBy: 3)]
//will access name as an array, obtain the index of the first non-empty character and offset it by 3, so we could access the 4th character of the string
//this is not efficient, as with count, swift would need to get inside the string and count every single character
//if we want to verify that a string is empty is better to just use the corresponding isEmpty method.

//we could also extend the string protocol and adapt the subscript
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[2]


//important methods for strings
let password = "123456"
password.hasPrefix("123") //let us know if the string has a certain prefix, returns a boolean
password.hasSuffix("456") //let us know if the string has a certain suffix, returns a boolean

//extending the string protocol again, this time we add a method to get the string back without the suffix or prefix
// 123345 -> deletingPrefix("123") -> 456
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {return self}
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

print(password.deletingPrefix("123"))
print(password.deletingSuffix("456"))


//capitalizes each of the string words
let weather = "it's going to rain"
print(weather.capitalized)

//we are overriding the method to capitalize only the first letter of the string

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

weather.capitalizedFirst


//returns false or true depending if the parameter string is contained in the string
let input = "Swift is like Objective-C without C"
input.contains("Swift")

let langauges = ["Python", "C++", "Swift"]
langauges.contains("Swift")
//we can get an extension to verify if the string contains any of the strings in the array
extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}
//it works, but is not elegant and swift has a second contain method, that accepts a closure
input.containsAny(of: langauges)

//array.contains will loop and pass as parameters each of its elements to input.contains, so for every element in the array it is asking if the input contains it, if one of its elements is indeed contained the loop will stop and return true
//the line between functions, closures and methods is very blurred on swift
langauges.contains(where: input.contains)


//there are another type of strings that can have more properties than a normal string, these are the NSAttributedStrings.
//you can write a set of attributes to affect the whole string,
let exampleString = "I'm just a test string, be patient"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 34)
]

let attributedString = NSAttributedString(string: exampleString, attributes: attributes)

//uilabel can seem similar, but what it won't let us allow is modify each part of the string, something we can do with AttributedStrings...
let attributedStringMutable = NSMutableAttributedString(string: exampleString)

attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 8*2), range: NSRange(location: 5, length: 2))
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 8*3), range: NSRange(location: 8, length: 1))
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 8*4), range: NSRange(location: 10, length: 4))
attributedStringMutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 8*5), range: NSRange(location: 15, length: 6))


//challenge

//create a string extension that adds a withPrefix() Method

extension String {
    func withPrefix(_ string: String) -> String {
        guard !self.hasPrefix(string) else { return self }
        return string + self
    }
}

let challengeOneString1 = "Concerning Hobbits..."
challengeOneString1.withPrefix("Concerning")
let challengeOneString2 = ", or there and back again"
challengeOneString2.withPrefix("The Hobbit")

//create a isNumeric property returning a bool
extension String {
    func isNumeric() -> Bool {
        guard (Double(self) != nil) else { return false }
        return true
    }
}

let challengeTwoString1 = "I'm not a number"
let challengeTwoString2 = "1605"

challengeTwoString1.isNumeric()
challengeTwoString2.isNumeric()

//create a extension that adds a lines property returning an array of all the lines in a string "this \n is \n a \n test" should return an array of 4 elements

let challengeThreeString = "I'm \n just \n a \n test."


extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

challengeThreeString.lines
