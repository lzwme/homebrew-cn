class Scala < Formula
  desc "JVM-based programming language"
  homepage "https:www.scala-lang.org"
  url "https:github.comscalascala3releasesdownload3.6.2scala3-3.6.2.tar.gz"
  sha256 "9525b93f8b9488330ecbdb85df3046d3ef46c6760ac23248902c4d89194c5206"
  license "Apache-2.0"

  livecheck do
    url "https:www.scala-lang.orgdownload"
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9836e7809cd8da0a45de3e6b212b452a538a102b750b356f4e9111d3d2aca94c"
  end

  # JDK Compatibility: https:docs.scala-lang.orgoverviewsjdk-compatibilityoverview.html
  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    # fix `scala-cli.jar` path, upstream pr ref, https:github.comscalascala3pull22185
    inreplace "libexeccli-common-platform", "binscala-cli", "libexecscala-cli"

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