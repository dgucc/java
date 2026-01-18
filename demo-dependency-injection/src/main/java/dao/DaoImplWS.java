package dao;

import org.springframework.stereotype.Component;

@Component("dao-ws")
public class DaoImplWS implements IDao{

    @Override
    public double getData() {
        System.out.println("version web service");
        double data = 34;
        return data;
    }
    
    
}
