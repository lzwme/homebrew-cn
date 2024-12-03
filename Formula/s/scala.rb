class Scala < Formula
  desc "JVM-based programming language"
  homepage "https:www.scala-lang.org"
  url "https:github.comscalascala3releasesdownload3.5.2scala3-3.5.2.tar.gz"
  sha256 "899de4f9aca56989ce337d8390fbf94967bc70c9e8420e79f375d1c2ad00ff99"
  license "Apache-2.0"

  livecheck do
    url "https:www.scala-lang.orgdownload"
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7a0c887cea761759face114d09e5b29559dac305e7695dd9c0273f039f8edf1e"
  end

  # Switch back to `openjdk` when supported:
  # https:docs.scala-lang.orgoverviewsjdk-compatibilityoverview.html
  depends_on "openjdk@21"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    rm Dir["bin*.bat"]
    libexec.install "lib"
    libexec.install "maven2"
    libexec.install "VERSION"
    prefix.install "bin"
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env("21")

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix"idea"
    idea.install_symlink libexec"lib"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}idea
    EOS
  end

  test do
    file = testpath"Test.scala"
    file.write <<~SCALA
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    SCALA

    out = shell_output("#{bin}scala #{file}").strip

    assert_equal "4", out
  end
end