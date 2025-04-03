//
//  CancelAppointmentView.swift
//  Vollmed
//
//  Created by Josaphat Campos Pereira on 03/04/25.
//

import SwiftUI

struct CancelAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var appointmentId: String = ""
    let service = WebService()
    
    @State private var reasonToCancel: String = ""
    @State private var showAlert: Bool = false
    @State private var isSuccess: Bool = false
    
    func cancelAppointment() async {
        do{
            if try await service.cancelAppointment(appointmentId: appointmentId, reasonToCancel: reasonToCancel) {
                isSuccess = true
            }
        }catch{
            print("Error: \(error)")
            isSuccess = false
        }
        
        showAlert = true
    }
    
    var body: some View {
        VStack(spacing:16){
            Text("Qual é o motivo do cancelamento?")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            TextEditor(text: $reasonToCancel)
                .padding()
                .font(.title3)
                .foregroundStyle(.accent)
                .scrollContentBackground(.hidden)
                .background(Color.lightBlue.opacity(0.15))
                .cornerRadius(16)
                .frame(maxHeight: 300)
            
            Button(action: {
                Task{
                    await cancelAppointment()
                }
            }, label: {
                ButtonView(text: "Cancelar consulta", buttonType: .cancel)
            })
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Cancelar consulta")
        .navigationBarTitleDisplayMode(.large)
        .alert(
            isSuccess ? "Sucesso" : "Ops!",
            isPresented: $showAlert,
            presenting: isSuccess) { isSuccess in
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("OK")
                })
            } message:{ isScheduled in
                if isScheduled {
                    Text("Consulta cancelada com sucesso!")
                }else {
                    Text("Não foi possível cancelar a consulta. Tente novamente mais tarde.")
                }
            }
    }
}

#Preview {
    CancelAppointmentView()
}
