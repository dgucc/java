package dao;

import org.springframework.stereotype.Component;

@Component("dao-db")
public class DaoImplDB implements IDao{

    @Override
    public double getData() {
        System.out.println("version base de données");
        double data = 34;
        return data;
    }
    
}
