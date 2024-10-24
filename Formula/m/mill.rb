class Mill < Formula
  desc "Scala build tool"
  homepage "https:mill-build.commillScala_Intro_to_Mill.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.12.00.12.0-assembly"
  sha256 "cb82ad059d4fe9398a6882f62be315be7e735fc9cec4b8da26479709be128ccf"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ffed0993262a80d1f64fc092e0fe38f4ed185b8e2c3ab166dc76241a2e5c0ce"
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