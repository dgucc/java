package com.example;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.text.Normalizer.Form;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.NotFoundException;
import com.google.zxing.Result;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

/**
 * Generate Wi-Fi QRCode for Android and Read QR code
 * 
 * WIFI:S:<SSID>;T:<WEP|WPA|blank>;P:<PASSWORD>;H:<true|false|blank>;;
 */
public class App {
    

    public static void main(String[] args) throws WriterException, IOException, NotFoundException {
        // Wi-Fi properties
        String SSID = "WIFI-SSID";
        String NETWORK_TYPE = "WPA";
        String PASSWORD = "WIFI-PASSWORD";
        String IS_HIDDEN = "false";
        String WIFI_TEXT = "WIFI:S:"+SSID+";T:"+NETWORK_TYPE+";P:"+PASSWORD+";H:"+IS_HIDDEN+";;";
        
        // The data that the QR code will contain
        String data = new String(WIFI_TEXT.getBytes(StandardCharsets.UTF_8),StandardCharsets.UTF_8) ;
        // The path where the image will get saved
        String path = SSID+".png";
        // Encoding charset
        String charset = "UTF-8";
        // Remove accents...
        data = Normalizer.normalize(data, Form.NFD).replaceAll("\\p{M}", "");
        
        Map<EncodeHintType, ErrorCorrectionLevel> hashMap = new HashMap<EncodeHintType, ErrorCorrectionLevel>();

        hashMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);

        // Create the QR code and save in the specified folder as a png file
        createQR(data, path, charset, hashMap, 200, 200);
        System.out.println("QR Code Generated : " + path);
        
        Map<EncodeHintType, ErrorCorrectionLevel> hintMap = new HashMap<EncodeHintType,
        ErrorCorrectionLevel>();
        hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        System.out.println("QR Code Read : '" + readQR(path, charset, hintMap) + "'");
    }
    
    // Function to create the QR code
    @SuppressWarnings("deprecation")
    public static void createQR(String data, String path, String charset, Map hashMap, int height, int width)
    throws WriterException, IOException {

        BitMatrix matrix = new MultiFormatWriter().encode(new String(data.getBytes(charset), charset),
            BarcodeFormat.QR_CODE, width, height);

        MatrixToImageWriter.writeToFile(matrix, path.substring(path.lastIndexOf('.') + 1), new File(path));
    }

    // Function to read the QR file
    public static String readQR(String path, String charset, Map hashMap)
    throws FileNotFoundException, IOException, NotFoundException {
        BinaryBitmap binaryBitmap = new BinaryBitmap(
            new HybridBinarizer(
                new BufferedImageLuminanceSource(ImageIO.read(new FileInputStream(path)))
                ));

        Result result = new MultiFormatReader().decode(binaryBitmap);

        return result.getText();
    }
}
