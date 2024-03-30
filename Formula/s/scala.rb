class Scala < Formula
  desc "JVM-based programming language"
  homepage "https:www.scala-lang.org"
  url "https:github.comlampepfldottyreleasesdownload3.4.1scala3-3.4.1.tar.gz"
  sha256 "4063104c1998afc8dc6563ba5f33837f911d13bd99c0e5dc965ce56edcb0d777"
  license "Apache-2.0"

  livecheck do
    url "https:www.scala-lang.orgdownload"
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d28546deb1ec852ce2756ce26c7e6a6360a9edf309d24ec9c05101556570abf3"
  end

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