class Mill < Formula
  desc "Scala build tool"
  homepage "https:com-lihaoyi.github.iomillmillIntro_to_Mill.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.11.60.11.6-assembly"
  sha256 "bc68639ce2af47645d805c775ac336d7b48ef6070a6649cf69fecb2a8dd224f5"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22799313fdf569a84e9f1b9cebcd8a06ceb61284fde9c49babf00bc1735eb8d5"
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