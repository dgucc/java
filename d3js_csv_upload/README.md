mvn compile exec:java -Dexec.mainClass=sandbox.App

PWC6033: Error in Javac compilation for JSP
PWC6199: Generated servlet error: source value 7 is obsolete and will be removed in a future release

# Cause : mismatch java and jetty version
jetty 9.4.x		Java 8
jetty 10.0.x 	Java 11+

# switch default jre :
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
  0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      auto mode
* 1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode
Press <enter> to keep the current choice[*], or type selection number: 2

