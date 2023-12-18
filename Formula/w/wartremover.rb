class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https:github.comwartremoverwartremover"
  url "https:github.comwartremoverwartremoverarchiverefstagsv3.1.5.tar.gz"
  sha256 "92da2f92c443fefe93446e14d63c8e6952246e249be137742dee770dd1bc50e7"
  license "Apache-2.0"
  head "https:github.comwartremoverwartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "20ecbaba748edb900eefd24f0d42f6644a35ac2a892b352d6c4f33926213ee32"
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