

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import service.IService;

public class AppSpringXML {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("config.xml");
        IService service = context.getBean(IService.class);
        System.out.println("Result : " + service.calcul());
    }
}
