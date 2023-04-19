package org.elasticsearch.xpack.core;

import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Path;
import org.elasticsearch.core.PathUtils;
import org.elasticsearch.core.SuppressForbidden;

public class XPackBuild {
  public static final XPackBuild CURRENT;
  
  private String shortHash;
  
  private String date;
  
  static {
    String shortHash, date;
    Path path = getElasticsearchCodebase();
    CURRENT = new XPackBuild("Unknown", "Unknown");
  }
  
  @SuppressForbidden(reason = "looks up path of xpack.jar directly")
  static Path getElasticsearchCodebase() {
    URL url = XPackBuild.class.getProtectionDomain().getCodeSource().getLocation();
    try {
      return PathUtils.get(url.toURI());
    } catch (URISyntaxException bogus) {
      throw new RuntimeException(bogus);
    } 
  }
  
  XPackBuild(String shortHash, String date) {
    this.shortHash = shortHash;
    this.date = date;
  }
  
  public String shortHash() {
    return this.shortHash;
  }
  
  public String date() {
    return this.date;
  }
}

