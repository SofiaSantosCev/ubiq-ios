

import Foundation
import UIKit

class Sitio {
    
    var titulo: String?
    var descripcion: String?
    var image: UIImage?
    var dateDesde: String?
    var dateHasta: String?
    
    init(titulo: String, descripcion: String, image: UIImage, dateDesde: String, dateHasta: String) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.image = image
        self.dateDesde = dateDesde
        self.dateHasta = dateHasta
    }
}
