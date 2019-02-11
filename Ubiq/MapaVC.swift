
import UIKit
import MapKit
import Alamofire

class MapaVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapa: MKMapView!
    let manager = CLLocationManager()
    var sitios = [Sitio]()
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
        mapa.delegate = self
        listaSitios()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listaSitios()
    }
    
    //Peticion get para obtener toda la lista de sitios
    func listaSitios(){
        var token = UserDefaults.standard.object(forKey: "token")
        sitios = [Sitio]()
        let headers: HTTPHeaders = [
            "Authorization": token as! String
        ]
      
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .get, headers: headers)
            .responseJSON { response in
                if response.result.value != nil {
                    let responseJSON = response.result.value as! [String: Any]
                    if response.response?.statusCode == 200 {
                        let data = responseJSON["locations"] as! [[String:Any]]
                        for x in data {
                            let location = Sitio(id: x["id"] as! Int,
                                                 titulo: x["name"] as! String,
                                                 descripcion: (x["description"] as? String)!,
                                                 dateDesde: x["start_date"] as! String,
                                                 dateHasta: x["end_date"] as! String,
                                                 longitude: x["x_coordinate"] as! Double,
                                                 latitude: x["y_coordinate"] as! Double)
                            self.sitios.append(location)
                            for sitio in self.sitios {
                                self.marcar(longitude: sitio.longitude!, latitude: sitio.latitude!, titulo: sitio.titulo!, description: sitio.descripcion!)
                            }
                        }
                    }
                }
                
            }
        
    }
    
    //Marcar la ubicacion en el mapa
    func marcar(longitude: Double, latitude: Double, titulo: String, description: String){
        let span = MKCoordinateSpanMake(2, 2)
        let localizacion = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate.latitude = latitude
        anotacion.coordinate.longitude = longitude
        anotacion.title = titulo
        anotacion.subtitle = description
        mapa.addAnnotation(anotacion)
 
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
}
