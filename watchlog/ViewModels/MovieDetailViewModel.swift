import Foundation
import SwiftData

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var is_fav: Bool = false
    @Published var is_loading: Bool = false
    
    // Comprueba si la película ya existe en la base de datos local (SwiftData)
    func checkFavoriteStatus(movie_id: String, context: ModelContext) {
        let descriptor = FetchDescriptor<FavoritoLocal>(predicate: #Predicate { $0.pelicula_id == movie_id })
        if let count = try? context.fetchCount(descriptor), count > 0 {
            self.is_fav = true
        } else {
            self.is_fav = false
        }
    }
    
    // Agrega o elimina de favoritos, interactuando con SwiftData y preparando la conexión a MySQL
    func toggleFavorite(movie: PeliculaLocal, context: ModelContext) {
        is_loading = true
        
                Task {
            do {
                if self.is_fav {
                    let _ = try await APIManager.shared.removeFavorite(api_id: movie.api_id)
                    // Remover local
                    let movie_id = movie.id_pelicula
                    let descriptor = FetchDescriptor<FavoritoLocal>(predicate: #Predicate { $0.pelicula_id == movie_id })
                    if let results = try? context.fetch(descriptor) {
                        for fav in results {
                            context.delete(fav)
                        }
                    }
                } else {
                    let _ = try await APIManager.shared.addFavorite(api_id: movie.api_id, title: movie.titulo, poster_url: movie.poster_path)
                    // Añadir local
                    let newFav = FavoritoLocal(usuario_id: "usuario_actual", pelicula_id: movie.id_pelicula)
                    context.insert(movie)
                    newFav.pelicula = movie
                    context.insert(newFav)
                }
                
                try? context.save()
                self.is_fav.toggle()
                self.is_loading = false
            } catch {
                self.is_loading = false
                print("Error al cambiar favorito: \(error)")
            }
        }
    }
}