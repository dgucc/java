
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import service.IService;

public class AppSpringAnnotation {
    
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext("dao", "service");
        IService metier = context.getBean(IService.class);
        System.out.println("Result : " + metier.calcul());
    }
}
