
import UIKit
import Alamofire


class misSitiosTVC: UITableViewController {
    var token = UserDefaults.standard.object(forKey: "token")
    var sitios = [Sitio]()
    var label: UILabel?
    
    //Se cargan los datos en las celdas
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label?.center = CGPoint(x: 180, y: 285)
        label?.textAlignment = .center
        label?.text = "No locations saved yet"
        self.view.addSubview((label)!)
    }
    
    @IBAction func unwindToList(_ segue: UIStoryboardSegue) {
        listaSitios()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listaSitios()
    }
    
    //Obtener sitios guardados peticion get. Meterlos en array sitios
    func listaSitios(){
        sitios = [Sitio]()
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.object(forKey: "token") as! String
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
                            self.tableView.reloadData()
                        }
                        
                        if !self.sitios.isEmpty {
                            self.label?.isHidden = true
                        }
                    }
                }
                
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Determina el tamaño de la lista según la cantidad de elementos que contenga el array "sitios"
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sitios.count
    }
    
    //Altura de la celda
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //Introduce los datos en cada una de las celdas
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! misSitiosTVCell
        
        cell.name.text = sitios[indexPath.row].titulo
        cell.fechaDesde.text = sitios[indexPath.row].dateDesde
        cell.fechaHasta.text = sitios[indexPath.row].dateHasta
        cell.id = indexPath.row
        return cell
    }
    
    //Enviar datos de misSitiosTVCell(celda) a DetalleVC(vista detalle spot)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let sender = sender as! misSitiosTVCell
            
            destination.sitio = sitios[sender.id!]
        }
    }
}
