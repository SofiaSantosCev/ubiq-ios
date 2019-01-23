

import UIKit
import MapKit
import Alamofire

class nuevaUbicacionVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var fechaInicio: UIDatePicker!
    @IBOutlet weak var fechaFin: UIDatePicker!
    var coordenadas: CLLocationCoordinate2D?
    var pin: CLLocationCoordinate2D?
    var pinGuardado: CLLocationCoordinate2D?
    
    var dateInicio: String?
    var dateFin: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.cornerRadius = 5.0
        btn.layer.cornerRadius = 15
    }
    
    //Convierte la fecha seleccionada en el datePicker a string y la guarda en una variable externa
    @IBAction func fechaInicio(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: fechaInicio.date)
        self.dateInicio = strDate
    }

    @IBAction func fechaFin(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: fechaFin.date)
        self.dateFin = strDate
    }
    
    //Crea un nuevo sitio y envia al usuario a la vista detalle
    @IBAction func create(_ sender: Any) {
        peticionPost(sender: sender)
    }
    
    //Enviar datos a la api
    func peticionPost(sender: Any){
        let parameters = ["name" : titulo.text!,
                          "description" : textView.text!,
                          "x_coordinate" : coordenadas?.longitude,
                          "y_coordinate" : coordenadas?.latitude,
                          "start_date" : fechaInicio.date,
                          "end_date" : fechaFin.date] as [String : Any]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    self.performSegue(withIdentifier: "create", sender: sender)
                } else {
                    let alert = UIAlertController(title: "Permission denied", message: "You dont have permission", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert,animated: true)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let nuevo = sender as! nuevaUbicacionVC
            
            destination.Titulo.text = nuevo.titulo.text
            destination.Descripcion.text = nuevo.textView.text
            destination.fechaDesde.text = dateInicio
            destination.fechaHasta.text = dateFin
        }
    }
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapaCrearSpot.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        map.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: map)
            let locationCoordinate = map.convert(touchLocation,toCoordinateFrom: map)
            
            marcar(localizacion: locationCoordinate)
            coordenadas = locationCoordinate
            pin = coordenadas
        }
    }
    
    func marcar(localizacion: CLLocationCoordinate2D){
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        map.setRegion(region, animated: true)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate = localizacion
        map.addAnnotation(anotacion)
    }
    
}
