class Mill < Formula
  desc "Scala build tool"
  homepage "https:mill-build.commillScala_Intro_to_Mill.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.12.30.12.3-assembly"
  sha256 "86acc0b9869d09c8983ecfdbeb39682d47eb585e2b46d94148cc528fbb4b83b8"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "969c82e48e12ff85d907dbeeb620536a3fc345e9cde52cbc771588446587bbab"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec"mill"
    (bin"mill").write_env_script libexec"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath"build.sc").write <<~SCALA
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.13.11"
      }
    SCALA
    output = shell_output("#{bin}mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end