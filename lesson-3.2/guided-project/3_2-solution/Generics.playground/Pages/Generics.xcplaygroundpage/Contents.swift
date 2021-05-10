// Arrays are defined generically
// struct Array<Element> {}

let ints = [1, 2, 3, 4]

var wholeNumbers: [Int] = []
var otherNumbers: Array<Int> = Array<Int>()
var strings: [String] = []
var otherStrings: Array<String> = Array<String>()

// Dictionaries are also defined generically
// Definition of Dictionary with constraint on the Key generic
//struct Dictionary<Key, Value> where Key : Hashable {}

// Generic constraints can be expressed two ways (above with where clause, or as below)
// struct Dictionary<Key: Hashable, Value> {}

let wordsByLength = [
  1: ["a", "i"],
  2: ["hi", "by", "go"]
]

var numberIndexedDictionary: [Int: [String]] = [:]
var formalDictionary: Dictionary<Int, [String]> = Dictionary<Int, [String]>()
var superFormalDictionary: Dictionary<Int, Array<String>> = Dictionary<Int, Array<String>>()

// Functions can also be generic
// Below is an example of a function restricted to only operating on integers
func max(_ x: Int, _ y: Int) -> Int {
  if x >= y {
    return x
  } else {
    return y
  }
}

// The same function, but defined generically, can now operate on any values
// as long as they conform to the Comparable protocol, that both values
// passed in are the same type, and that the return value is also of the same type.
func max<T>(_ x: T, _ y: T) -> T where T : Comparable {
  if x >= y {
    return x
  } else {
    return y
  }
}

