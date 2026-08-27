class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://download.tanukisoftware.com/wrapper/3.7.2/wrapper_3.7.2_src.tar.gz"
  sha256 "77e45f55ac9bd3938d703da2e702e81455283a05483a22dc705d8f138a0a06fd"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://download.tanukisoftware.com/wrapper/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5a9affec3ff58852685419cb4252482094558019758bd07a8ff8a61ecb3fc0a7"
    sha256 cellar: :any, arm64_sequoia: "de0b4a84911864b1025813c7a322d8685dc30f03b625cb4d888649e0be503770"
    sha256 cellar: :any, arm64_sonoma:  "916dfa5d1254eb8c5cd8aeb66e5bde2ef8ad62c11eeb718db39356b3fa47df1b"
    sha256 cellar: :any, sonoma:        "aa1b4322ff8c79656ac335c57b1123f3d6b0860b6b0645ac3e59ae9eebe8cfaa"
    sha256 cellar: :any, arm64_linux:   "962f1b9f48ea2492d463a295c1564eb702871785f9a60f9cd7eb6e0b0444729f"
    sha256 cellar: :any, x86_64_linux:  "0fdb5b52bb187767722a96fb3d282de692d47d5efd5121f9784514e6c057b301"
  end

  depends_on "ant" => :build
  depends_on "openjdk" => [:build, :test]

  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Default javac target version is 1.4, use 8 which is the minimum available on newer openjdk.
    # Build only the targets we install without test modules
    system "ant", "jar", "compile-c", "bin", "conf", "-Dbits=64", "-Djavac.target.version=8"

    libexec.install "lib", "bin", "src/bin" => "scripts"

    # Both arches now build libwrapper.dylib; provide the .jnilib name Java expects on macOS
    ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib" if OS.mac?
  end

  test do
    ENV["JAVA_HOME"] = java_home = Language::Java.java_home

    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_equal "Test Wrapper Sample Application (not installed) is not running.\n", output

    (testpath/"bin").install_symlink libexec/"bin/wrapper"
    cp libexec/"scripts/App.sh.in", testpath/"bin/helloworld"
    chmod "+x", testpath/"bin/helloworld"
    inreplace testpath/"bin/helloworld" do |s|
      s.gsub! "@app.name@", "helloworld"
      s.gsub! "@app.long.name@", "Hello World"
    end

    (testpath/"conf/wrapper.conf").write <<~INI
      wrapper.java.command=#{java_home}/bin/java
      wrapper.java.mainclass=org.tanukisoftware.wrapper.WrapperSimpleApp
      wrapper.jarfile=#{libexec}/lib/wrapper.jar
      wrapper.java.classpath.1=#{libexec}/lib/wrapper.jar
      wrapper.java.classpath.2=#{testpath}
      wrapper.java.library.path.1=#{libexec}/lib
      wrapper.java.additional.auto_bits=TRUE
      wrapper.java.additional.1=-Xms128M
      wrapper.java.additional.2=-Xmx512M
      wrapper.app.parameter.1=HelloWorld
      wrapper.logfile=#{testpath}/wrapper.log
    INI

    (testpath/"HelloWorld.java").write <<~JAVA
      public class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system "#{java_home}/bin/javac", "HelloWorld.java"
    console_output = shell_output("bin/helloworld console")
    assert_match "Hello, world!", console_output
  end
end