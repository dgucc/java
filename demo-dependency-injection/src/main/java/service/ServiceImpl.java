package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import dao.IDao;
import util.DynamicInstanceFactory;

@Component
public class ServiceImpl implements IService {

    @Autowired
    @Qualifier("dao-ws")
    private IDao dao; // Couplage faible

    public ServiceImpl(){
        DynamicInstanceFactory factory = new DynamicInstanceFactory("app.properties");
        try {
            setDao(factory.getInstance("class.dao"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public double calcul() {
        double data = dao.getData();
        double result = data * 11.4;
        return result;
    }
 
    /**
     * Setter permettant d'injecter une classe qui implémente IDao 
     * @param dao
     */
    public void setDao(IDao dao){
        this.dao = dao;
    }
}
