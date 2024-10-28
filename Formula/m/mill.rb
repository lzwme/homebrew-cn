class Mill < Formula
  desc "Scala build tool"
  homepage "https:mill-build.commillScala_Intro_to_Mill.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.12.10.12.1-assembly"
  sha256 "fccafd6927925bb0e6c30b004d4f54f3f372b2f49aa3f556c545a5439c3b771f"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "084c812a3b51ff7c238ccfa997c7b89e33e4cec66f5155fa26d6e9966a334c40"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec"mill"
    (bin"mill").write_env_script libexec"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.13.11"
      }
    EOS
    output = shell_output("#{bin}mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end