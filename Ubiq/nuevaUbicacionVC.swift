

import UIKit
import MapKit

class nuevaUbicacionVC: UIViewController {
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var FechaInicio: UIDatePicker!
    @IBOutlet weak var FechaFin: UIDatePicker!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var change: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descripcion.borderStyle = UITextBorderStyle.roundedRect
        btn.layer.cornerRadius = 15
    }
    @IBAction func change(_ sender: Any) {
        
    }
    
    @IBAction func create(_ sender: Any) {
        performSegue(withIdentifier: "create", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let nuevo = sender as! nuevaUbicacionVC
            
            destination.Titulo = nuevo.titulo.text
            destination.Descripcion = nuevo.descripcion.text
            destination.fechaDesde = nuevo.FechaInicio
            destination.fechaHasta = nuevo.FechaFin
            destination.image = nuevo.image
        }
    }
    
   
}
