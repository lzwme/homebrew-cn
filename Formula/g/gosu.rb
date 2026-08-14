class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://ghfast.top/https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.8.tar.gz"
  sha256 "1d597f0903485da5b2d3efa145be81cdcaed10823ab0bd17108d358931a65aac"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50c1902763826d322abb4d6bf359141356f89bd202cde79771d10c44c5b53a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "720187eeb82742e364b2725921f2bff2b9c2f8ea09b3092345431faf838d3774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9abd5a5c4fe404ad7de6d14116ea91141e77b645cb6091c7c330ae5de018f297"
    sha256 cellar: :any_skip_relocation, sonoma:        "88df5525296f07b5f794a707cbde0bbd4c6dd0aa9092d4870c95da7ce86a9be3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76febef603871a6af50b9c4e7195f4dcbabec0bf97c43fe54cbc688ae6322afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3af349bf5a91165fce09dab5100e3d95ef3c97a68a04b05cff95b2c0c0b4fe"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  skip_clean "libexec/ext"

  # Drop gosu-doc (javadoc internals don't compile on JDK 17+) and uncomment
  # JDK 13+ TreeVisitor stubs upstream left disabled.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("17")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end

__END__
--- a/pom.xml
+++ b/pom.xml
@@ -25,7 +25,6 @@
     <module>gosu-core-api-precompiled</module>
     <module>gosu-process</module>
     <module>gosu-lab</module>
-    <module>gosu-doc</module>
     <module>gosu-maven-compiler</module>
     <module>gosu-parent</module>
     <module>gosu-test</module>
--- a/gosu/pom.xml
+++ b/gosu/pom.xml
@@ -35,12 +35,6 @@
       <version>${project.version}</version>
       <scope>runtime</scope>
     </dependency>
-    <dependency>
-      <groupId>org.gosu-lang.gosu</groupId>
-      <artifactId>gosu-doc</artifactId>
-      <version>${project.version}</version>
-      <scope>runtime</scope>
-    </dependency>
   </dependencies>

   <build>
--- a/gosu-lab/src/main/java/editor/util/transform/java/visitor/GosuVisitor.java
+++ b/gosu-lab/src/main/java/editor/util/transform/java/visitor/GosuVisitor.java
@@ -2210,35 +2210,35 @@

   // Overrides for visitors new in Java 17...

-//  public String visitBindingPattern( BindingPatternTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitBindingPattern( BindingPatternTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitDefaultCaseLabel( DefaultCaseLabelTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitDefaultCaseLabel( DefaultCaseLabelTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitGuardedPattern( GuardedPatternTree node, Object o )
-//  {
-//    return null;
-//  }
-//
-//  public String visitParenthesizedPattern( ParenthesizedPatternTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitGuardedPattern( GuardedPatternTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitSwitchExpression( SwitchExpressionTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitParenthesizedPattern( ParenthesizedPatternTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitYield( YieldTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitSwitchExpression( SwitchExpressionTree node, Object o )
+  {
+    return null;
+  }
+//
+  public String visitYield( YieldTree node, Object o )
+  {
+    return null;
+  }

   private void pushIndent()
   {