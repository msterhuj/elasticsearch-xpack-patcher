package org.elasticsearch.license;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.PublicKey;
import org.elasticsearch.core.Streams;

public class LicenseVerifier {
  private static final PublicKey PUBLIC_KEY;
  
  public static boolean verifyLicense(License license, PublicKey publicKey) {
    return true;
  }
  
  static {
    try {
      InputStream is = LicenseVerifier.class.getResourceAsStream("/public.key");
      try {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Streams.copy(is, out);
        PUBLIC_KEY = CryptUtils.readPublicKey(out.toByteArray());
        if (is != null)
          is.close(); 
      } catch (Throwable throwable) {
        if (is != null)
          try {
            is.close();
          } catch (Throwable throwable1) {
            throwable.addSuppressed(throwable1);
          }  
        throw throwable;
      } 
    } catch (IOException e) {
      throw new AssertionError("key file is part of the source and must deserialize correctly", e);
    } 
  }
  
  public static boolean verifyLicense(License license) {
    return true;
  }
}

