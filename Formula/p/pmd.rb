class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https:pmd.github.io"
  url "https:github.compmdpmdreleasesdownloadpmd_releases%2F7.0.0pmd-dist-7.0.0-bin.zip"
  sha256 "24be4bde2846cabea84e75e790ede1b86183f85f386cb120a41372f2b4844a54"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc1cbdce66b9dfa7b0952f6329aa3c6f0e5ef613de09ebd992f6b5bae4e18a6f"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin*.bat"]
    libexec.install Dir["*"]
    (bin"pmd").write_env_script libexec"binpmd", Language::Java.overridable_java_home_env
  end

  test do
    (testpath"javatestClass.java").write <<~EOS
      public class BrewTestClass {
         dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    EOS

    output = shell_output("#{bin}pmd check -d #{testpath}java " \
                          "-R categoryjavabestpractices.xml -f json")
    assert_empty JSON.parse(output)["processingErrors"]
  end
end