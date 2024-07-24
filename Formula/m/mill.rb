class Mill < Formula
  desc "Scala build tool"
  homepage "https:mill-build.commillIntro_to_Mill_for_Scala.html"
  url "https:github.comcom-lihaoyimillreleasesdownload0.11.100.11.10-assembly"
  sha256 "fc855679352ede9895f3449f6ea7921bab674540d3a40ca805c6de0957a55297"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9955755ece4918b589a3dc034e5a907d94b58c03517d7583358bc6324e2a0128"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9955755ece4918b589a3dc034e5a907d94b58c03517d7583358bc6324e2a0128"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9955755ece4918b589a3dc034e5a907d94b58c03517d7583358bc6324e2a0128"
    sha256 cellar: :any_skip_relocation, sonoma:         "9955755ece4918b589a3dc034e5a907d94b58c03517d7583358bc6324e2a0128"
    sha256 cellar: :any_skip_relocation, ventura:        "d921df589be6909fe8d14110c2c3ba495fb54d03d4dbeb6002f5d67a7853cccd"
    sha256 cellar: :any_skip_relocation, monterey:       "9955755ece4918b589a3dc034e5a907d94b58c03517d7583358bc6324e2a0128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb19f51e773ee887ce884d9281902c2d32506198d7eba10ea33584c78ce16b5e"
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