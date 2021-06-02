//
// UserCount.swift
// Habits
//


import Foundation

struct UserCount {
    let user: User
    let count: Int
}

extension UserCount: Codable { }

extension UserCount: Hashable { }
