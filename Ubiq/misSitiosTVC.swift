
import UIKit
import Alamofire

var sitios = [Sitio]()
class misSitiosTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaSitios()
    }
    
    //Obtener sitios guardados peticion get. Meterlos en array sitios
    func listaSitios(){
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .get)
            .responseJSON { response in
                let responseJSON = response.result.value as! [String: Any]
                if response.response?.statusCode == 200 {
                    let data = responseJSON["locations"] as! [[String:Any]]
                    for x in data {
                        let location = Sitio(id: x["id"] as! Int,
                                             titulo: x["name"] as! String,
                                             descripcion: (x["description"] as? String)!,
                                             dateDesde: x["start_date"] as! Date,
                                             dateHasta: x["end_date"] as! Date,
                                             longitude: x["x_coordinate"] as! Double,
                                             latitude: x["y_coordinate"] as! Double,
                                             user_id: x["user_id"] as! Int)
                        sitios.append(location)
                        print(location)
                        print("datos cargados")
                    }
                }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sitios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! misSitiosTVCell
        let dateFormatter = DateFormatter()
        var dateSince = dateFormatter.string(from: sitios[indexPath.row].dateDesde!)
        var dateTill = dateFormatter.string(from: sitios[indexPath.row].dateHasta!)
        
        cell.name.text = sitios[indexPath.row].titulo
        cell.fechaDesde.text = dateSince
        cell.fechaHasta.text = dateTill
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let sitio = sender as! misSitiosTVCell
            
            destination.Titulo.text = sitio.name.text!
            destination.fechaDesde = sitio.fechaDesde
            destination.fechaHasta = sitio.fechaHasta
        }
    }
}
