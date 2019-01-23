
import UIKit
import MapKit

class MapaCrearSpot: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var coordenadas: CLLocationCoordinate2D?
    var pin: CLLocationCoordinate2D?
    var pinGuardado: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pinGuardado = UserDefaults.standard.object(forKey: "pin") as! CLLocationCoordinate2D
        if pinGuardado != nil {
            marcar(localizacion: pinGuardado!)
        }
    }
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapaCrearSpot.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        mapa.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: mapa)
            let locationCoordinate = mapa.convert(touchLocation,toCoordinateFrom: mapa)
            
            marcar(localizacion: locationCoordinate)
            coordenadas = locationCoordinate
            pin = coordenadas
        }
    }
    
    func marcar(localizacion: CLLocationCoordinate2D){
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        mapa.setRegion(region, animated: true)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate = localizacion
        mapa.addAnnotation(anotacion)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(pin, forKey: "pin")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is nuevaUbicacionVC {
            let destination = segue.destination as! nuevaUbicacionVC
            let origin = sender as! MapaCrearSpot
            
            destination.coordenadas = origin.coordenadas!
        }
    }
}
