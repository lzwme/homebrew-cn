class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https:byteman.jboss.org"
  url "https:downloads.jboss.orgbyteman4.0.22byteman-download-4.0.22-bin.zip"
  sha256 "2f7e5db3d51b9ae8497a7255da2465d9501c6cb2f55ab954ba6e43152d23ec3b"
  license "LGPL-2.1-or-later"
  head "https:github.combytemanprojectbyteman.git", branch: "main"

  livecheck do
    url "https:byteman.jboss.orgdownloads.html"
    regex(href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f08c5658f72ec1cf550c83af45cdcb1b346499db993d1d7feba063943f9ded2a"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin*.bat"]
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