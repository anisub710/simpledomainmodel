//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var converted = commonCurr(self.amount, self.currency)
    switch to {
    case "USD":
        converted = converted * 2
    case "EUR":
        converted = converted * 3
    case "CAN":
        converted = (5 * converted) / 2
    default:
        break
    }
    return Money(amount: converted, currency: to)
  }
  
    private func commonCurr(_ amount: Int, _ curr: String) -> Int {
        var result = 0
        switch curr {
        case "USD":
            result = amount / 2
        case "EUR":
            result = amount / 3
        case "CAN":
            result = (2 * amount) / 5
        default:
            result = amount
        }
        return result
        
    }
  public func add(_ to: Money) -> Money {
    if self.currency == to.currency {
        return Money(amount: self.amount + to.amount, currency: self.currency)
    }
    return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    if self.currency == from.currency {
        return Money(amount: self.amount - from.amount, currency: self.currency)
    }
    return Money(amount: self.convert(from.currency).amount - from.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    var income = 0
    switch self.type {
    case let JobType.Hourly(currIncome):
        income = Int(currIncome * Double(hours))
    case let JobType.Salary(currIncome):
        income = currIncome
    }
    return income
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case let JobType.Hourly(currIncome):
        self.type = JobType.Hourly(currIncome + amt)
    case let JobType.Salary(currIncome):
        self.type = JobType.Salary(currIncome + Int(amt))
    }
  }
    
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job}
    set(value) {
        _job = (self.age >= 16) ? value : nil
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse}
    set(value) {
        _spouse = (self.age >= 18) ? value : nil
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job?.type)) spouse:\(String(describing: self.spouse?.firstName))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        self.members.append(spouse1)
        spouse2.spouse = spouse1
        self.members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age > 21 || members[1].age > 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var sum = 0
    for member in members {
        sum += (member.job != nil) ? member.job!.calculateIncome(2000) : 0
    }
    return sum
  }
}





