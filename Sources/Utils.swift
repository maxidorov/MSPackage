//
//  File.swift
//  
//
//  Created by MSP on 08.09.2022.
//

func modify<T>(_ a: inout T, _ f: (inout T) -> Void) {
  f(&a)
}

func modified<T>(_ a: T, _ f: (inout T) -> Void) -> T {
  var a = a
  f(&a)
  return a
}

func mapModified<T>(_ a: [T], _ f: (inout T) -> Void) -> [T] {
  a.map { modified($0, f) }
}
