class Mill < Formula
  desc "Scala build tool"
  homepage "https:com-lihaoyi.github.iomillmillIntro_to_Mill.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.11.80.11.8-assembly"
  sha256 "1ce4537b1233af16d68dc1ab4b9f49a996e8c460b393cc0a7f778a328606aab2"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0074a7a8c087e399795bc061b75e8658f1bf5f0174b857766e8cf8cac51df2e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0074a7a8c087e399795bc061b75e8658f1bf5f0174b857766e8cf8cac51df2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0074a7a8c087e399795bc061b75e8658f1bf5f0174b857766e8cf8cac51df2e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0074a7a8c087e399795bc061b75e8658f1bf5f0174b857766e8cf8cac51df2e6"
    sha256 cellar: :any_skip_relocation, ventura:        "0074a7a8c087e399795bc061b75e8658f1bf5f0174b857766e8cf8cac51df2e6"
    sha256 cellar: :any_skip_relocation, monterey:       "0074a7a8c087e399795bc061b75e8658f1bf5f0174b857766e8cf8cac51df2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b9fa828dbc215635a723db587f676c6af2f626227dc5608d0f4f62af6ed62e"
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