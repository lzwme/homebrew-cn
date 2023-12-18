class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https:pmd.github.io"
  url "https:github.compmdpmdreleasesdownloadpmd_releases6.55.0pmd-bin-6.55.0.zip"
  sha256 "21acf96d43cb40d591cacccc1c20a66fc796eaddf69ea61812594447bac7a11d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "836acbfe2da9e6da7e6319b9c614062758a797c866fa7c675d5867ff5799e091"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin*.bat"]
    libexec.install Dir["*"]
    (bin"pmd").write_env_script libexec"binrun.sh", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      Run with `pmd` (instead of `run.sh` as described in the documentation).
    EOS
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

    system "#{bin}pmd", "pmd", "-d", "#{testpath}java", "-R",
      "rulesetsjavabasic.xml", "-f", "textcolor", "-l", "java"
  end
end