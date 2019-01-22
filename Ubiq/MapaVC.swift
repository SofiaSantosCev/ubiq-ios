
import UIKit
import MapKit

class MapaVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    let manager = CLLocationManager()
    
    //sitios hardcodeados
    var sitios = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        sitios.append(CLLocationCoordinate2D(latitude: 40.395078, longitude: -3.649885))
        sitios.append(CLLocationCoordinate2D(latitude: 40.397642, longitude: -3.654908))
        
        for sitio in sitios {
            pin(localizacion: sitio)
        }
        
        self.manager.requestAlwaysAuthorization()
    
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
    //poner chincheta
    func pin(localizacion: CLLocationCoordinate2D){
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        mapa.setRegion(region, animated: true)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate = localizacion
        mapa.addAnnotation(anotacion)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
}
