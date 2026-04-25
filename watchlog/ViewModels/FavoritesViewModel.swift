import Foundation
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var is_loading = false
    
    // Función para sincronizar la caché local de SwiftData con la base de datos MySQL en Flask
    func syncFavoritesWithServer(context: ModelContext) {
        is_loading = true
        
                Task {
            do {
                let api_favs = try await APIManager.shared.getFavorites()
                
                // Actualizaríamos el contexto local con los remotos
                self.is_loading = false
                print("Favoritos sincronizados: \(api_favs.count)")
            } catch {
                self.is_loading = false
                print("Error al sincronizar favoritos: \(error)")
            }
        }
}
