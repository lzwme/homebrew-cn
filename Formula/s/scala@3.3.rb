class ScalaAT33 < Formula
  desc "JVM-based programming language"
  homepage "https:www.scala-lang.org"
  url "https:github.comlampepfldottyreleasesdownload3.3.4scala3-3.3.4.tar.gz"
  sha256 "fd0eca29ef1f6c41874b6711e7b6514f1dc7c387c087742fb873f6e720963770"
  license "Apache-2.0"

  livecheck do
    url "https:www.scala-lang.orgdownload"
    regex(%r{href=.*?downloadv?(3\.3(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40166c22ccdaae0310165bb729cc34b4d38ec4c07497812a0f94f6ef74aaaa88"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    rm Dir["bin*.bat"]
    libexec.install "lib"
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