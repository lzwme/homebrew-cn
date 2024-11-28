class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https:github.comwartremoverwartremover"
  url "https:github.comwartremoverwartremoverarchiverefstagsv3.2.5.tar.gz"
  sha256 "ca0770ac24babfef1e16f168aae5ac98118343686e30088de5a65e26f8afc5a4"
  license "Apache-2.0"
  head "https:github.comwartremoverwartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dff546b54c6b14fe3be0e0b3ec7d05f4adb5e2343b6ca8dedda09aa6fe8233a9"
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