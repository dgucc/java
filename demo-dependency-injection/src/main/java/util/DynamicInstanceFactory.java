package util;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DynamicInstanceFactory {

    private final Properties properties;

    /**
     * Constructeur qui charge le fichier properties
     * @param propertiesFileName Nom du fichier properties (ex: "app.properties")
     */
    public DynamicInstanceFactory(String propertiesFileName) {
        this.properties = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(propertiesFileName)) {
            if (input == null) {
                throw new IllegalArgumentException("Fichier " + propertiesFileName + " non trouvé !");
            }
            properties.load(input);
        } catch (IOException e) {
            throw new RuntimeException("Erreur lors du chargement du fichier " + propertiesFileName, e);
        }
    }

    /**
     * Instancie dynamiquement une classe à partir d'une clé dans le fichier properties
     * @param key Clé dans le fichier properties (ex: "class.metier")
     * @return Instance de l'objet
     */
    @SuppressWarnings("unchecked")
    public <T> T getInstance(String key) throws Exception {
        String className = properties.getProperty(key);
        if (className == null) {
            throw new IllegalArgumentException("Key " + key + " not found in properties file");
        }
        Class<?> clazz = Class.forName(className);
        return (T) clazz.getDeclaredConstructor().newInstance();
    }

    
}
