
import UIKit
import MapKit
import Alamofire

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
        
    }
    
    func marcar(longitude: Double, latitude: Double){
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                         span: MKCoordinateSpanMake(0.2, 0.2)),
                                        animated: true)

        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate.latitude = latitude
        anotacion.coordinate.longitude = longitude
        map.addAnnotation(anotacion)
    }

    @IBAction func deleteSpot(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "This action is irreversible", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.delete()
            self.performSegue(withIdentifier: "deleted", sender: sender)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func delete(){
        let id = String(sitio!.id)
        print(id)
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.object(forKey: "token") as! String
        ]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location/"+id, method: .delete,headers: headers).responseJSON { response in
            
            print(response.response?.statusCode)
            if response.response?.statusCode == 200 {
                print("Spot deleted")
                
            }
            
        }
    }
    

}
