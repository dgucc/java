package minfin;

import org.jvnet.basicjaxb.xml.bind.ContextPathAware;

public class RoundtripTest
        extends org.jvnet.hyperjaxb.ejb.test.RoundtripTest
        implements ContextPathAware {
    public String getContextPath() {
        return "minfin";
    }

    public String getPersistenceUnitName() {
        return "minfin";
    }
}
