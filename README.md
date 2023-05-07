# java

## Wi-Fi QR-Code

Sample to generate QRCode for WiFi  

## Get rid of "WARNING: An illegal reflective access operation has occurred"
```
import java.lang.reflect.Field;
import java.lang.reflect.Method;

@SuppressWarnings("unchecked")
public static void disableAccessWarnings() {
        try {
            Class unsafeClass = Class.forName("sun.misc.Unsafe");
            Field field = unsafeClass.getDeclaredField("theUnsafe");
            field.setAccessible(true);
            Object unsafe = field.get(null);

            Method putObjectVolatile = unsafeClass.getDeclaredMethod("putObjectVolatile", Object.class, long.class, Object.class);
            Method staticFieldOffset = unsafeClass.getDeclaredMethod("staticFieldOffset", Field.class);

            Class loggerClass = Class.forName("jdk.internal.module.IllegalAccessLogger");
            Field loggerField = loggerClass.getDeclaredField("logger");
            Long offset = (Long) staticFieldOffset.invoke(unsafe, loggerField);
            putObjectVolatile.invoke(unsafe, loggerClass, offset, null);
        } catch (Exception ignored) {
        }
}

public static void main(String[] args) {
	disableAccessWarnings();
		...
}
```  

## Convert Charset
```java
final Charset fromCharset = Charset.forName("windows-1252");
final Charset toCharset = Charset.forName("UTF-8");
return new String(input.getBytes(fromCharset), toCharset);
```  
---

## Standard Formats 

Phone Number  
`tel:+48111111111;`  

SMS  
`smsto:555-555-5555:What's up Dude`  

vCard  
```
BEGIN:VCARD
VERSION:2.1
N:John Doe
TEL;HOME;VOICE:555-555-5555
TEL;WORK;VOICE:666-666-6666
EMAIL:john@example.com
ORG:home
URL:https://john.doe.com
END:VCARD
```

Email  
`mailto:contact@example.com?subject=Subject&body=Body`  

---  

## References 

Found this (not yet tested)  
[QR Code generator library](https://github.com/nayuki/QR-Code-generator)  




