package minfin;


import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XsdErrorHandler implements ErrorHandler {
   public void warning(SAXParseException exception) throws SAXException {
      System.out.println("WARNING: " + exception.getMessage());
      
  }

  public void error(SAXParseException exception) throws SAXException {
      System.out.println("ERROR: " + exception.getMessage());
      
  }

  public void fatalError(SAXParseException exception) throws SAXException {
      System.out.println("FATAL ERROR: " + exception.getMessage());
      
  }
}
