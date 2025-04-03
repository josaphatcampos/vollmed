//
//  MyAppointmentView.swift
//  Vollmed
//
//  Created by Josaphat Campos Pereira on 02/04/25.
//

import SwiftUI

struct MyAppointmentView: View {
    
    let service = WebService()
    
    @State var appointments: [Appointment] = []
    
    func fetchData() async {
        do{
            if let data = try await service.getAllAppointmentsFromPatient(patientId: patientID) {
                appointments = data
            }
        }catch {
            print("Error: \(error)")
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            ForEach(appointments) { appointment in
                SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
            }
            
        }
        .navigationBarTitle("Minhas Consultas")
        .navigationBarTitleDisplayMode(.large)
        .onAppear{
            Task {
                await fetchData()
            }
        }
    }
}

#Preview {
    MyAppointmentView()
}
