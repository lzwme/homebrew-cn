class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https:pmd.github.io"
  url "https:github.compmdpmdreleasesdownloadpmd_releases%2F7.7.0pmd-dist-7.7.0-bin.zip"
  sha256 "be8bf68f6c1d66984bd9645a93e631b78a1c2f42f5f0f8719082fead67553940"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5b57051fa5234d48b16120c184ebb21d87d6b118460de6fe6fbfcfea195472e"
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