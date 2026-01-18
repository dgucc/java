Voici un exemple en Java 17 qui montre comment instancier dynamiquement une classe à partir d'un fichier `properties` et appeler une méthode sur cette instance :

```java /path/to/YourClass.java
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Properties;

public class YourClass {

    public static void main(String[] args) {
        Properties properties = new Properties();
        try (var input = YourClass.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new IOException("Le fichier config.properties n'est pas trouvé.");
            }
            properties.load(input);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        String className = properties.getProperty("class.name");
        String methodName = properties.getProperty("method.name");

        try {
            Class<?> clazz = Class.forName(className);
            Object instance = clazz.getDeclaredConstructor().newInstance();

            Method method = clazz.getMethod(methodName);
            method.invoke(instance);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### Explication des modifications

1. **Lecture du fichier `properties`**:
   - Utilisation de `Properties` pour lire les valeurs depuis `config.properties`.
   - Vérification si le fichier existe et chargement des propriétés.

2. **Instanciation dynamique de la classe**:
   - Extraction du nom de la classe (`class.name`) du fichier `properties`.
   - Utilisation de `Class.forName()` pour charger la classe.
   - Création d'une instance de la classe avec `clazz.getDeclaredConstructor().newInstance()`.

3. **Appel de la méthode**:
   - Extraction du nom de la méthode à appeler (`method.name`) du fichier `properties`.
   - Récupération de la méthode avec `clazz.getMethod(methodName)`.
   - Appel de la méthode sur l'instance avec `method.invoke(instance)`.

### Fichier `config.properties`

Afin que ce code fonctionne, vous devrez avoir un fichier `config.properties` dans le même répertoire du projet (par exemple, `src/main/resources/config.properties`). Voici un exemple du contenu de ce fichier :

```properties
class.name=MonAutreClasse
method.name=surMonAutreMethode
```

### Classe `MonAutreClasse`

Pour que l'instance puisse être créée et que la méthode puisse être appelée, vous aurez besoin d'une classe qui ressemble à ceci :

```java /path/to/MonAutreClasse.java
public class MonAutreClasse {

    public void surMonAutreMethode() {
        System.out.println("La méthode surMonAutreMethode a été appelée.");
    }
}
```

Avec ces éléments, le code `YourClass` instanciera dynamiquement la classe `MonAutreClasse` et appellera sa méthode `surMonAutreMethode`.