
import UIKit
import MapKit

class DetalleVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var Titulo: UILabel!
    @IBOutlet weak var Descripcion: UILabel!
    @IBOutlet weak var fechaDesde: UILabel!
    @IBOutlet weak var fechaHasta: UILabel!
    @IBOutlet weak var map: MKMapView!
    var sitio: Sitio?
    let manager = CLLocationManager()
    
    
    //Al iniciarse la aplicación se piden permisos de ubicación, y se marcan los puntos en el mapa.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
       
        marcar(longitude: (sitio?.longitude)!, latitude: (sitio?.latitude)!)
        
        Titulo.text = sitio?.titulo
        Descripcion.text = sitio?.descripcion
        fechaDesde.text = sitio?.dateDesde
        fechaHasta.text = sitio?.dateHasta
    }
    
    func marcar(longitude: Double, latitude: Double){
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                         span: MKCoordinateSpanMake(0.02, 0.02)),
                                        animated: true)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate.latitude = latitude
        anotacion.coordinate.longitude = longitude
        map.addAnnotation(anotacion)
    }

   

}
