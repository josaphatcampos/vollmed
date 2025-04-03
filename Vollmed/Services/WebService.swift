//
//  WebService.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import UIKit

let patientID = "d86a9acb-19e1-4729-9b80-23c7bfdcc4e9"

struct WebService {
    
    private let baseURL = "http://localhost:3000"
    
    func downloadImage(from imageURl: String)async throws -> UIImage?{
        let imageCache = NSCache<NSString, UIImage>()
        
        guard let url = URL(string: imageURl) else { return nil }
        
        if let cachedImage = imageCache.object(forKey: imageURl as NSString) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else { return nil }
        
        imageCache.setObject(image, forKey: imageURl as NSString)
        
        return image
    }
    
    func getAllSpecialists() async throws -> [Specialist]? {
        let endpoint = baseURL + "/especialista"
        guard let url = URL(string: endpoint) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonDecoder = try? JSONDecoder().decode([Specialist].self, from: data) {
            return jsonDecoder
        } else {
            return nil
        }
    }
    
    func scheduleAppointment(specialistId: String, patientId: String, date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta"
        guard let url = URL(string: endpoint) else { return nil }
        
        let appointment = ScheduleAppointmentRequest(specialist: specialistId, patient: patientId, date: date)
        
        let jsonData = try JSONEncoder().encode(appointment)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        
        return appointmentResponse
        
    }
    
    func getAllAppointmentsFromPatient(patientId: String) async throws -> [Appointment]? {
        let endpoint = baseURL + "/paciente/\(patientId)/consultas"
        guard let url = URL(string: endpoint) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let jsonDecoder = try? JSONDecoder().decode([Appointment].self, from: data)
        
        return jsonDecoder
    }
    
    func rescheduleAppointment(appointmentId: String, date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta/\(appointmentId)"
        guard let url = URL(string: endpoint) else { return nil }
        
        let requestData: [String: String] = ["data": date]
        let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        
        return appointmentResponse
    }
    
    func cancelAppointment(appointmentId: String, reasonToCancel: String?) async throws -> Bool {
        let endpoint = baseURL + "/consulta/\(appointmentId)"
        guard let url = URL(string: endpoint) else { return false }
        
        let requestData: [String: String] = ["motivo_cancelamento": reasonToCancel ?? ""]
        let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        
        let (_, Response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = Response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        }
        
        return false
    }
    
    
}
