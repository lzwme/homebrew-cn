class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https:github.comwartremoverwartremover"
  url "https:github.comwartremoverwartremoverarchiverefstagsv3.1.8.tar.gz"
  sha256 "d47b073cc6801d77bf85fd497a861323174903b318eabcd8ac80f18ea3d8b967"
  license "Apache-2.0"
  head "https:github.comwartremoverwartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09b309536a8950553c7f57a77010f73ae7b9d84f4a354b644652dc1d44a523de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b309536a8950553c7f57a77010f73ae7b9d84f4a354b644652dc1d44a523de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b309536a8950553c7f57a77010f73ae7b9d84f4a354b644652dc1d44a523de"
    sha256 cellar: :any_skip_relocation, sonoma:         "09b309536a8950553c7f57a77010f73ae7b9d84f4a354b644652dc1d44a523de"
    sha256 cellar: :any_skip_relocation, ventura:        "09b309536a8950553c7f57a77010f73ae7b9d84f4a354b644652dc1d44a523de"
    sha256 cellar: :any_skip_relocation, monterey:       "09b309536a8950553c7f57a77010f73ae7b9d84f4a354b644652dc1d44a523de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677c7e3592185bdd601c6fae07cbf17e91593aa9162046c4b456c4d04abdcae4"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec"binsbt-launch.jar", "coreassembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end