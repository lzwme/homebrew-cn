class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https:github.comwartremoverwartremover"
  url "https:github.comwartremoverwartremoverarchiverefstagsv3.2.3.tar.gz"
  sha256 "623ba6890d8ecb69d921b13d863b52aed351d295d9037885f9c424ea9b85df3b"
  license "Apache-2.0"
  head "https:github.comwartremoverwartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e12d70e5dff19f691e1fefff8e951f4356ec9a144ab07bd4c72a32911614f4d"
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