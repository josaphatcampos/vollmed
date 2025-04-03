//
//  Appointment.swift
//  Vollmed
//
//  Created by Josaphat Campos Pereira on 03/04/25.
//

import Foundation

struct Appointment: Codable, Identifiable{
    let id: String
    let date: String
    let specialist: Specialist
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "data"
        case specialist = "especialista"
    }
}
