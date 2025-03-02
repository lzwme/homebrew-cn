class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https:spotbugs.github.io"
  url "https:repo.maven.apache.orgmaven2comgithubspotbugsspotbugs4.9.2spotbugs-4.9.2.tgz"
  sha256 "ecee09196ce66ab686b6a874047107b01f51a6ee2fb9b8604ce64d88688a1400"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https:repo.maven.apache.orgmaven2comgithubspotbugsspotbugs"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a918a3c63e7bea26b4a57c1905551c08d33f6945ec04e54ba8db47f0c120849"
  end

  head do
    url "https:github.comspotbugsspotbugs.git", branch: "master"

    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  conflicts_with "fb-client", because: "both install a `fb` binary"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    if build.head?
      system "gradle", "build"
      system "gradle", "installDist"
      libexec.install Dir["spotbugsbuildinstallspotbugs*"]
    else
      libexec.install Dir["*"]
      chmod 0755, "#{libexec}binspotbugs"
    end
    (bin"spotbugs").write_env_script "#{libexec}binspotbugs", Language::Java.overridable_java_home_env
  end

  test do
    (testpath"HelloWorld.java").write <<~JAVA
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    JAVA
    system Formula["openjdk"].bin"javac", "HelloWorld.java"
    system Formula["openjdk"].bin"jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}spotbugs -textui HelloWorld.jar")
    assert_match(M V EI.*\nM C UwF.*\n, output)
  end
end