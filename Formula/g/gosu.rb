class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://ghfast.top/https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.12.tar.gz"
  sha256 "22bc5e2d5a7e9dd25c9028764b4cbf5d9febcb7f85a7f192bc97c7999cf1003c"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f730b48d03e2cb2ac424e31a5d993559530149e27dc4c2674e66dfd1d6da08b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1c4ed8513fcfafb5384af1f385fe0eab64eec824ed64854ebcbc4036940da48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bacce4086024750af0755a018cf2ad2284b4a3492d70f81d8a7d82e6f62473c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5842f95cdad8e92e2190ab41fdff004e3cbf4093d3439e32c535f63ae76851e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "709e73a1317b6b2cf21ab69a0437635f86201b686b45141133380e82879f40ad"
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