

import UIKit

class Sitio: Decodable {
    
    var titulo: String?
    var descripcion: String?
    var dateDesde: String?
    var dateHasta: String?
    var longitude: Double?
    var latitude: Double?
    
    init(titulo: String, descripcion: String, dateDesde: String, dateHasta: String, longitude: Double, latitude: Double) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.dateDesde = dateDesde
        self.dateHasta = dateHasta
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
