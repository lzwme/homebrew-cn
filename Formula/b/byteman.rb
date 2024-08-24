class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https:byteman.jboss.org"
  url "https:downloads.jboss.orgbyteman4.0.23byteman-download-4.0.23-bin.zip"
  sha256 "5b6dda957ba86d1ac83713a93d54956adb171f51ace31dd7fb857400bd77765b"
  license "LGPL-2.1-or-later"
  head "https:github.combytemanprojectbyteman.git", branch: "main"

  livecheck do
    url "https:byteman.jboss.orgdownloads.html"
    regex(href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zipi)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e65f5c3531d3c1f3de8fbbf2722d236c0bcc3dcf02e803587896ab6457ce619b"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin*.bat"])
    doc.install Dir["docs*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = { JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}", BYTEMAN_HOME: libexec }
    Pathname.glob("#{libexec}bin*") do |file|
      target = binFile.basename(file, File.extname(file))
      # Drop the .sh from the scripts
      target.write_env_script(libexec"bin#{File.basename(file)}", env)
    end
  end

  test do
    (testpath"srcmainjavaBytemanHello.java").write <<~EOS
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    EOS

    (testpath"brew.btm").write <<~EOS
      RULE trace main entry
      CLASS BytemanHello
      METHOD main
      AT ENTRY
      IF true
      DO traceln("Entering main")
      ENDRULE

      RULE trace main exit
      CLASS BytemanHello
      METHOD main
      AT EXIT
      IF true
      DO traceln("Exiting main")
      ENDRULE
    EOS

    system "#{Formula["openjdk"].bin}javac", "srcmainjavaBytemanHello.java"

    actual = shell_output("#{bin}bmjava -l brew.btm -cp srcmainjava BytemanHello")
    assert_match("Hello, Brew!", actual)
  end
end