import os
import re

base_path = "/home/juan/Universidad/Moviles II/watchlog/watchlog"

# 1. Add import SwiftUI to views
views_to_fix = ["Views/home.swift", "Views/recovery.swift", "Views/register.swift"]
for view in views_to_fix:
    path = os.path.join(base_path, view)
    if os.path.exists(path):
        with open(path, "r") as f:
            content = f.read()
        if "import SwiftUI" not in content:
            with open(path, "w") as f:
                f.write("import SwiftUI\n" + content)

# 2. Fix Favorites.swift
fav_path = os.path.join(base_path, "Views/Favorites.swift")
if os.path.exists(fav_path):
    with open(fav_path, "r") as f:
        fav_content = f.read()
    
    # Fix fechaAgregado -> fecha_agregado
    fav_content = fav_content.replace("\\FavoritoLocal.fechaAgregado", "\\FavoritoLocal.fecha_agregado")
    
    # Fix MovieDetailView arguments
    fav_content = fav_content.replace("movieTitle: pelicula.titulo", "movie_title: pelicula.titulo")
    fav_content = fav_content.replace("movieId: pelicula.idPelicula", "movie_id: pelicula.id_pelicula")
    fav_content = fav_content.replace("posterUrl: pelicula.posterPath", "poster_url: pelicula.poster_path")
    
    with open(fav_path, "w") as f:
        f.write(fav_content)

# 3. Change ContentView to LoginView in watchlogApp.swift
app_path = os.path.join(base_path, "watchlogApp.swift")
if os.path.exists(app_path):
    with open(app_path, "r") as f:
        app_content = f.read()
    
    app_content = app_content.replace("ContentView()", "LoginView()")
    
    with open(app_path, "w") as f:
        f.write(app_content)

print("Errors fixed successfully!")
