package minfin;

import java.io.File;
import java.io.IOException;

import javax.xml.XMLConstants;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.SAXException;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.util.JAXBSource;

/**
 * Validate a JAXB Object Model With an XML Schema 
 * Dummy rules  : 
 * - The customer's name cannot be longer than 5 characters.
 * - The customer cannot have more than 2 phone numbers.
 * 
 */
public class App {
    public static void main(String[] args) {
        System.out.println("*** Started ***");

        Customer customer = new Customer();
        customer.setName("Jane Doe");

        customer.getPhoneNumbers().add(new PhoneNumber());
        customer.getPhoneNumbers().add(new PhoneNumber());
        customer.getPhoneNumbers().add(new PhoneNumber());

        JAXBContext jaxbContext;
        try {
            jaxbContext = JAXBContext.newInstance(Customer.class);
            JAXBSource source = new JAXBSource(jaxbContext, customer);

            SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = schemaFactory.newSchema(new File("src/main/resources/customer.xsd"));

            Validator validator = schema.newValidator();
            validator.setErrorHandler(new XsdErrorHandler());
            validator.validate(source);

        } catch (JAXBException e) {
            System.out.println("JAXBException : " + e.getMessage());
        } catch (SAXException e) {
            // Custom Error Handler while Validating XML against XSD
            // cf. XsdErrorHandler
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }

        System.out.println("*** Terminated ***");
    }
}
