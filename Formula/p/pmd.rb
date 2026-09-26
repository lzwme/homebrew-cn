class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://ghfast.top/https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.28.0/pmd-dist-7.28.0-bin.zip"
  sha256 "f974ba571f7bc01c73fffe11bade25fbc1f438698f9e9c00e416e8d65e9fbac2"
  license "BSD-4-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efbf02c59e2be36b5cb215da6fb308952c174bde700d00d898593f78c8e10b59"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/pmd", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"java/BrewTestClass.java").write <<~JAVA
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    JAVA

    output = shell_output("#{bin}/pmd check -d #{testpath}/java " \
                          "-R category/java/bestpractices.xml -f json")
    assert_empty JSON.parse(output)["processingErrors"]
  end
end