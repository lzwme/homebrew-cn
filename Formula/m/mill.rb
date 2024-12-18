class Mill < Formula
  desc "Scala build tool"
  homepage "https:mill-build.commillScala_Intro_to_Mill.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.12.40.12.4-assembly"
  sha256 "5a5ca4c8dc97522b51e851db8595ce7892ad302aefa092b582bba1f86fe191bf"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f28042b2b84dde783e5eb2b480a7b01be3b109dd7c507ebb47eb18c29979bd4"
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