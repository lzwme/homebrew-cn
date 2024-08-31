class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https:pmd.github.io"
  url "https:github.compmdpmdreleasesdownloadpmd_releases%2F7.5.0pmd-dist-7.5.0-bin.zip"
  sha256 "d188d592409033712bf7b99dc739ca6c238f296c6dbe6bc5f95e9403684c8ee1"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d937c7207bcec7e95bfd21f1f4cccf3bd6fcd97062c18a000ab8703518434709"
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