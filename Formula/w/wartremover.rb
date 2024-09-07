class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https:github.comwartremoverwartremover"
  url "https:github.comwartremoverwartremoverarchiverefstagsv3.2.1.tar.gz"
  sha256 "d6aad95215df982a7263b527c69d30b0582eaec2d679cfb67c4c3611bfd844f6"
  license "Apache-2.0"
  head "https:github.comwartremoverwartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cccfb84da0d35d1c638a07ab2a5568f23596323ea4639d4969cab6b891041cb"
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