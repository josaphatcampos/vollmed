//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Josaphat Campos Pereira on 02/04/25.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let service = WebService()
    var specialistId: String
    let isRescheduledView: Bool
    let appointmentId: String?
    
    @State private var selectedDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var isAppointmentScheduled: Bool = false
    
    init(specialistId: String, isRescheduledView: Bool = false, appointmentId: String? = nil) {
        self.specialistId = specialistId
        self.isRescheduledView = isRescheduledView
        self.appointmentId = appointmentId
    }
    
    func rescheduleAppointment() async {
        guard let appointmentId = appointmentId else { return }
        
        do{
            if let appointment = try await service.rescheduleAppointment(appointmentId: appointmentId, date: selectedDate.convertToString()) {
                print(appointment)
                isAppointmentScheduled = true
            }else {
                isAppointmentScheduled = false
            }
        }catch {
            print("Erro: \(error)")
            isAppointmentScheduled = false
        }
        
        showAlert = true
    }
    
    func scheduleAppointment() async {
        do{
            if let appointment = try await service.scheduleAppointment(specialistId: specialistId, patientId: patientID, date: selectedDate.convertToString()) {
                print(appointment)
                isAppointmentScheduled = true
            }else {
                isAppointmentScheduled = false
            }
        }catch {
            print("Erro: \(error)")
            isAppointmentScheduled = false
        }
        
        showAlert = true
    }
    
    var body: some View {
        VStack {
            Text("Selecione a data e o horário da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            DatePicker("Data da Consulta", selection: $selectedDate, in: Date()...)
                .datePickerStyle(.graphical)
            
            Button {
                print(selectedDate.convertToString())
                Task {
                    if isRescheduledView {
                        await rescheduleAppointment()
                    }else {
                        await scheduleAppointment()
                    }
                }
            } label: {
                ButtonView(text: isRescheduledView ? "Reagendar consulta" : "Agendar consulta")
            }
        }
        .padding()
        .navigationTitle(isRescheduledView ? "Reagendar consulta" : "Agendar consulta")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 15
        }
        .alert(
            isAppointmentScheduled ? "Sucesso" : "Ops!",
            isPresented: $showAlert,
            presenting: isAppointmentScheduled) { isScheduled in
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("OK")
                })
            } message:{ isScheduled in
                if isScheduled {
                    Text("Consulta \(isRescheduledView ? "reagendada" : "agendada") com sucesso!")
                }else {
                    Text("Não foi possível \(isRescheduledView ? "reagendar" : "agendar") a consulta. Tente novamente mais tarde.")
                }
            }
    }
}

#Preview {
    ScheduleAppointmentView(specialistId: "123")
}
