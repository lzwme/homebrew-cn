class Scala < Formula
  desc "JVM-based programming language"
  homepage "https:dotty.epfl.ch"
  url "https:github.comscalascala3releasesdownload3.7.0scala3-3.7.0.tar.gz"
  sha256 "4f6cc6aafd974a3740dedd05689be575cb61829811acc4f2891ce796040e9811"
  license "Apache-2.0"

  livecheck do
    url "https:www.scala-lang.orgdownload"
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dbf4cdbed9be74c8ff5b292d99dbb940017c6a5cdda1f274d18dd647a16cc84"
  end

  # JDK Compatibility: https:docs.scala-lang.orgoverviewsjdk-compatibilityoverview.html
  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    rm Dir["bin*.bat"]

    libexec.install "lib", "maven2", "VERSION", "libexec"
    prefix.install "bin"
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env

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