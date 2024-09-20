class Scala < Formula
  desc "JVM-based programming language"
  homepage "https:www.scala-lang.org"
  url "https:github.comscalascala3releasesdownload3.5.0scala3-3.5.0.tar.gz"
  sha256 "bacad178623f1940dae7d75c54c75aaf53f14f07ae99803be730a1d7d51a612d"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https:www.scala-lang.orgdownload"
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "374e847bf9fb8ffd7384b194fefe3922542c60e1b543f20993ec507c041335c6"
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
    file.write <<~EOS
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}scala #{file}").strip

    assert_equal "4", out
  end
end