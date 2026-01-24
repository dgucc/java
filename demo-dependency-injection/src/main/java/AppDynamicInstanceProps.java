import service.IService;
import util.DynamicInstanceFactory;

public class AppDynamicInstanceProps {
    public static void main(String[] args) {
        try {
            // Charger le fichier properties et instancier dynamiquement
            DynamicInstanceFactory factory = new DynamicInstanceFactory("app.properties");
    
            // Instancier avec injection de dépendance
            IService service = factory.getInstance("class.service");

            System.out.println("Résultat : " + service.calcul());
    
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
