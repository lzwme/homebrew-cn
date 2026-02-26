class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://dotty.epfl.ch/"
  url "https://ghfast.top/https://github.com/scala/scala3/releases/download/3.8.2/scala3-3.8.2.tar.gz"
  sha256 "827356a78a70d3d792f1a77e109cc3fa3ea946b8d26848bb245f275be52fd78e"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2d8ad6f10164bd6fc0b6e7077bd508a652d5723289ee1b14b8ee78faa91e0fe"
  end

  # JDK Compatibility: https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html
  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    rm Dir["bin/*.bat"]

    libexec.install "lib", "maven2", "VERSION", "libexec"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~SCALA
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    SCALA

    out = shell_output("#{bin}/scala --server=false #{file}").strip

    assert_equal "4", out
  end
end