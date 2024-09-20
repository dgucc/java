package sandbox;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import sandbox.model.EnumStatus;
import sandbox.model.Report;
import sandbox.model.Member;
/**
 *  Test apache velocity templating
 */
public class App {
    public static void main(String[] args) {
        VelocityEngine velocityEngine = new VelocityEngine();
        velocityEngine.init();

        Template template = velocityEngine.getTemplate("src/main/resources/vm/mailBody.vm");
        VelocityContext context = new VelocityContext();

        // Populate Data 
        Report mail = new Report();        
        mail.setStatus(EnumStatus.READY); // Or EnumStatus.ERROR
        List<Member> list = new ArrayList<>();
        list.add(new Member(1, "Damien"));        
        list.add(new Member(2, "Céline"));
        list.add(new Member(3, "Amaury"));
        mail.setMembers(list);

        context.put("body", mail);

        StringWriter writer = new StringWriter();
        template.merge(context, writer);

        System.out.println(writer.toString());
    }
}
