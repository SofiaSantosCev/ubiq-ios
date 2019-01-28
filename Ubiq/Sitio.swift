

import UIKit

class Sitio: Decodable {
    
    var id: Int?
    var titulo: String?
    var descripcion: String?
    var dateDesde: String?
    var dateHasta: String?
    var longitude: Double?
    var latitude: Double?
    var user_id: Int?
    
    init(titulo: String, descripcion: String, dateDesde: String, dateHasta: String, longitude: Double, latitude: Double, user_id: Int) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.dateDesde = dateDesde
        self.dateHasta = dateHasta
        self.latitude = latitude
        self.longitude = longitude
        self.user_id = user_id
    }
    
}
