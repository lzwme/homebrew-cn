class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public.git",
      tag:      "release-3.90.2-06",
      revision: "cf364dd80954e724d1ad2c9b4413c27b8ac1502d"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88941e2491f0e6501782655e722c8bbe0eb30334b5b781a2993689f22ae5cf44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c1b90e6d51a7cfa0d4284f0560493997f1d869244df8bae68642f88df6e76b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28845c78d97d581897c6417c54d108a365dd9d46878ee26c392fdf08a0bbaa6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f8e2ae9139e53bfbd3b4e8853c968541747455d208e5f6c2ad91dab19c4cdc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd4cbf58abfa1b425c76f1a382d27de051cd41cbeb68a4fb1dafdc3c6b1926ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db39c97e37709d688b29cd61d6bc695d0a137ea35c1e72218f1ece4cb3396cf6"
  end

  depends_on "maven" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  uses_from_macos "unzip" => :build

  # 1. Avoid downloading copies of node and yarn
  # 2. To avoid non-FIPS provider loads bc-fips classes, use isolated classloader.
  # 3. Add NoopRecoveryModeService to avoid recovery mode that is implemented by private module.
  patch :DATA

  def install
    # Workaround build error: Couldn't find package "@sonatype/nexus-ui-plugin@workspace:*"
    # Ref: https://github.com/sonatype/nexus-public/issues/417
    # Ref: https://github.com/sonatype/nexus-public/issues/432#issuecomment-2663250153
    inreplace "public/common/components/nexus-coreui-plugin/package.json",
              '"@sonatype/nexus-ui-plugin": "workspace:*"',
              '"@sonatype/nexus-ui-plugin": "*"'

    java_version = Formula["openjdk"].version.major.to_s
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    java_env = Language::Java.overridable_java_home_env(java_version)
    java_env.merge!(KARAF_DATA: "${NEXUS_KARAF_DATA:-#{var}/nexus}",
                    KARAF_LOG:  var/"log/nexus",
                    KARAF_ETC:  pkgetc)

    with_env(SKIP_YARN_COREPACK_CHECK: "1") do
      system "yarn", "install", "--immutable"
      system "yarn", "workspaces", "run", "build-all"
    end

    system "mvn", "install", "-DskipTests", "-Dpublic"

    assembly = "public/selfhosted/assemblies/nexus-repository-core/target/assembly"
    rm(Dir["#{assembly}/bin/*.bat"])
    libexec.install Dir["#{assembly}/*"]
    chmod "+x", libexec.glob("bin/*")
    (bin/"nexus").write_env_script libexec/"bin/nexus", java_env

    (var/"log/nexus").mkpath
    (var/"nexus").mkpath
    pkgetc.mkpath
  end

  service do
    run [opt_bin/"nexus", "start"]
  end

  test do
    port = free_port
    (testpath/"data/etc/nexus.properties").write "application-port=#{port}"
    pid = spawn({ "NEXUS_KARAF_DATA" => testpath/"data" }, bin/"nexus", "server")
    sleep 50
    sleep 50 if OS.mac? && Hardware::CPU.intel?
    assert_match "<title>Sonatype Nexus Repository</title>", shell_output("curl --silent --fail http://localhost:#{port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

__END__
diff --git a/pom.xml b/pom.xml
index 6647497628..d99148b421 100644
--- a/pom.xml
+++ b/pom.xml
@@ -877,7 +877,7 @@
           </executions>
         </plugin>

-        <plugin>
+        <!--plugin>
           <groupId>com.github.eirslett</groupId>
           <artifactId>frontend-maven-plugin</artifactId>
           <version>1.11.3</version>
@@ -932,7 +932,7 @@
               </configuration>
             </execution>
           </executions>
-        </plugin>
+        </plugin-->

         <plugin>
           <groupId>com.mycila</groupId>
diff --git a/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java b/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java
index dfeb6f0..38e067c 100644
--- a/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java
+++ b/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java
@@ -87,8 +87,25 @@ public class CryptoHelperImpl
   }
 
   private static void loadNonFipsProvider() {
-    // BouncyCastleProvider must be set as the last provider
-    Security.addProvider(new BouncyCastleProvider());
+    try {
+      Class<?> providerClass =
+          getNonFipsClassLoader().loadClass("org.bouncycastle.jce.provider.BouncyCastleProvider");
+      Provider provider = (Provider) providerClass.getConstructor().newInstance();
+      // BouncyCastleProvider must be set as the last provider
+      Security.addProvider(provider);
+    }
+    catch (ClassNotFoundException | NoSuchMethodException | InvocationTargetException
+        | InstantiationException | IllegalAccessException e) {
+      throw new RuntimeException("Failed to initialize non-FIPS provider", e);
+    }
+  }
+
+  private static URLClassLoader getNonFipsClassLoader() {
+    // Load bcprov and bcutil in an isolated classloader to prevent bc-fips classes
+    // (which share org.bouncycastle.crypto.* package names) from interfering.
+    URL bcprovUrl = BouncyCastleProvider.class.getProtectionDomain().getCodeSource().getLocation();
+    URL bcutilUrl = org.bouncycastle.util.Arrays.class.getProtectionDomain().getCodeSource().getLocation();
+    return new URLClassLoader(new URL[]{bcprovUrl, bcutilUrl}, null);
   }
 
   private static void loadFipsProvider() {
diff --git a/public/common/components/nexus-scheduling/src/main/java/org/sonatype/nexus/scheduling/internal/NoopRecoveryModeService.java b/public/common/components/nexus-scheduling/src/main/java/org/sonatype/nexus/scheduling/internal/NoopRecoveryModeService.java
new file mode 100644
index 0000000..9279594
--- /dev/null
+++ b/public/common/components/nexus-scheduling/src/main/java/org/sonatype/nexus/scheduling/internal/NoopRecoveryModeService.java
@@ -0,0 +1,26 @@
+package org.sonatype.nexus.scheduling.internal;
+
+import org.sonatype.nexus.scheduling.RecoveryModeService;
+import org.springframework.stereotype.Component;
+
+@Component
+public class NoopRecoveryModeService
+    implements RecoveryModeService
+{
+  @Override
+  public boolean isRecoveryMode() {
+    return false;
+  }
+
+  @Override
+  public void enableRecoveryMode() {
+  }
+
+  @Override
+  public void disableRecoveryMode() {
+  }
+
+  @Override
+  public void ensureNotInRecoveryMode(final String taskName) {
+  }
+}