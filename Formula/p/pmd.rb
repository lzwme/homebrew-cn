class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https:pmd.github.io"
  url "https:github.compmdpmdreleasesdownloadpmd_releases%2F7.4.0pmd-dist-7.4.0-bin.zip"
  sha256 "1dcbb7784a7fba1fd3c6efbaf13dcb63f05fe069fcf026ad5e2933711ddf5026"
  license "BSD-4-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1be91bbcca0769b160561bec1ee9b09c82022b9bbd5237bcb532a3bb6ca31653"
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