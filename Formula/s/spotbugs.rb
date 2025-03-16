class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https:spotbugs.github.io"
  url "https:repo.maven.apache.orgmaven2comgithubspotbugsspotbugs4.9.3spotbugs-4.9.3.tgz"
  sha256 "d464d56050cf1dbda032e9482e1188f7cd7b7646eaff79c2e6cbe4d6822f4d9f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https:repo.maven.apache.orgmaven2comgithubspotbugsspotbugs"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04bc55a24780bb678bad33c70d61444aa1884a76b2f6ea79ee6140c9ecd92c8f"
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