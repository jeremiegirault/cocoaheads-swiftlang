//: Playground - noun: a place where people can play

import UIKit

//
// Tuples
// ==================================================

// anonymous
let tu = (42, "Hello")
tu.0
tu.1

// named
let ntu = (num: 42, str: "Hello")
ntu.num

typealias TupleNumStr = (num: Int, str: String)
let ntu2: TupleNumStr = (42, "Hello")
// let ntu21: TupleNumStr = ("Hello", 42) // error: order is important without name !

// pattern matching
let ntu3 = (str:"Hello", num:42)
let ntu4: TupleNumStr = ntu3

let (str, num) = ntu3
num
str






























//
// Funcs
// ==================================================

//
// closure form ...
//
let hello1 = { (name: String) -> String in return "Hello " + name }
hello1("Bob")

// ... with inference
let hello2 = { name in return "Hello " + name }
hello2("Bob")

//
// Parameter naming
//

func say1(what: String, to: String) -> String {
    return what + " " + to
}
// in free functions parameter names are ommited by default
// (think C-like)
say1("Hello", "Bob")

// with same external / internal name
func say3(#what: String, to username: String) -> String {
    return what + " " + username
}
say3(what: "Hello", to: "Bob")

// different behavior in classes :
// * for functions arg1 is external unnamed and following are same-named
// * for constructors all args are same-named
class F {
    let result: String
    init(to: String) {
        result = "Hello " + to
    }
    
    init(_ what: String, _ to: String) {
        result = what + " " + to
    }
    
    func say1(what: String, to: String) -> String {
        return what + " " + to
    }
    
    // _ for ignore external name explicitely
    func say2(#what: String, _ to: String) -> String {
        return what + " " + to
    }
}

let f1 = F(to: "World")
let f2 = F("Hello", "World")

f1.say1("Hello", to: "World")
f1.say2(what: "Hello", "World")

// default behaviors can be overriden
































//
// Optionals
// ==================================================


let o1: String? = nil // explicitely unwrapped
let o2: String! = nil // implicitely unwrapped
let o3: String? = "~"
let o4: String! = "~"

o1?.stringByExpandingTildeInPath
//o2.stringByExpandingTildeInPath // crash !
o3?.stringByExpandingTildeInPath
o4.stringByExpandingTildeInPath

// if let unwrapping
if let o5 = o3,
    let o6 = o4
    where o6 == o3 { // + conditions
    o5.stringByExpandingTildeInPath
    o6.stringByExpandingTildeInPath
}

//
// Casts
// ==================================================

let c: AnyObject = "Hello"
c as? String
c as? Int
c as! String
// c as! Int // crash !

// works with if let unwrapping
if let c1 = c as? String {
    c1
}

// rule of thumb: never use !
// this is only due to unknowns from objc interop




























//
// Generics
// ==================================================

protocol Cache {
    typealias Key
    typealias Value
    
    func valueForKey(key: Key) -> Value?
    func setValue(value: Value, forKey: Key)
}

class MemCache<K: Hashable, V>: Cache {
    typealias Key = K
    typealias Value = V
    
    var cache: [K:V] = [:]
    
    func valueForKey(key: Key) -> Value? {
        return cache[key]
    }
    
    func setValue(value: Value, forKey key: Key) {
        cache[key] = value
    }
}

typealias HTTPResponse = (url: String, fetchedAt: NSDate)

class HTTPClient<C: Cache where C.Key == String, C.Value == HTTPResponse> {
    let cache: C
    init(_ cache: C) {
        self.cache = cache
    }
    
    func get(url: String) -> HTTPResponse {
        if let result = cache.valueForKey(url) {
            return result
        }
        
        let res = (url, NSDate())
        cache.setValue(res, forKey: url)
        return res
    }
}

let cache = MemCache<String, HTTPResponse>()
let client = HTTPClient(cache)
client.get("http://google.fr").fetchedAt.timeIntervalSinceReferenceDate
client.get("http://google.fr").fetchedAt.timeIntervalSinceReferenceDate
