//: Playground - noun: a place where people can play

import UIKit

let optionalInt: Int? = 5

if (optionalInt != nil) {
    print("optionalInt is equal to \(optionalInt)")
} else {
    print("optionalInt is nil")
}

// Forced Unwrapping
// risky (may cause a crash), can be used if we're sure optionalInt has a value
let forcedInt: Int = optionalInt!
print("optionalInt is equal to \(optionalInt!)")

// Implicitly unwrapped optional
let assumedInt: Int! = 123
let implicitInt: Int = assumedInt

// Optional Binding
if let constantInt = optionalInt {
    print("optionalInt is equal to \(constantInt)")
} else {
    print("optionalInt is nil")
}

// Nil coalescing (same two lines)
let result = optionalInt != nil ? optionalInt! : 0
let resultShortcut = optionalInt ?? 0

print(result)
print(resultShortcut)

// Optional Chaining
if let difference = optionalInt?.distance(to: 10) {
    print("difference between optionalInt and 10 equals: \(difference)")
} else {
    print("there is no difference")
}


