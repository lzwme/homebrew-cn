class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https:www.groovy-lang.org"
  url "https:groovy.jfrog.ioartifactorydist-release-localgroovy-zipsapache-groovy-binary-4.0.18.zip"
  sha256 "4b03aa472ec7848d272893348a656be05d1b3502b30770ea57efa158e61154a6"
  license "Apache-2.0"

  livecheck do
    url "https:groovy.jfrog.ioartifactorydist-release-localgroovy-zips"
    regex(href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a664d71ffeb7a709b0ae5a6b8854c3e3c64dd49c2c8395bbba84aef975ec115"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "425d2b8199adde7025c44c113fb22e2ad8ddf64fa1798009c4e43acb5556a76e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4effd4134fcf088ff790367513fee216b5f8288dab9ac31fc887e57fa2ae94"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f4cff8792196c61e7bb1b2b19257059a2b1e4b06966e94553a3e3a80c340aee"
    sha256 cellar: :any_skip_relocation, ventura:        "265e2b67d0249e507c87d3aa504ecd7cb9250517805b18951c0bd287ae125ead"
    sha256 cellar: :any_skip_relocation, monterey:       "698760f88a9747713d37f94961146a8000818a0ef42cd881416e05ed74dfe451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f40dbeb077361bd87335c00b497e7fcaa0445801010d7b11227e6ab8118d2ee1"
  end

  depends_on "openjdk"

  on_macos do
    # Temporary build dependencies for compiling jansi-native
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "maven" => :build

    # jansi-native is used to build native binary to support Apple Silicon.
    # Source version is from jline-2.14.6 -> jansi-1.12 -> jansi-native-1.6
    # TODO: Remove once updated to jline-3.x: https:issues.apache.orgjirabrowseGROOVY-8162
    resource "jansi-native" do
      url "https:github.comfusesourcejansi-nativearchiverefstagsjansi-native-1.6.tar.gz"
      sha256 "f4075ad012c9ed79eaa8d3240d869e10d94ca8b130f3e7dac2ba3978dce0fb21"

      # Update pom.xml to replace unsupported Java 6 source and to disable universal binary
      patch :DATA
    end
  end

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    if OS.mac?
      jline_jar = buildpath"libjline-2.14.6.jar"
      resource("jansi-native").stage do
        # Fix compile with newer Clang
        ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

        system "mvn", "-Dplatform=osx", "prepare-package"
        system "zip", "-d", jline_jar, "META-INFnative*"
        system "jar", "-uvf", jline_jar,
                      "-C", "targetgenerated-sourceshawtjnilib",
                      "META-INFnativeosx64libjansi.jnilib"
      end
    end

    # Don't need Windows files.
    rm_f Dir["bin*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}bin*"] - ["#{libexec}bingroovy.ico"]
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    output = shell_output("#{bin}grape install org.activiti activiti-engine 5.16.4")
    assert_match "found org.activiti#activiti-engine;5.16.4", output
    assert_match "65536\n===> null\n", pipe_output("#{bin}groovysh", "println 64*1024\n:exit\n")
  end
end

__END__
diff --git apom.xml bpom.xml
index 369cc8c..6dbac6f 100644
--- apom.xml
+++ bpom.xml
@@ -151,8 +151,8 @@
         <groupId>org.apache.maven.plugins<groupId>
         <artifactId>maven-compiler-plugin<artifactId>
         <configuration>
-          <source>1.5<source>
-          <target>1.5<target>
+          <source>1.8<source>
+          <target>1.8<target>
         <configuration>
       <plugin>
       
@@ -306,35 +306,5 @@
       <build>
     <profile>
     
-
-    <!-- Profile which enables Universal binaries on OS X -->
-    <profile>
-      <id>mac<id>
-      <activation>
-        <os><family>mac<family><os>
-      <activation>
-      <build>
-        <plugins>
-          <plugin>
-            <groupId>org.fusesource.hawtjni<groupId>
-            <artifactId>maven-hawtjni-plugin<artifactId>
-            <configuration>
-              <osgiPlatforms>
-                <osgiPlatform>osname=MacOS;processor=x86-64<osgiPlatform>
-                <osgiPlatform>osname=MacOS;processor=x86<osgiPlatform>
-                <osgiPlatform>osname=MacOS;processor=PowerPC<osgiPlatform>
-                <osgiPlatform>*<osgiPlatform>
-              <osgiPlatforms>
-              <configureArgs>
-                <arg>--with-universal<arg>
-              <configureArgs>
-              <platform>osx<platform>
-            <configuration>
-          <plugin>
-        <plugins>
-      <build>
-    <profile>
-    
-    
   <profiles>
 <project>