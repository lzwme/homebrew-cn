class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https:byteman.jboss.org"
  url "https:downloads.jboss.orgbyteman4.0.25byteman-download-4.0.25-bin.zip"
  sha256 "9c76a2f7024c6be951a5d3ec2856171cbefa63310a295309b2e8332e3d5b595f"
  license "LGPL-2.1-or-later"
  head "https:github.combytemanprojectbyteman.git", branch: "main"

  livecheck do
    url "https:byteman.jboss.orgdownloads.html"
    regex(href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d0503439e03b0c8fa1116d1dd3d259add898833d8b6a5a97f5a3a44048f71f1"
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
    (testpath"srcmainjavaBytemanHello.java").write <<~JAVA
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    JAVA

    (testpath"brew.btm").write <<~BTM
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
    BTM

    system "#{Formula["openjdk"].bin}javac", "srcmainjavaBytemanHello.java"

    actual = shell_output("#{bin}bmjava -l brew.btm -cp srcmainjava BytemanHello")
    assert_match("Hello, Brew!", actual)
  end
end