class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https:pmd.github.io"
  url "https:github.compmdpmdreleasesdownloadpmd_releases%2F7.8.0pmd-dist-7.8.0-bin.zip"
  sha256 "d16077bb9aa471f78cda7a4f7ad84f163514b561316538e04d85157fee1fba10"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7de9475b5807a48681849c34d07cc6efada1a4fd7a08a9cd749770cce23da6c6"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin*.bat"]
    libexec.install Dir["*"]
    (bin"pmd").write_env_script libexec"binpmd", Language::Java.overridable_java_home_env
  end

  test do
    (testpath"javatestClass.java").write <<~JAVA
      public class BrewTestClass {
         dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    JAVA

    output = shell_output("#{bin}pmd check -d #{testpath}java " \
                          "-R categoryjavabestpractices.xml -f json")
    assert_empty JSON.parse(output)["processingErrors"]
  end
end